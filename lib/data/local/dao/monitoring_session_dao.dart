import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'monitoring_session_dao.g.dart';

@DriftAccessor(tables: [MonitoringSessions])
class MonitoringSessionDao extends DatabaseAccessor<AppDatabase>
    with _$MonitoringSessionDaoMixin {
  MonitoringSessionDao(super.db);

  Future<void> startSession(String id, int startedAt) {
    return into(monitoringSessions).insert(
        MonitoringSessionsCompanion.insert(id: id, startedAt: startedAt));
  }

  Future<void> endSession(String id, int endedAt) {
    return (update(monitoringSessions)..where((t) => t.id.equals(id)))
        .write(MonitoringSessionsCompanion(endedAt: Value(endedAt)));
  }

  Future<void> updateStats(String id,
      {double? avgStressProb, int? stressEventCount, int? interventionCount}) {
    return (update(monitoringSessions)..where((t) => t.id.equals(id))).write(
      MonitoringSessionsCompanion(
        avgStressProb:
            avgStressProb == null ? const Value.absent() : Value(avgStressProb),
        stressEventCount: stressEventCount == null
            ? const Value.absent()
            : Value(stressEventCount),
        interventionCount: interventionCount == null
            ? const Value.absent()
            : Value(interventionCount),
      ),
    );
  }

  /// Returns sessions ordered most-recent-first, optionally bounded by
  /// [fromMs]/[toMs] Unix millisecond timestamps. Both bounds are
  /// inclusive. Passing null for either removes that bound, giving
  /// the "all time" view the history screen defaults to.
  Future<List<MonitoringSession>> getHistory({int? fromMs, int? toMs}) {
    final q = select(monitoringSessions);
    if (fromMs != null) {
      q.where((t) => t.startedAt.isBiggerOrEqualValue(fromMs));
    }
    if (toMs != null) q.where((t) => t.startedAt.isSmallerOrEqualValue(toMs));
    q.orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    return q.get();
  }

  Future<List<MonitoringSession>> getUnsyncedBatch(int limit) {
    final q = select(monitoringSessions)
      ..where((t) => t.syncedAt.isNull())
      ..limit(limit);
    return q.get();
  }

  Future<void> markSynced(List<String> ids) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (update(monitoringSessions)..where((t) => t.id.isIn(ids)))
        .write(MonitoringSessionsCompanion(syncedAt: Value(now)));
  }
}
