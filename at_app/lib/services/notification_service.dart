import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();
  static int _notifId = 0;

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true, // needed to play system notification sound
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> showPrompt(String promptText) async {
    _notifId = (_notifId + 1) % 1000;
    const androidDetails = AndroidNotificationDetails(
      'at_prompts',
      'AT Prompts',
      channelDescription: 'Alexander Technique awareness prompts',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,  // plays user's default notification sound
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,  // plays user's default notification sound (e.g. Tri-tone)
      interruptionLevel: InterruptionLevel.active,
    );
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.show(_notifId, 'AT Prompt', promptText, details);
  }
}
