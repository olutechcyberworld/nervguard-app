import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _channelId = 'nervguard_interventions';
  static const _channelName = 'Stress Interventions';
  static const _channelDesc =
      'NervGuard stress intervention delivery notifications.';

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings),
    );
  }

  Future<void> showIntervention({
    required String title,
    required String body,
    required String tier,
  }) async {
    await _plugin.show(
      id: tier == 'intensive' ? 2 : 1,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
    );
  }
}
