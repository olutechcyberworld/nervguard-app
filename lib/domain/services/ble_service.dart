import '../models/ble_message.dart';
import '../models/calibration_stats.dart';

abstract class BleService {
  Stream<BleMessage> get events;
  Stream<bool> get connectionState;

  /// Initiates the BLE connection sequence. In the real implementation
  /// (Sprint 5) this starts the nine-phase process in the background
  /// isolate. In FakeBleService it triggers simulateConnect().
  Future<void> connect();

  Future<void> sendCommand(int commandCode);
  Future<void> subscribeFeatureVector();
  Future<void> unsubscribeFeatureVector();
  Future<CalibrationStats> readCalibrationStats();

  Future<void> updateInterventionPool({
    required List<String> mild,
    required List<String> intensive,
  });

  Future<void> dispose();
}
