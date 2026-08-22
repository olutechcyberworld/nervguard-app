abstract final class BleConstants {
  // ── Service ───────────────────────────────────────────────────
  static const String serviceUuid = 'a5b30000-1a2b-3c4d-5e6f-7a8b9c0d1e2f';

  // ── Characteristics (full 128-bit UUIDs, same base as service) ─
  static const String deviceStateUuid = 'a5b30001-1a2b-3c4d-5e6f-7a8b9c0d1e2f';
  static const String controlCommandUuid =
      'a5b30002-1a2b-3c4d-5e6f-7a8b9c0d1e2f';
  static const String inferenceOutputUuid =
      'a5b30003-1a2b-3c4d-5e6f-7a8b9c0d1e2f';
  static const String featureVectorUuid =
      'a5b30004-1a2b-3c4d-5e6f-7a8b9c0d1e2f';
  static const String calibrationStatsUuid =
      'a5b30005-1a2b-3c4d-5e6f-7a8b9c0d1e2f';

  // Standard Bluetooth SIG Battery Service + Characteristic
  static const String batteryServiceUuid =
      '0000180f-0000-1000-8000-00805f9b34fb';
  static const String batteryLevelUuid = '00002a19-0000-1000-8000-00805f9b34fb';

  // ── Control commands ──────────────────────────────────────────
  static const int cmdStartCalibration = 0x01;
  static const int cmdStartIntervention = 0x02;
  static const int cmdStopIntervention = 0x03;
  static const int cmdRequestReset = 0x04;
  static const int cmdConfirmReset = 0x05;

  // ── Device state codes ────────────────────────────────────────
  static const int stateUncalibrated = 0x00;
  static const int stateIdle = 0x01;
  static const int stateCalibrating = 0x02;
  static const int stateMonitoring = 0x03;
  static const int stateNotWorn = 0x04;
  static const int stateError = 0x05;
  static const int statePendingReset = 0x06;

  // ── Error codes (active only when stateError) ─────────────────
  static const int errI2cBusFailure = 0x01;
  static const int errOneWireFailure = 0x02;
  static const int errEdaAdcFailure = 0x03;
  static const int errTfliteAllocFailure = 0x04;
  static const int errNvsFailure = 0x05;
  static const int errPersistentSignal = 0x06;

  // ── MTU ───────────────────────────────────────────────────────
  static const int minRequiredMtu = 119; // 104-byte payload + 15 ATT overhead
  static const int requestedMtu = 250;
}
