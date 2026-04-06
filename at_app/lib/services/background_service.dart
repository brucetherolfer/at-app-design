import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter/material.dart';
import 'prompt_timer_service.dart';
import '../repositories/isar_service.dart';
import '../services/notification_service.dart';

class BackgroundServiceManager {
  BackgroundServiceManager._();

  static Future<void> initialize() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'at_background',
        initialNotificationTitle: 'Alexander Technique',
        initialNotificationContent: 'Prompts are running…',
        foregroundServiceNotificationId: 1,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    await IsarService.open();
    await NotificationService.init();
    await PromptTimerService().start();

    service.on('stop').listen((_) {
      PromptTimerService().stop();
      service.stopSelf();
    });
  }

  static Future<void> startService() async {
    final service = FlutterBackgroundService();
    await service.startService();
  }

  static void stopService() {
    FlutterBackgroundService().invoke('stop');
  }
}
