import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import '../models/blackout_window.dart';
import '../models/prompt.dart';
import '../repositories/prompt_repository.dart';
import '../repositories/blackout_repository.dart';
import '../repositories/settings_repository.dart';
import 'notification_service.dart';
import 'audio_service.dart';

class PromptTimerService {
  static final PromptTimerService _instance = PromptTimerService._internal();
  factory PromptTimerService() => _instance;
  PromptTimerService._internal();

  Timer? _timer;
  final _countdownController = StreamController<Duration>.broadcast();
  Duration _remaining = Duration.zero;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _sequenceBusy = false; // guard: prevents concurrent sequence plays
  Prompt? _lastFiredPrompt;

  final _promptFiredController = StreamController<String>.broadcast();

  Stream<Duration> get countdownStream => _countdownController.stream;
  Stream<String> get promptFiredStream => _promptFiredController.stream;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  Duration get remaining => _remaining;

  final _random = Random();
  final _promptRepo = PromptRepository();
  final _blackoutRepo = BlackoutRepository();
  final _settingsRepo = SettingsRepository();

  /// Start the timer from settings — fires a prompt immediately, then
  /// begins the countdown to the next one.
  Future<void> start() async {
    if (_isRunning && !_isPaused) return;
    _isRunning = true;
    _isPaused = false;

    // Silent loop keeps AVAudioSession active so iOS doesn't suspend the app
    // when the screen locks or another app comes to the foreground.
    await AudioService().startSilentLoop();
    if (!_isRunning) return; // stop() called while awaiting

    final settings = await _settingsRepo.load();
    if (!_isRunning) return; // stop() called while awaiting

    await _firePrompt(settings);
    if (!_isRunning) return; // stop() called while awaiting

    _remaining = _intervalFor(settings);
    _scheduleCountdown();
  }

  /// Pause — suspends prompts without resetting. Silent loop stays running
  /// so the app remains alive and can be resumed.
  void pause() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    // Note: silent loop intentionally kept running during pause so iOS
    // doesn't kill the app before the user resumes.
  }

  /// Resume after pause.
  Future<void> resume() async {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    _scheduleCountdown();
  }

  /// Stop and reset.
  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _sequenceBusy = false;
    _remaining = Duration.zero;
    _lastFiredPrompt = null;
    _countdownController.add(_remaining);
    AudioService().stopSilentLoop();
  }

  /// Fire the next prompt immediately, then reschedule.
  Future<void> fireNow() async {
    if (!_isRunning) return;
    _timer?.cancel();
    final settings = await _settingsRepo.load();
    if (!_isRunning) return;
    await _firePrompt(settings);
    if (!_isRunning) return;
    _remaining = _intervalFor(settings);
    _scheduleCountdown();
  }

  /// Skip back — replay the last fired prompt (if any) and reset the countdown.
  Future<void> skipBack() async {
    if (!_isRunning) return;
    _timer?.cancel();
    final settings = await _settingsRepo.load();
    if (!_isRunning) return;
    if (_lastFiredPrompt != null) {
      await _replayPrompt(_lastFiredPrompt!, settings);
    }
    if (!_isRunning) return;
    _remaining = _intervalFor(settings);
    _scheduleCountdown();
  }

  void _scheduleCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      // Check at every tick — stop() or pause() may have been called
      if (!_isRunning || _isPaused) {
        t.cancel();
        return;
      }
      if (_remaining <= Duration.zero) {
        t.cancel();
        // Reload settings fresh so changes to audio mode, sound, interval etc.
        // take effect immediately without requiring a stop/start.
        final settings = await _settingsRepo.load();
        if (!_isRunning || _isPaused) return; // cancelled while awaiting
        if (await _isInBlackout()) {
          if (!_isRunning || _isPaused) return; // cancelled while awaiting
          _remaining = _intervalFor(settings);
          _scheduleCountdown();
          return;
        }
        try {
          await _firePrompt(settings);
        } catch (e) {
          debugPrint('⚠️ PromptTimerService countdown fire error: $e');
          // Don't stop the timer — keep scheduling even if one prompt fails.
          // The user will see the on-screen error the first time (from start()),
          // subsequent misses are logged only.
        }
        if (!_isRunning || _isPaused) return; // cancelled while awaiting
        // In sequence mode with on-demand trigger: don't auto-reschedule.
        // User fires manually via FIRE button. Countdown resets to full but
        // won't fire again on its own.
        if (settings.deliveryMode == DeliveryMode.sequence &&
            settings.sequenceTrigger == SequenceTrigger.onDemand) {
          _remaining = _intervalFor(settings);
          _countdownController.add(_remaining);
          return; // no _scheduleCountdown() — stops auto-repeat
        }
        _remaining = _intervalFor(settings);
        _scheduleCountdown();
      } else {
        _remaining -= const Duration(seconds: 1);
        _countdownController.add(_remaining);
      }
    });
  }

  Future<bool> _isInBlackout() async {
    final now = DateTime.now();
    final windows = await _blackoutRepo.getAll();
    final dayOfWeek = now.weekday; // 1=Mon, 7=Sun
    final nowMinutes = now.hour * 60 + now.minute;

    for (final w in windows) {
      if (!w.isEnabled) continue;
      if (!w.daysOfWeek.contains(dayOfWeek)) continue;
      final start = _parseTime(w.startTime);
      final end = _parseTime(w.endTime);
      // Handle overnight windows (e.g. 22:00–07:00)
      if (start <= end) {
        if (nowMinutes >= start && nowMinutes < end) return true;
      } else {
        if (nowMinutes >= start || nowMinutes < end) return true;
      }
    }
    return false;
  }

  int _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Future<void> _firePrompt(AppSettings settings) async {
    if (settings.deliveryMode == DeliveryMode.sequence) {
      // Guard: only one sequence plays at a time.
      // Pressing FIRE while a sequence is already running is ignored.
      if (_sequenceBusy) {
        debugPrint('⚠️ Sequence already running — ignoring concurrent fire');
        return;
      }
      _sequenceBusy = true;
      try {
        final prompts =
            await _promptRepo.getByLibrary(settings.primaryLibraryUid);
        if (prompts.isEmpty) {
          throw StateError(
              'No prompts found in library "${settings.primaryLibraryUid}". Open Settings and check your active library.');
        }
        for (int i = 0; i < prompts.length; i++) {
          if (!_isRunning || _isPaused) return;
          final prompt = prompts[i];
          _lastFiredPrompt = prompt;
          _promptFiredController.add(prompt.text);
          debugPrint('🔔 Sequence ${i + 1}/${prompts.length}: "${prompt.text}"');
          await _deliverPrompt(prompt, settings);
          if (i < prompts.length - 1) {
            if (!_isRunning || _isPaused) return;
            final gapSecs = settings.sequenceGapSeconds > 0
                ? settings.sequenceGapSeconds
                : 2;
            await Future.delayed(Duration(seconds: gapSecs));
          }
        }
      } finally {
        _sequenceBusy = false;
      }
      return;
    }

    final prompt = await _pickPrompt(settings);
    if (prompt == null) {
      debugPrint('⚠️ PromptTimerService: no prompts in library "${settings.primaryLibraryUid}" — cannot fire');
      throw StateError('No prompts found in library "${settings.primaryLibraryUid}". Open Settings and check your active library.');
    }
    _lastFiredPrompt = prompt;
    debugPrint('🔔 PromptTimerService: firing "${prompt.text}"');
    await _deliverPrompt(prompt, settings);
  }

  Future<void> _replayPrompt(Prompt prompt, AppSettings settings) async {
    await _deliverPrompt(prompt, settings);
  }

  Future<void> _deliverPrompt(Prompt prompt, AppSettings settings) async {
    _promptFiredController.add(prompt.text);

    // Notification
    await NotificationService.showPrompt(prompt.text);

    // Audio
    await AudioService().playPrompt(
      text: prompt.text,
      mode: settings.audioMode,
      chimeAsset: settings.selectedChime,
      voiceName: settings.selectedVoiceName,
      speechRate: settings.speechRate,
      speechPitch: settings.speechPitch,
    );
  }

  Future<Prompt?> _pickPrompt(AppSettings settings) async {
    // Alternating library mode
    final useAlternate = settings.alternateLibraryUid != null &&
        settings.lastFiredFrom == LibrarySlot.primary;

    final libraryUid = useAlternate
        ? settings.alternateLibraryUid!
        : settings.primaryLibraryUid;

    // Update lastFiredFrom
    final newSlot = useAlternate ? LibrarySlot.alternate : LibrarySlot.primary;
    settings.lastFiredFrom = newSlot;
    await _settingsRepo.save(settings);

    final prompts = await _promptRepo.getByLibrary(libraryUid);
    if (prompts.isEmpty) return null;

    if (settings.promptOrder == PromptOrder.sequential) {
      // Use separate counters so primary and alternate each step through
      // their own libraries independently. A shared counter causes each
      // library to skip every other prompt when alternating.
      final int rawIndex;
      if (useAlternate) {
        rawIndex = settings.lastFiredAltSequentialIndex % prompts.length;
        settings.lastFiredAltSequentialIndex = rawIndex + 1;
      } else {
        rawIndex = settings.lastFiredSequentialIndex % prompts.length;
        settings.lastFiredSequentialIndex = rawIndex + 1;
      }
      await _settingsRepo.save(settings);
      return prompts[rawIndex];
    } else {
      return prompts[_random.nextInt(prompts.length)];
    }
  }

  Duration _intervalFor(AppSettings settings) {
    if (settings.intervalType == IntervalType.fixed) {
      final secs = settings.fixedIntervalSeconds > 0
          ? settings.fixedIntervalSeconds
          : 1200; // fallback if DB has stale 0 from old schema
      return Duration(seconds: secs);
    } else {
      final min = settings.minIntervalMinutes;
      final max = settings.maxIntervalMinutes;
      final minutes = min + _random.nextInt(max - min + 1);
      return Duration(minutes: minutes);
    }
  }

  void dispose() {
    _timer?.cancel();
    _countdownController.close();
    _promptFiredController.close();
  }
}
