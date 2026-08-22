abstract final class AppConstants {
  // ── Inference thresholds (ML pipeline handoff, locked) ────────
  static const double thresholdWatch = 0.40;
  static const double thresholdStress = 0.70;

  // ── int8 quantisation parameters (ML pipeline handoff, locked) ─
  static const double quantScaleIn = 0.037689;
  static const int quantZpIn = -19;
  static const double quantScaleOut = 0.003906;
  static const int quantZpOut = -128;

  // ── Window parameters ─────────────────────────────────────────
  static const int windowSizeSeconds = 60;
  static const int windowStepSeconds = 5;

  // ── Warm-up (BN-4: first notification may lag up to 60 s) ────
  static const int warmupDurationSeconds = 65; // 60 s window + 5 s margin

  // ── Calibration ───────────────────────────────────────────────
  static const int calibrationMinValidWindows = 24;
  static const int calibrationDurationSeconds = 180; // 3 minutes
  static const int calibrationTotalWindows = 36; // 180 s / 5 s step

  // ── Wear detection (temperature-primary, 2 °C hysteresis) ────
  static const double wearTempThresholdOn = 30.0; // °C → MONITORING
  static const double wearTempThresholdOff = 28.0; // °C → NOT_WORN

  // ── HRV sentinel (sent when < 30 clean RR intervals) ─────────
  static const double hrvUnavailableSentinel = -1.0;

  // ── PENDING_RESET timeout ─────────────────────────────────────
  static const int pendingResetTimeoutSeconds = 15;

  // ── Intervention engine ───────────────────────────────────────
  static const int stressConsecutiveThreshold = 3;
  static const int escalationWindowMinutes = 5;
  static const int cooldownDurationMinutes = 5;
  static const double emaAlpha = 0.2;
  static const double emaWeightHelped = 1.5;
  static const double emaWeightSkipped = 0.5;
  static const double emaWeightNeutral = 1.0;

  // ── Window sequence correlation ───────────────────────────────
  static const int sequenceJitterTolerance = 5; // windows (~25 s)

  // ── Sync ──────────────────────────────────────────────────────
  static const int syncBatchSize = 50;
  static const int syncPeriodicIntervalMinutes = 15;

  // ── BLE reconnection ──────────────────────────────────────────
  static const int reconnectInitialDelaySeconds = 1;
  static const int reconnectMaxDelaySeconds = 30;
  static const int reconnectMaxAttempts = 10;
  static const int scanTimeoutSeconds = 30;
  static const int connectTimeoutSeconds = 10;
  static const int bondTimeoutSeconds = 60;

  // ── Battery ───────────────────────────────────────────────────
  static const int batteryChangeThresholdPercent = 5;

  // ── NOT_WORN cold-environment UX guidance delay ───────────────
  static const int coldEnvGuidanceDelayMinutes = 2;
}
