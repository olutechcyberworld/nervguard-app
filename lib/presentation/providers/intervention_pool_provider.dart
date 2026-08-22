import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database/app_database.dart';
import '../../domain/models/intervention_pool.dart';
import 'ble_providers.dart';
import 'infrastructure_providers.dart';

class InterventionPoolNotifier extends AsyncNotifier<InterventionPool> {
  @override
  Future<InterventionPool> build() async {
    final prefs = await ref.watch(appPreferencesProvider.future);
    final db = ref.watch(appDatabaseProvider);

    final mild = await _withWeights(db, prefs.getMildPool());
    final intensive = await _withWeights(db, prefs.getIntensivePool());

    return InterventionPool(mild: mild, intensive: intensive);
  }

  Future<List<InterventionPoolItem>> _withWeights(
      AppDatabase db, List<String> names) async {
    final items = <InterventionPoolItem>[];
    for (final name in names) {
      final weight = await db.preferenceWeightsDao.getWeight(name);
      items
          .add(InterventionPoolItem(name: name, weight: weight?.weight ?? 1.0));
    }
    return items;
  }

  /// Called at Onboarding Step 5 completion. Persists pool membership to
  /// SharedPreferences and immediately pushes the new name lists to the
  /// background isolate via BleService.updateInterventionPool(), per
  /// Phase 3.5.
  Future<void> setPools({
    required List<String> mild,
    required List<String> intensive,
  }) async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setMildPool(mild);
    await prefs.setIntensivePool(intensive);

    await ref.read(bleServiceProvider).updateInterventionPool(
          mild: mild,
          intensive: intensive,
        );

    ref.invalidateSelf();
    await future;
  }

  /// Called by ForegroundInterventionEngine after computing a new EMA
  /// weight from a helped/skip response. Updates the in-memory weight
  /// for [intervention] and re-pushes pool names to the background
  /// isolate per Phase 3.5 step 5.
  ///
  /// NOTE: BleService.updateInterventionPool only carries item names
  /// (mild/intensive lists), not weight values. This re-push keeps the
  /// background isolate's name list in sync but does NOT transmit the
  /// new weight itself — the cross-domain gap flagged when
  /// ForegroundInterventionEngine was built remains open for Sprint 5.
  Future<void> refreshWeight(String intervention, double newWeight) async {
    final current = state.value;
    if (current == null) return;

    InterventionPoolItem update(InterventionPoolItem item) =>
        item.name == intervention
            ? InterventionPoolItem(name: item.name, weight: newWeight)
            : item;

    final updated = InterventionPool(
      mild: current.mild.map(update).toList(),
      intensive: current.intensive.map(update).toList(),
    );
    state = AsyncData(updated);

    await ref.read(bleServiceProvider).updateInterventionPool(
          mild: updated.mild.map((i) => i.name).toList(),
          intensive: updated.intensive.map((i) => i.name).toList(),
        );
  }
}

final interventionPoolProvider =
    AsyncNotifierProvider<InterventionPoolNotifier, InterventionPool>(
  InterventionPoolNotifier.new,
);
