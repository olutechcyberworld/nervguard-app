import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'stress_event_dao.g.dart';

@DriftAccessor(tables: [StressEvents])
class StressEventDao extends DatabaseAccessor<AppDatabase>
    with _$StressEventDaoMixin {
  StressEventDao(super.db);

  /// Insertion will fail at the SQLite level with foreign_keys = ON if
  /// sessionId does not reference an existing monitoring_sessions row.
  /// This is intentional: it is the structural enforcement of the sync
  /// dependency ordering (monitoring_sessions before stress_events).
  Future<void> insertEvent(StressEventsCompanion entry) =>
      into(stressEvents).insert(entry);

  Future<List<StressEvent>> getUnsyncedBatch(int limit) {
    final query = select(stressEvents)
      ..where((t) => t.syncedAt.isNull())
      ..limit(limit);
    return query.get();
  }

  Future<void> markSynced(List<String> ids) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (update(stressEvents)..where((t) => t.id.isIn(ids)))
        .write(StressEventsCompanion(syncedAt: Value(now)));
  }
}
