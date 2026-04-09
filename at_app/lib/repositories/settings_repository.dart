import 'package:isar/isar.dart';
import '../models/app_settings.dart';
import 'isar_service.dart';

class SettingsRepository {
  Isar get _db => IsarService.instance;

  Future<AppSettings> load() async {
    final existing = await _db.appSettings.get(1);
    if (existing != null) return existing;
    return _defaults();
  }

  Stream<AppSettings> watch() {
    return _db.appSettings.watchObject(1, fireImmediately: true).map(
          (s) => s ?? _defaults(),
        );
  }

  Future<void> save(AppSettings settings) async {
    await _db.writeTxn(() async {
      await _db.appSettings.put(settings);
    });
  }

  AppSettings _defaults() {
    return AppSettings()
      ..deliveryMode = DeliveryMode.free
      ..intervalType = IntervalType.fixed
      ..fixedIntervalMinutes = 20
      ..minIntervalMinutes = 10
      ..maxIntervalMinutes = 30
      ..promptOrder = PromptOrder.random
      ..primaryLibraryUid = 'builtin_all'
      ..alternateLibraryUid = null
      ..lastFiredFrom = LibrarySlot.alternate
      ..lastFiredSequentialIndex = 0
      ..audioMode = AudioMode.silent // system notification sound plays by default
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
  }
}
