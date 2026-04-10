import 'package:isar/isar.dart';

part 'app_settings.g.dart';

enum DeliveryMode { free, sequence }
enum IntervalType { fixed, random }
enum PromptOrder { random, sequential }
enum AudioMode { silent, tone, voice, toneAndVoice }
enum SequenceTrigger { onDemand, timer }
enum LibrarySlot { primary, alternate }
enum VisualMode { day, night }

@collection
class AppSettings {
  // Always use id = 1 (singleton)
  Id id = 1;

  @enumerated
  late DeliveryMode deliveryMode;

  @enumerated
  late IntervalType intervalType;

  late int fixedIntervalSeconds;

  late int minIntervalMinutes;

  late int maxIntervalMinutes;

  @enumerated
  late PromptOrder promptOrder;

  // Active library UIDs (multi-select)
  late String primaryLibraryUid;
  String? alternateLibraryUid; // null = alternating off

  @enumerated
  late LibrarySlot lastFiredFrom;

  late int lastFiredSequentialIndex;        // primary library position
  late int lastFiredAltSequentialIndex;     // alternate library position

  @enumerated
  late AudioMode audioMode;

  late String selectedVoiceName;

  late double speechRate;

  late double speechPitch;

  late String selectedChime; // asset key

  @enumerated
  late SequenceTrigger sequenceTrigger;

  late int sequenceTimerMinutes;

  late int sequenceGapSeconds; // gap between prompts in sequence mode (default 2)

  String? activeSequenceUid;

  late bool isRunning;

  late bool isPaused;

  @enumerated
  late VisualMode visualMode;
}
