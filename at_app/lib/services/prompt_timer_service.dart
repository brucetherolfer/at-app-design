import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
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
  bool _sequenceBusy = false;
  Prompt? _lastFiredPrompt;

  // Batch scheduling state.
  // _batchIndex tracks which pre-scheduled OS notification slot corresponds
  // to the next live fire. Incremented each time the Dart timer fires.
  int _batchIndex = 0;

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

  /// Start — fire an immediate prompt, then schedule 60 OS notifications as
  /// a failsafe batch and begin the Dart countdown.
  Future<void> start() async {
    if (_isRunning && !_isPaused) return;
    _isRunning = true;
    _isPaused = false;

    await AudioService().startSilentLoop();
    if (!_isRunning) return;

    final settings = await _settingsRepo.load();
    if (!_isRunning) return;

    await _firePrompt(settings, isBatchSlot: false);
    if (!_isRunning) return;

    _remaining = _intervalFor(settings);
    _batchIndex = 0;

    // Schedule the full batch of OS notifications as delivery failsafe.
    // Each fires at the pre-calculated time regardless of isolate state.
    unawaited(_scheduleBatch(settings, _remaining));

    _scheduleCountdown();
  }

  /// Pause — suspends prompts, cancels batch (don't want them firing mid-pause).
  void pause() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    unawaited(NotificationService.cancelBatch());
  }

  /// Resume after pause — re-schedule batch from remaining time.
  Future<void> resume() async {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    final settings = await _settingsRepo.load();
    _batchIndex = 0;
    unawaited(_scheduleBatch(settings, _remaining));
    _scheduleCountdown();
  }

  /// Stop and reset everything.
  void stop() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _sequenceBusy = false;
    _batchIndex = 0;
    _remaining = Duration.zero;
    _lastFiredPrompt = null;
    _countdownController.add(_remaining);
    unawaited(NotificationService.cancelBatch());
    AudioService().stopSilentLoop();
  }

  /// Fire immediately then reschedule.
  Future<void> fireNow() async {
    if (!_isRunning) return;
    _timer?.cancel();
    unawaited(NotificationService.cancelBatch());
    final settings = await _settingsRepo.load();
    if (!_isRunning) return;
    await _firePrompt(settings, isBatchSlot: false);
    if (!_isRunning) return;
    _remaining = _intervalFor(settings);
    _batchIndex = 0;
    unawaited(_scheduleBatch(settings, _remaining));
    _scheduleCountdown();
  }

  /// Replay last prompt and reset countdown.
  Future<void> skipBack() async {
    if (!_isRunning) return;
    _timer?.cancel();
    unawaited(NotificationService.cancelBatch());
    final settings = await _settingsRepo.load();
    if (!_isRunning) return;
    if (_lastFiredPrompt != null) {
      await _replayPrompt(_lastFiredPrompt!, settings);
    }
    if (!_isRunning) return;
    _remaining = _intervalFor(settings);
    _batchIndex = 0;
    unawaited(_scheduleBatch(settings, _remaining));
    _scheduleCountdown();
  }

  void _scheduleCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!_isRunning || _isPaused) {
        t.cancel();
        return;
      }
      if (_remaining <= Duration.zero) {
        t.cancel();
        final settings = await _settingsRepo.load();
        if (!_isRunning || _isPaused) return;
        if (await _isInBlackout()) {
          if (!_isRunning || _isPaused) return;
          _remaining = _intervalFor(settings);
          _scheduleCountdown();
          return;
        }
        try {
          await _firePrompt(settings, isBatchSlot: true);
        } catch (e) {
          debugPrint('⚠️ PromptTimerService countdown fire error: $e');
        }
        if (!_isRunning || _isPaused) return;
        if (settings.deliveryMode == DeliveryMode.sequence &&
            settings.sequenceTrigger == SequenceTrigger.onDemand) {
          _remaining = _intervalFor(settings);
          _countdownController.add(_remaining);
          return;
        }
        _remaining = _intervalFor(settings);
        // Reschedule the full 64-slot batch with fresh texts so the rolling
        // window always covers the next 64 prompts regardless of interval.
        unawaited(_scheduleBatch(settings, _remaining));
        _scheduleCountdown();
      } else {
        _remaining -= const Duration(seconds: 1);
        _countdownController.add(_remaining);
      }
    });
  }

  /// Schedule 64 OS notifications with the actual prompt texts.
  ///
  /// Called at session start AND after every live Dart fire — so there are
  /// always 64 prompts queued ahead, regardless of interval length. iOS owns
  /// these; they fire even when the Dart isolate is fully suspended.
  Future<void> _scheduleBatch(AppSettings settings, Duration firstInterval) async {
    final (texts, uids) = await _buildBatchData(settings, NotificationService.batchSize);
    await NotificationService.scheduleBatch(
      firstTime: DateTime.now().add(firstInterval),
      interval: _intervalFor(settings),
      texts: texts,
      uids: uids,
      chimeKey: settings.selectedChime,
    );
  }

  /// Build lists of [count] prompt texts and UIDs for the upcoming batch slots.
  ///
  /// For sequential order: steps through from the current index without
  /// touching the persistent DB counter (pure preview — live fires own state).
  /// For random order: picks randomly from the library.
  Future<(List<String>, List<String>)> _buildBatchData(AppSettings settings, int count) async {
    try {
      final prompts = await _promptRepo.getByLibrary(settings.primaryLibraryUid);
      if (prompts.isEmpty) return (<String>[], <String>[]);

      final texts = <String>[];
      final uids = <String>[];
      if (settings.promptOrder == PromptOrder.sequential) {
        // Peek ahead from current index without advancing the DB counter.
        final startIdx = settings.lastFiredSequentialIndex % prompts.length;
        for (int i = 0; i < count; i++) {
          final p = prompts[(startIdx + i) % prompts.length];
          texts.add(p.text);
          uids.add(p.uid);
        }
      } else {
        for (int i = 0; i < count; i++) {
          final p = prompts[_random.nextInt(prompts.length)];
          texts.add(p.text);
          uids.add(p.uid);
        }
      }
      return (texts, uids);
    } catch (_) {
      return (<String>[], <String>[]);
    }
  }

  Future<bool> _isInBlackout() async {
    final now = DateTime.now();
    final windows = await _blackoutRepo.getAll();
    final dayOfWeek = now.weekday;
    final nowMinutes = now.hour * 60 + now.minute;

    for (final w in windows) {
      if (!w.isEnabled) continue;
      if (!w.daysOfWeek.contains(dayOfWeek)) continue;
      final start = _parseTime(w.startTime);
      final end = _parseTime(w.endTime);
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

  Future<void> _firePrompt(AppSettings settings, {required bool isBatchSlot}) async {
    // If this is a countdown-triggered fire, cancel the corresponding OS
    // notification so it doesn't also show (live audio replaces it).
    if (isBatchSlot) {
      await NotificationService.cancelBatchSlot(_batchIndex);
      _batchIndex++;
    }

    if (settings.deliveryMode == DeliveryMode.sequence) {
      if (_sequenceBusy) {
        debugPrint('⚠️ Sequence already running — ignoring concurrent fire');
        return;
      }
      _sequenceBusy = true;
      try {
        final prompts = await _promptRepo.getByLibrary(settings.primaryLibraryUid);
        if (prompts.isEmpty) {
          throw StateError(
              'No prompts found in library "${settings.primaryLibraryUid}". '
              'Open Settings and check your active library.');
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
            await Future.delayed(Duration(
              seconds: settings.sequenceGapSeconds > 0
                  ? settings.sequenceGapSeconds
                  : 2,
            ));
          }
        }
      } finally {
        _sequenceBusy = false;
      }
      return;
    }

    final prompt = await _pickPrompt(settings);
    if (prompt == null) {
      throw StateError(
          'No prompts found in library "${settings.primaryLibraryUid}". '
          'Open Settings and check your active library.');
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
    await NotificationService.showPrompt(prompt.text);
    await AudioService().playPrompt(
      text: prompt.text,
      mode: settings.audioMode,
      chimeAsset: settings.selectedChime,
      voiceName: settings.selectedVoiceName,
      speechRate: settings.speechRate,
      speechPitch: settings.speechPitch,
      promptUid: prompt.uid,
    );
  }

  Future<Prompt?> _pickPrompt(AppSettings settings) async {
    final useAlternate = settings.alternateLibraryUid != null &&
        settings.lastFiredFrom == LibrarySlot.primary;
    final libraryUid = useAlternate
        ? settings.alternateLibraryUid!
        : settings.primaryLibraryUid;

    settings.lastFiredFrom =
        useAlternate ? LibrarySlot.alternate : LibrarySlot.primary;
    await _settingsRepo.save(settings);

    final prompts = await _promptRepo.getByLibrary(libraryUid);
    if (prompts.isEmpty) return null;

    if (settings.promptOrder == PromptOrder.sequential) {
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
          : 1200;
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
