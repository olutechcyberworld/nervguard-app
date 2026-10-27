import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/ble_constants.dart';
import '../data/local/database/app_database.dart';
import '../domain/models/ble_message.dart';
import '../domain/models/main_message.dart';
import '../background/background_intervention_core.dart';
import '../background/ble_payload_parsers.dart';
import '../domain/services/notification_service.dart';

const _uuid = Uuid();

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(NervGuardTaskHandler());
}

class NervGuardTaskHandler extends TaskHandler {
  late final NotificationService _notificationService;
  late final AppDatabase _db;
  late final BackgroundInterventionCore _interventionCore;

  BluetoothDevice? _device;
  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<List<int>>? _stateNotifySub;
  StreamSubscription<List<int>>? _inferenceNotifySub;
  StreamSubscription<List<int>>? _featureVectorNotifySub;
  StreamSubscription<List<int>>? _batteryNotifySub;
  BluetoothCharacteristic? _controlChar;
  BluetoothCharacteristic? _stateChar;
  BluetoothCharacteristic? _inferenceChar;
  BluetoothCharacteristic? _featureVectorChar;
  BluetoothCharacteristic? _calibStatsChar;
  BluetoothCharacteristic? _batteryChar;

  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 10;
  Timer? _reconnectTimer;

  String? _activeSessionId;
  bool _featureVectorSubscribed = false;
  // BUG FIX: separate from _featureVectorSubscribed above, and this is
  // the actual fix, not just a rename. _featureVectorSubscribed tracks
  // whether THIS specific GATT characteristic instance currently has
  // notifications enabled, and gets reset to false at the top of
  // _connect() below since a fresh connection means a fresh instance
  // regardless of what happened before. _featureVectorWanted tracks the
  // Dashboard's standing INTENT — does it want feature vector data at
  // all — and deliberately survives across reconnects. Without this,
  // a same-isolate reconnect (the RequestReconnect path added for the
  // "Connect Device button does nothing" fix) left the Dashboard's EDA
  // and Temperature cards stuck at "-" forever after reconnecting,
  // because featureVectorStreamProvider only calls
  // subscribeFeatureVector() once, when it first builds, and has no way
  // to know a BLE reconnect happened underneath it. Confirmed on real
  // hardware: HRV kept working after reconnect (delivered via the
  // Inference characteristic, unconditionally re-subscribed every
  // _connect() in Phase 7 below with no such guard) while EDA/Temp
  // (delivered via this gated characteristic) did not — that split is
  // exactly what pointed at this being a subscription-state bug rather
  // than a data or parsing problem.
  bool _featureVectorWanted = false;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // W-3.7-1: initialize flutter_local_notifications FIRST, before any BLE op.
    final plugin = FlutterLocalNotificationsPlugin();
    _notificationService = NotificationService(plugin);
    await _notificationService.initialize();

    _db = AppDatabase();

    _interventionCore = BackgroundInterventionCore(
      db: _db,
      notificationService: _notificationService,
      onInterventionFired: _send,
    );

    await _connect();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  /// flutter_foreground_task 9.2.2: onDestroy carries a second bool
  /// parameter indicating whether the task was destroyed due to a timeout.
  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _reconnectTimer?.cancel();
    await _cancelAllSubscriptions();
    try {
      await _device?.disconnect();
    } catch (_) {}
    await _db.close();
  }

  @override
  void onReceiveData(Object data) {
    if (data is! Map<String, dynamic>) return;
    try {
      _handleMainMessage(MainMessage.fromMap(data));
    } catch (_) {}
  }

  void _handleMainMessage(MainMessage message) {
    switch (message) {
      case SendBleCommand(:final commandCode):
        _writeCommand(commandCode);
      case SubscribeFeatureVector():
        _setFeatureVectorSubscription(enabled: true);
      case UnsubscribeFeatureVector():
        _setFeatureVectorSubscription(enabled: false);
      case UpdateInterventionPool(:final mild, :final intensive):
        _interventionCore.updatePool(mild: mild, intensive: intensive);
      case RequestCalibrationStats():
        _readAndSendCalibrationStats();
      case RequestReconnect():
        // See the doc comment on RequestReconnect in main_message.dart
        // for the full mechanism this exists to fix. Reset the backoff
        // counter (this isolate may have already exhausted all 10
        // attempts and given up hours ago) and immediately try again,
        // rather than waiting for whatever delay _scheduleReconnect()
        // last calculated, or worse, silently doing nothing because the
        // caller assumed startService() would handle this — it cannot,
        // for an isolate that is already running.
        _reconnectAttempts = 0;
        unawaited(_connect());
    }
  }

  Future<void> _connect() async {
    try {
      // BUG FIX, first half: reset the per-characteristic-instance
      // subscription flag at the start of every connection attempt.
      // _featureVectorChar itself gets a fresh instance from
      // _resolveCharacteristics() below on every call, but this bool
      // previously survived across reconnects on a reused isolate,
      // causing _setFeatureVectorSubscription() to wrongly believe
      // notifications were already active on a characteristic instance
      // that had never actually been subscribed this time around.
      _featureVectorSubscribed = false;

      // Phase 1 — Scan by service UUID.
      // Phase 1 — Scan without service filter (ESP32-S3 NimBLE advertises
// service UUID in scan response, not primary advertisement; Android
// withServices filter only checks primary advertisement packets).
      final scanCompleter = Completer<BluetoothDevice>();

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
      );

      final scanSub = FlutterBluePlus.scanResults.listen((results) {
        for (final result in results) {
          // Match by service UUID in either advertisement or scan response.
          final advertisedServices = result.advertisementData.serviceUuids
              .map((g) => g.str.toLowerCase())
              .toList();
          final nameMatch =
              result.device.platformName.toLowerCase().contains('nervguard');
          final uuidMatch = advertisedServices
              .any((u) => u.contains('a5b30000') || u.contains('b30000'));

          if ((nameMatch || uuidMatch) && !scanCompleter.isCompleted) {
            scanCompleter.complete(result.device);
          }
        }
      });

      _device = await scanCompleter.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('BLE scan timed out'),
      );
      await scanSub.cancel();
      await FlutterBluePlus.stopScan();

      // Phase 2 — GATT connect.
      await _device!.connect(
        license: License.nonprofit,
        autoConnect: false,
        timeout: const Duration(seconds: 10),
      );

      _connectionSub = _device!.connectionState.listen(_onConnectionState);

      // Phase 3 — Service discovery.
      final services = await _device!.discoverServices();

      // Phase 4 — MTU negotiation.
      final mtu = await _device!.requestMtu(BleConstants.requestedMtu);
      if (mtu < BleConstants.minRequiredMtu) {
        throw Exception(
            'Negotiated MTU $mtu below required ${BleConstants.minRequiredMtu}');
      }

      // Phase 5 — Bonding.
      await _ensureBonded();

      _resolveCharacteristics(services);

      // Phase 6 — Read initial device state.
      final stateBytes = await _stateChar!.read();
      final statePacket = parseDeviceState(stateBytes);
      _send(DeviceStateChanged(
          stateCode: statePacket.stateCode, auxByte: statePacket.auxByte));

      // Phase 7 — CCCD subscriptions.
      await _stateChar!.setNotifyValue(true);
      _stateNotifySub =
          _stateChar!.onValueReceived.listen(_onStateNotification);

      if (_batteryChar != null) {
        await _batteryChar!.setNotifyValue(true);
        _batteryNotifySub =
            _batteryChar!.onValueReceived.listen(_onBatteryNotification);
      }

      await _inferenceChar!.setNotifyValue(true);
      _inferenceNotifySub =
          _inferenceChar!.onValueReceived.listen(_onInferenceNotification);

      // Phase 8 — Read calibration stats if IDLE or MONITORING.
      final idleOrMonitoring =
          statePacket.stateCode == BleConstants.stateIdle ||
              statePacket.stateCode == BleConstants.stateMonitoring;
      if (idleOrMonitoring && _calibStatsChar != null) {
        await _readAndSendCalibrationStats();
      }

      // Phase 9 — Emit ready.
      _reconnectAttempts = 0;
      _send(const BleConnectionStateChanged(connected: true));

      // BUG FIX, second half: if the Dashboard previously wanted
      // feature vector notifications, re-apply that intent now rather
      // than waiting for the main isolate to ask again — it likely
      // never will, since featureVectorStreamProvider only sends that
      // request once, on its own initial build. This is what actually
      // makes EDA and Temperature resume updating after a reconnect,
      // same-isolate or otherwise.
      if (_featureVectorWanted) {
        await _setFeatureVectorSubscription(enabled: true);
      }
    } catch (e, st) {
      // CORRECTION: this previously used developer.log(), which is
      // built on the VM service/DevTools protocol. With no VM service
      // attached (i.e. the app launched normally from the home screen
      // rather than via `flutter run`), those calls can silently go
      // nowhere — exactly what happened: a full pairing-and-retry cycle
      // produced zero "NervGuard.BLE" lines in logcat. print() has no
      // such dependency; the Flutter engine unconditionally routes it
      // to native Android logging (tag "flutter") in every build mode.
      // Filter with:
      //   adb logcat | grep -i "NervGuard.BLE"
      // The exception's own message (e.g. "BLE scan timed out",
      // "Bond rejected", or "Negotiated MTU ... below required ...")
      // identifies which of the nine phases actually failed.
      // ignore: avoid_print
      print('[NervGuard.BLE] connect() failed: $e\n$st');
      await _scheduleReconnect();
    }
  }

  void _resolveCharacteristics(List<BluetoothService> services) {
    for (final service in services) {
      for (final char in service.characteristics) {
        final uuid = char.characteristicUuid.str.toLowerCase();
        if (uuid.contains('b30001')) _stateChar = char;
        if (uuid.contains('b30002')) _controlChar = char;
        if (uuid.contains('b30003')) _inferenceChar = char;
        if (uuid.contains('b30004')) _featureVectorChar = char;
        if (uuid.contains('b30005')) _calibStatsChar = char;
        if (uuid.contains('2a19')) _batteryChar = char;
      }
    }
  }

  Future<void> _ensureBonded() async {
    final bondState = await _device!.bondState.first;
    if (bondState == BluetoothBondState.bonded) return;

    final bondCompleter = Completer<void>();
    final sub = _device!.bondState.listen((state) {
      if (state == BluetoothBondState.bonded && !bondCompleter.isCompleted) {
        bondCompleter.complete();
      } else if (state == BluetoothBondState.none &&
          !bondCompleter.isCompleted) {
        bondCompleter.completeError(Exception('Bond rejected'));
      }
    });

    // flutter_blue_plus 2.3.8 requires the license named parameter.
    await _device!.createBond();
    await bondCompleter.future.timeout(const Duration(seconds: 60));
    await sub.cancel();
  }

  void _onStateNotification(List<int> bytes) {
    try {
      final packet = parseDeviceState(bytes);
      _send(DeviceStateChanged(
          stateCode: packet.stateCode, auxByte: packet.auxByte));
      _handleSessionLifecycle(packet.stateCode);
    } catch (_) {}
  }

  void _onInferenceNotification(List<int> bytes) {
    try {
      final inference = parseInference(bytes);
      _send(InferenceReceived(inference));
      _interventionCore.onInference(
          inference.inferenceClass, inference.probability);
    } catch (_) {}
  }

  void _onFeatureVectorNotification(List<int> bytes) {
    try {
      _send(FeatureVectorReceived(parseFeatureVector(bytes)));
    } catch (_) {}
  }

  void _onBatteryNotification(List<int> bytes) {
    try {
      _send(BatteryLevelChanged(parseBatteryLevel(bytes)));
    } catch (_) {}
  }

  void _handleSessionLifecycle(int stateCode) {
    if (stateCode == BleConstants.stateMonitoring && _activeSessionId == null) {
      final id = _uuid.v4();
      _activeSessionId = id;
      _db.monitoringSessionDao
          .startSession(id, DateTime.now().millisecondsSinceEpoch);
    }

    final terminal = stateCode == BleConstants.stateIdle ||
        stateCode == BleConstants.stateUncalibrated ||
        stateCode == BleConstants.stateError;

    if (terminal && _activeSessionId != null) {
      _db.monitoringSessionDao
          .endSession(_activeSessionId!, DateTime.now().millisecondsSinceEpoch);
      _activeSessionId = null;
      _interventionCore.resetState();
    }
  }

  void _onConnectionState(BluetoothConnectionState state) {
    if (state == BluetoothConnectionState.disconnected) {
      _send(const BleConnectionStateChanged(connected: false));
      if (_activeSessionId != null) {
        _db.monitoringSessionDao.endSession(
            _activeSessionId!, DateTime.now().millisecondsSinceEpoch);
        _activeSessionId = null;
        _interventionCore.resetState();
      }
      _scheduleReconnect();
    }
  }

  Future<void> _scheduleReconnect() async {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _send(const BleConnectionStateChanged(connected: false, gaveUp: true));
      return;
    }
    final delaySeconds = (1 << _reconnectAttempts).clamp(1, 30);
    _reconnectAttempts++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), _connect);
  }

  Future<void> _writeCommand(int commandCode) async {
    if (_controlChar == null) return;
    try {
      await _controlChar!.write([commandCode], withoutResponse: false);
    } catch (_) {}
  }

  Future<void> _setFeatureVectorSubscription({required bool enabled}) async {
    // Record intent unconditionally, before any of the early returns
    // below — this is what Phase 9 above checks after a reconnect, and
    // it must reflect what the Dashboard actually asked for regardless
    // of whether this particular call ends up doing any GATT work.
    _featureVectorWanted = enabled;
    if (_featureVectorChar == null) return;
    if (enabled == _featureVectorSubscribed) return;
    try {
      await _featureVectorChar!.setNotifyValue(enabled);
      if (enabled) {
        _featureVectorNotifySub = _featureVectorChar!.onValueReceived
            .listen(_onFeatureVectorNotification);
      } else {
        await _featureVectorNotifySub?.cancel();
        _featureVectorNotifySub = null;
      }
      _featureVectorSubscribed = enabled;
    } catch (_) {}
  }

  Future<void> _readAndSendCalibrationStats() async {
    if (_calibStatsChar == null) return;
    try {
      final bytes = await _calibStatsChar!.read();
      _send(CalibrationStatsResult(parseCalibrationStats(bytes)));
    } catch (_) {}
  }

  void _send(BleMessage message) {
    FlutterForegroundTask.sendDataToMain(message.toMap());
  }

  Future<void> _cancelAllSubscriptions() async {
    await _stateNotifySub?.cancel();
    await _inferenceNotifySub?.cancel();
    await _featureVectorNotifySub?.cancel();
    await _batteryNotifySub?.cancel();
    await _connectionSub?.cancel();
    _stateNotifySub = null;
    _inferenceNotifySub = null;
    _featureVectorNotifySub = null;
    _batteryNotifySub = null;
    _connectionSub = null;
  }
}
