import 'package:drift/drift.dart';

import '../database/app_database.dart';

part 'preference_weights_dao.g.dart';

@DriftAccessor(tables: [PreferenceWeights])
class PreferenceWeightsDao extends DatabaseAccessor<AppDatabase>
    with _$PreferenceWeightsDaoMixin {
  PreferenceWeightsDao(super.db);

  Future<void> upsertWeight(String intervention, double weight, int updatedAt) {
    return into(preferenceWeights).insertOnConflictUpdate(
      PreferenceWeightsCompanion.insert(
        intervention: intervention,
        weight: Value(weight),
        updatedAt: updatedAt,
      ),
    );
  }

  Future<PreferenceWeight?> getWeight(String intervention) {
    return (select(preferenceWeights)
          ..where((t) => t.intervention.equals(intervention)))
        .getSingleOrNull();
  }

  Future<List<PreferenceWeight>> getUnsyncedBatch(int limit) {
    final query = select(preferenceWeights)
      ..where((t) => t.syncedAt.isNull())
      ..limit(limit);
    return query.get();
  }

  /// [ids] here are intervention names, the table's natural primary key,
  /// not generated UUIDs as in the other four tables. SyncService treats
  /// this uniformly with the rest since the contract only specifies
  /// List<String, not the semantic meaning of each string.
  Future<void> markSynced(List<String> ids) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return (update(preferenceWeights)..where((t) => t.intervention.isIn(ids)))
        .write(PreferenceWeightsCompanion(syncedAt: Value(now)));
  }
}
