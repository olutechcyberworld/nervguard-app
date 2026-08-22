import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'calibration_stats_dao.g.dart';

@DriftAccessor(tables: [CalibrationStats])
class CalibrationStatsDao extends DatabaseAccessor<AppDatabase>
    with _$CalibrationStatsDaoMixin {
  CalibrationStatsDao(super.db);

  /// The only write method exposed for this table. Always writes id = 1,
  /// which makes the single-row invariant flagged at schema definition
  /// time structurally difficult to violate from calling code, rather
  /// than merely documented in a comment.
  Future<void> upsert({
    required int calibratedAt,
    required List<double> means,
    required List<double> stds,
  }) {
    return into(calibrationStats).insertOnConflictUpdate(
      CalibrationStatsCompanion.insert(
        id: const Value(1),
        calibratedAt: calibratedAt,
        means: means,
        stds: stds,
      ),
    );
  }

  Future<CalibrationStat?> getStats() {
    return (select(calibrationStats)..where((t) => t.id.equals(1)))
        .getSingleOrNull();
  }

  Future<List<CalibrationStat>> getUnsyncedBatch(int limit) {
    final query = select(calibrationStats)
      ..where((t) => t.syncedAt.isNull())
      ..limit(limit);
    return query.get();
  }

  Future<void> markSynced(List<String> ids) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (update(calibrationStats)..where((t) => t.id.equals(1)))
        .write(CalibrationStatsCompanion(syncedAt: Value(now)));
  }
}
