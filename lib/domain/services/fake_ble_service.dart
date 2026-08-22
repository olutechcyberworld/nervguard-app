import 'dart:async';

import '../../core/constants/ble_constants.dart';
import '../models/ble_message.dart';
import '../models/calibration_stats.dart';
import '../models/feature_vector.dart';
import '../models/inference_output.dart';
import 'ble_service.dart';

class FakeBleService implements BleService {
  final _eventController = StreamController<BleMessage>.broadcast();

  Timer? _calibrationTimer;
  Timer? _inferenceTimer;
  int _windowSequence = 0;

  @override
  Stream<BleMessage> get events => _eventController.stream;

  @override
  Stream<bool> get connectionState => events
      .where((m) => m is BleConnectionStateChanged)
      .map((m) => (m as BleConnectionStateChanged).connected);

  void _emit(BleMessage message) {
    if (!_eventController.isClosed) _eventController.add(message);
  }

  void simulateConnect() {
    _emit(const BleConnectionStateChanged(connected: true));
    _emit(const DeviceStateChanged(stateCode: BleConstants.stateIdle));
  }

  void simulateCalibrationSequence() {
    _calibrationTimer?.cancel();
    var progress = 0;
    _emit(const DeviceStateChanged(
        stateCode: BleConstants.stateCalibrating, auxByte: 0));
    _calibrationTimer =
        Timer.periodic(const Duration(milliseconds: 60), (timer) {
      progress += 10;
      if (progress >= 100) {
        timer.cancel();
        _emit(const DeviceStateChanged(
            stateCode: BleConstants.stateCalibrating, auxByte: 100));
        _emit(const DeviceStateChanged(stateCode: BleConstants.stateIdle));
      } else {
        _emit(DeviceStateChanged(
            stateCode: BleConstants.stateCalibrating, auxByte: progress));
      }
    });
  }

  void simulateMonitoring({required bool stressed}) {
    _inferenceTimer?.cancel();
    _emit(const DeviceStateChanged(stateCode: BleConstants.stateMonitoring));
    _inferenceTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _windowSequence = (_windowSequence + 1) % 256;
      _emit(InferenceReceived(InferenceOutput(
        inferenceClass: stressed ? 2 : 0,
        probability: stressed ? 0.85 : 0.05,
        windowSequence: _windowSequence,
      )));
      _emit(FeatureVectorReceived(FeatureVector(
        windowSequence: _windowSequence,
        edaMean: stressed ? 8.5 : 2.1,
        edaStd: stressed ? 1.2 : 0.3,
        edaSlope: stressed ? 0.04 : 0.0,
        edaRange: stressed ? 3.0 : 0.8,
        hrvRmssd: stressed ? 18.0 : 45.0,
        hrvMeanRr: stressed ? 650.0 : 850.0,
        hrvSdnn: stressed ? 22.0 : 55.0,
        hrvSd2: stressed ? 30.0 : 70.0,
        hrvAvailable: true,
        tempMean: stressed ? 31.5 : 33.0,
        tempSlope: stressed ? -0.02 : 0.0,
        accMagMean: 0.99,
        accMagStd: 0.01,
        accActivity: false,
      )));
    });
  }

  void simulateNotWorn() {
    _inferenceTimer?.cancel();
    _emit(const DeviceStateChanged(stateCode: BleConstants.stateNotWorn));
  }

  void simulateError(int code) {
    _inferenceTimer?.cancel();
    _emit(
        DeviceStateChanged(stateCode: BleConstants.stateError, auxByte: code));
  }

  void simulateInterventionTriggered({
    required String logId,
    required String intervention,
    required String tier,
  }) {
    _emit(InterventionTriggered(
        logId: logId, intervention: intervention, tier: tier));
  }

  @override
  Future<void> connect() async => simulateConnect();

  @override
  Future<void> sendCommand(int commandCode) async {
    switch (commandCode) {
      case BleConstants.cmdRequestReset:
        _emit(const DeviceStateChanged(
            stateCode: BleConstants.statePendingReset));
      case BleConstants.cmdConfirmReset:
        _calibrationTimer?.cancel();
        _inferenceTimer?.cancel();
        _emit(const DeviceStateChanged(
            stateCode: BleConstants.stateUncalibrated));
      case BleConstants.cmdStartCalibration:
        simulateCalibrationSequence();
      case BleConstants.cmdStartIntervention:
        simulateMonitoring(stressed: false);
      case BleConstants.cmdStopIntervention:
        _inferenceTimer?.cancel();
        _emit(const DeviceStateChanged(stateCode: BleConstants.stateIdle));
      default:
        throw ArgumentError(
            'Unrecognised command code: 0x${commandCode.toRadixString(16)}');
    }
  }

  @override
  Future<void> subscribeFeatureVector() async {}

  @override
  Future<void> unsubscribeFeatureVector() async {}

  @override
  Future<CalibrationStats> readCalibrationStats() async {
    return const CalibrationStats(
      means: [
        2.1,
        0.3,
        0.0,
        0.8,
        45.0,
        850.0,
        55.0,
        70.0,
        33.0,
        0.0,
        0.99,
        0.01,
        0.0
      ],
      stds: [
        0.5,
        0.1,
        0.01,
        0.2,
        8.0,
        60.0,
        10.0,
        12.0,
        0.5,
        0.005,
        0.02,
        0.01,
        0.0
      ],
    );
  }

  @override
  Future<void> updateInterventionPool(
      {required List<String> mild, required List<String> intensive}) async {}

  @override
  Future<void> dispose() async {
    _calibrationTimer?.cancel();
    _inferenceTimer?.cancel();
    await _eventController.close();
  }
}
