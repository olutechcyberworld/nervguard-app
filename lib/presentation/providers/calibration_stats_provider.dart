import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/calibration_stats.dart';
import 'ble_providers.dart';
import 'infrastructure_providers.dart';

class CalibrationStatsNotifier extends AsyncNotifier<CalibrationStats?> {
  @override
  Future<CalibrationStats?> build() async {
    // No proactive initial read here: the real nine-phase BLE connection
    // sequence (Sprint 5, Phase 8) owns the connect-time READ when boot
    // state is IDLE or MONITORING. This notifier starts with no known
    // calibration data and is populated by refresh(), called explicitly
    // by DeviceStateNotifier on CALIBRATING -> IDLE.
    return null;
  }

  /// Issues a fresh BLE READ of A5B30005, persists the result to Drift,
  /// and exposes it to watchers (the dashboard's relative-value
  /// display). Called by DeviceStateNotifier on every
  /// CALIBRATING -> IDLE transition, per Phase 3.5.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final stats = await ref.read(bleServiceProvider).readCalibrationStats();
      final db = ref.read(appDatabaseProvider);
      await db.calibrationStatsDao.upsert(
        calibratedAt: DateTime.now().millisecondsSinceEpoch,
        means: stats.means,
        stds: stats.stds,
      );
      return stats;
    });
  }
}

final calibrationStatsNotifierProvider =
    AsyncNotifierProvider<CalibrationStatsNotifier, CalibrationStats?>(
  CalibrationStatsNotifier.new,
);
