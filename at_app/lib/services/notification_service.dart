import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static int _notifId = 0;

  // Batch slot IDs: 2000–2063 (64 slots — iOS pending notification limit).
  // Pre-scheduled at session start and re-scheduled on every live fire so
  // there are always 64 prompts queued ahead regardless of interval length.
  static const _batchBase = 2000;
  static const batchSize = 64;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    if (Platform.isIOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: false, sound: true);
    }

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  // ── Immediate notification (Dart timer fired on time) ─────────────────────

  static Future<void> showPrompt(String promptText) async {
    _notifId = (_notifId + 1) % 1000;
    const androidDetails = AndroidNotificationDetails(
      'at_prompts',
      'AT Prompts',
      channelDescription: 'Alexander Technique awareness prompts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    await _plugin.show(
      _notifId, 'Prompt', promptText,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  // ── Batch scheduling ───────────────────────────────────────────────────────

  /// Schedule [batchSize] notifications with the actual prompt texts, all
  /// in parallel. Called at session start and re-called on every live Dart
  /// fire — so there are always 64 prompts scheduled ahead regardless of
  /// how short the interval is.
  ///
  /// [texts] should contain [batchSize] strings. If shorter, the last text
  /// repeats. If empty, a generic fallback is used.
  /// Map chime key to bundled .caf filename for notification sounds.
  static String? _chimeCaf(String chimeKey) {
    switch (chimeKey) {
      case 'bowl': return 'tibetan_bowl.caf';
      case 'tone': return 'simple_tone.caf';
      case 'bell': return 'soft_bell.caf';
      default:     return null;
    }
  }

  static Future<void> scheduleBatch({
    required DateTime firstTime,
    required Duration interval,
    required List<String> texts,
    String chimeKey = 'bell',
  }) async {
    if (!Platform.isIOS) return;

    // Cancel and reschedule in parallel for speed.
    await cancelBatch();

    // Empty title → Siri reads only the prompt body, no "AT Prompt" prefix.
    // Custom .caf sound plays the user's selected chime natively.
    final sound = _chimeCaf(chimeKey);
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
      sound: sound,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );
    final details = NotificationDetails(iOS: iosDetails);
    final now = tz.TZDateTime.now(tz.local);

    DateTime next = firstTime;
    final futures = <Future<void>>[];
    const fallback = 'Time for your Alexander Technique practice.';

    for (int i = 0; i < batchSize; i++) {
      final scheduled = tz.TZDateTime.from(next, tz.local);
      final body = texts.isEmpty
          ? fallback
          : texts[min(i, texts.length - 1)];

      if (scheduled.isAfter(now)) {
        futures.add(
          _plugin.zonedSchedule(
            _batchBase + i,
            '',          // empty title — Siri reads prompt text only
            body,
            scheduled,
            details,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          ).catchError((_) {}),
        );
      }
      next = next.add(interval);
    }

    await Future.wait(futures);
  }

  /// Cancel one batch slot when the Dart timer fires live for that prompt.
  static Future<void> cancelBatchSlot(int index) async {
    await _plugin.cancel(_batchBase + (index % batchSize));
  }

  /// Cancel all batch slots — used on Stop and Pause.
  static Future<void> cancelBatch() async {
    await Future.wait([
      for (int i = 0; i < batchSize; i++) _plugin.cancel(_batchBase + i),
    ]);
  }
}
