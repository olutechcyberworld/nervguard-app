import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'domain/services/real_ble_service.dart';
import 'presentation/providers/ble_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );

  FlutterForegroundTask.initCommunicationPort();

  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'nervguard_monitoring',
      channelName: 'NervGuard Monitoring Service',
      channelDescription:
          'Keeps NervGuard stress monitoring active in the background.',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        bleServiceProvider.overrideWith((ref) {
          final service = RealBleService();
          ref.onDispose(service.dispose);
          return service;
        }),
      ],
      child: const NervGuardApp(),
    ),
  );
}
