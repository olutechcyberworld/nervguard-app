import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'intervention_log_dao.g.dart';

@DriftAccessor(tables: [InterventionLogs])
class InterventionLogDao extends DatabaseAccessor<AppDatabase>
    with _$InterventionLogDaoMixin {
  InterventionLogDao(super.db);

  Future<void> insertLog(InterventionLogsCompanion entry) =>
      into(interventionLogs).insert(entry);

  Future<InterventionLog?> getUnacknowledgedWithin(Duration window) {
    final cutoff = DateTime.now().subtract(window).millisecondsSinceEpoch;
    final q = select(interventionLogs)
      ..where((t) =>
          t.status.equals('triggered') &
          t.triggeredAt.isBiggerThanValue(cutoff))
      ..orderBy([(t) => OrderingTerm.desc(t.triggeredAt)])
      ..limit(1);
    return q.getSingleOrNull();
  }

  Future<void> updateStatus(String id, String status, {int? acknowledgedAt}) {
    return (update(interventionLogs)..where((t) => t.id.equals(id))).write(
      InterventionLogsCompanion(
        status: Value(status),
        acknowledgedAt: acknowledgedAt == null
            ? const Value.absent()
            : Value(acknowledgedAt),
      ),
    );
  }

  /// Returns logs ordered most-recent-first within optional time bounds.
  Future<List<InterventionLog>> getHistory({int? fromMs, int? toMs}) {
    final q = select(interventionLogs);
    if (fromMs != null) {
      q.where((t) => t.triggeredAt.isBiggerOrEqualValue(fromMs));
    }
    if (toMs != null) q.where((t) => t.triggeredAt.isSmallerOrEqualValue(toMs));
    q.orderBy([(t) => OrderingTerm.desc(t.triggeredAt)]);
    return q.get();
  }

  Future<List<InterventionLog>> getUnsyncedBatch(int limit) {
    final q = select(interventionLogs)
      ..where((t) => t.syncedAt.isNull())
      ..limit(limit);
    return q.get();
  }

  Future<void> markSynced(List<String> ids) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (update(interventionLogs)..where((t) => t.id.isIn(ids)))
        .write(InterventionLogsCompanion(syncedAt: Value(now)));
  }
}
