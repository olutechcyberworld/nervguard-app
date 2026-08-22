import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '../../background/foreground_task_handler.dart';
import '../models/ble_message.dart';
import '../models/calibration_stats.dart';
import '../models/main_message.dart';
import 'ble_service.dart';

class RealBleService implements BleService {
  RealBleService() {
    FlutterForegroundTask.addTaskDataCallback(_onTaskData);
  }

  final _eventController = StreamController<BleMessage>.broadcast();

  void _onTaskData(Object data) {
    if (data is! Map<String, dynamic>) return;
    try {
      _eventController.add(BleMessage.fromMap(data));
    } catch (_) {}
  }

  @override
  Stream<BleMessage> get events => _eventController.stream;

  @override
  Stream<bool> get connectionState => events
      .where((m) => m is BleConnectionStateChanged)
      .cast<BleConnectionStateChanged>()
      .map((m) => m.connected);

  @override
  Future<void> connect() async {
    await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'NervGuard',
      notificationText: 'Stress monitoring active',
      callback: startCallback,
    );
  }

  @override
  Future<void> sendCommand(int commandCode) async {
    FlutterForegroundTask.sendDataToTask(
      SendBleCommand(commandCode: commandCode).toMap(),
    );
  }

  @override
  Future<void> subscribeFeatureVector() async {
    FlutterForegroundTask.sendDataToTask(
      const SubscribeFeatureVector().toMap(),
    );
  }

  @override
  Future<void> unsubscribeFeatureVector() async {
    FlutterForegroundTask.sendDataToTask(
      const UnsubscribeFeatureVector().toMap(),
    );
  }

  @override
  Future<CalibrationStats> readCalibrationStats() async {
    FlutterForegroundTask.sendDataToTask(
      const RequestCalibrationStats().toMap(),
    );
    return events
        .where((m) => m is CalibrationStatsResult)
        .cast<CalibrationStatsResult>()
        .map((m) => m.stats)
        .first
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () =>
              throw TimeoutException('CalibrationStats read timed out'),
        );
  }

  @override
  Future<void> updateInterventionPool({
    required List<String> mild,
    required List<String> intensive,
  }) async {
    FlutterForegroundTask.sendDataToTask(
      UpdateInterventionPool(mild: mild, intensive: intensive).toMap(),
    );
  }

  @override
  Future<void> dispose() async {
    FlutterForegroundTask.removeTaskDataCallback(_onTaskData);
    await FlutterForegroundTask.stopService();
    await _eventController.close();
  }
}
