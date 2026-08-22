import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/ble_message.dart';
import '../../domain/models/intervention_overlay_state.dart';
import 'infrastructure_providers.dart';
import 'intervention_pool_provider.dart';

const _recoveryWindow = Duration(minutes: 5);
const _emaAlpha = 0.2;
const _helpedFeedback = 1.5;
const _skippedFeedback = 0.5;

class ForegroundInterventionEngine
    extends AsyncNotifier<InterventionOverlayState> {
  @override
  Future<InterventionOverlayState> build() async {
    final dao = ref.watch(appDatabaseProvider).interventionLogDao;
    final unacknowledged = await dao.getUnacknowledgedWithin(_recoveryWindow);
    if (unacknowledged == null) return const NoOverlay();
    return OverlayActive(
      logId: unacknowledged.id,
      intervention: unacknowledged.intervention,
      tier: unacknowledged.tier,
    );
  }

  void onIntervention(InterventionTriggered event) {
    final current = state.value;
    if (current is OverlayActive && current.logId == event.logId) {
      return;
    }
    state = AsyncData(OverlayActive(
      logId: event.logId,
      intervention: event.intervention,
      tier: event.tier,
    ));
  }

  Future<void> respond({required bool helped}) async {
    final current = state.value;
    if (current is! OverlayActive) return;

    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.interventionLogDao.updateStatus(
      current.logId,
      helped ? 'helped' : 'skipped',
      acknowledgedAt: now,
    );

    await _updateWeight(current.intervention, helped: helped);

    state = const AsyncData(NoOverlay());
  }

  Future<void> _updateWeight(String intervention,
      {required bool helped}) async {
    final dao = ref.read(appDatabaseProvider).preferenceWeightsDao;
    final existing = await dao.getWeight(intervention);
    final currentWeight = existing?.weight ?? 1.0;
    final feedback = helped ? _helpedFeedback : _skippedFeedback;
    final newWeight = (1 - _emaAlpha) * currentWeight + _emaAlpha * feedback;

    await dao.upsertWeight(
      intervention,
      newWeight,
      DateTime.now().millisecondsSinceEpoch,
    );

    // Closes the previously deferred step 4/5 of the helped/skip response
    // path: updates interventionPoolProvider's in-memory weight and
    // re-pushes pool names to the background isolate. Actually
    // transmitting the new weight value across the isolate boundary
    // remains a Sprint 5 open item.
    await ref
        .read(interventionPoolProvider.notifier)
        .refreshWeight(intervention, newWeight);
  }
}

final foregroundInterventionEngineProvider = AsyncNotifierProvider<
    ForegroundInterventionEngine, InterventionOverlayState>(
  ForegroundInterventionEngine.new,
);
