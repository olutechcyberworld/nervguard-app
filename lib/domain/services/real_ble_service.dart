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
    // BUG FIX: this used to unconditionally call startService() and
    // discard its result. startService() throws internally and returns
    // ServiceRequestFailure — never actually throwing out of this
    // await — whenever the service is already running, which silently
    // swallowed the failure and made this method appear to succeed
    // while doing nothing. See RequestReconnect's doc comment in
    // main_message.dart for the full mechanism this was causing on
    // real hardware (button appeared completely dead the morning after
    // an overnight power cycle). startService() is only valid for a
    // genuine first start; an already-running isolate needs to be told
    // to reconnect via a message instead.
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.sendDataToTask(const RequestReconnect().toMap());
      return;
    }
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
