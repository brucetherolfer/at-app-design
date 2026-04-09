import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import 'repository_providers.dart';

final settingsStreamProvider = StreamProvider<AppSettings>((ref) {
  return ref.watch(settingsRepositoryProvider).watch();
});

final settingsProvider = Provider<AppSettings>((ref) {
  // Prefer notifier state — updates immediately when _save() completes
  final notifierValue = ref.watch(settingsNotifierProvider).valueOrNull;
  if (notifierValue != null) return notifierValue;
  // Fall back to Isar stream (handles initial load and cross-session changes)
  return ref.watch(settingsStreamProvider).valueOrNull ??
      AppSettings()
        ..deliveryMode = DeliveryMode.free
        ..intervalType = IntervalType.fixed
        ..fixedIntervalSeconds = 420
        ..minIntervalMinutes = 10
        ..maxIntervalMinutes = 30
        ..promptOrder = PromptOrder.random
        ..primaryLibraryUid = 'builtin_fms_directions'
        ..alternateLibraryUid = null
        ..lastFiredFrom = LibrarySlot.alternate
        ..lastFiredSequentialIndex = 0
        ..audioMode = AudioMode.silent
        ..selectedVoiceName = ''
        ..speechRate = 0.5
        ..speechPitch = 1.0
        ..selectedChime = 'bell'
        ..sequenceTrigger = SequenceTrigger.onDemand
        ..sequenceTimerMinutes = 60
        ..activeSequenceUid = null
        ..isRunning = false
        ..isPaused = false
        ..visualMode = VisualMode.day;
});

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    return ref.watch(settingsRepositoryProvider).load();
  }

  Future<void> _save(AppSettings Function(AppSettings s) updater) async {
    final current = await future;
    final updated = updater(current);
    await ref.read(settingsRepositoryProvider).save(updated);
    state = AsyncData(updated);
  }

  Future<void> setDeliveryMode(DeliveryMode mode) =>
      _save((s) => s..deliveryMode = mode);

  Future<void> setIntervalType(IntervalType type) =>
      _save((s) => s..intervalType = type);

  Future<void> setFixedInterval(int seconds) =>
      _save((s) => s..fixedIntervalSeconds = seconds);

  Future<void> setRandomInterval(int min, int max) =>
      _save((s) => s..minIntervalMinutes = min..maxIntervalMinutes = max);

  Future<void> setPromptOrder(PromptOrder order) =>
      _save((s) => s..promptOrder = order);

  Future<void> setPrimaryLibrary(String uid) =>
      _save((s) => s..primaryLibraryUid = uid);

  Future<void> setAlternateLibrary(String? uid) =>
      _save((s) => s..alternateLibraryUid = uid);

  Future<void> setAudioMode(AudioMode mode) =>
      _save((s) => s..audioMode = mode);

  Future<void> setVoice(String name) =>
      _save((s) => s..selectedVoiceName = name);

  Future<void> setSpeechRate(double rate) =>
      _save((s) => s..speechRate = rate);

  Future<void> setSpeechPitch(double pitch) =>
      _save((s) => s..speechPitch = pitch);

  Future<void> setChime(String key) =>
      _save((s) => s..selectedChime = key);

  Future<void> setSequenceTrigger(SequenceTrigger trigger) =>
      _save((s) => s..sequenceTrigger = trigger);

  Future<void> setSequenceTimerMinutes(int minutes) =>
      _save((s) => s..sequenceTimerMinutes = minutes);

  Future<void> setActiveSequence(String? uid) =>
      _save((s) => s..activeSequenceUid = uid);

  Future<void> setVisualMode(VisualMode mode) =>
      _save((s) => s..visualMode = mode);

  Future<void> setRunning(bool running) =>
      _save((s) => s..isRunning = running);

  Future<void> setPaused(bool paused) =>
      _save((s) => s..isPaused = paused);
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
