/// A single item in a user-configured intervention pool (Phase 3.5),
/// paired with its current EMA preference weight from preference_weights
/// (Phase 3.5 helped/skip response path). Weight 1.0 is neutral.
class InterventionPoolItem {
  final String name;
  final double weight;

  const InterventionPoolItem({required this.name, required this.weight});
}

/// The user's configured mild and intensive intervention pools, each
/// item annotated with its current preference weight. Pool membership
/// (names) lives in SharedPreferences; weights live in Drift's
/// preference_weights table, per the locked Phase 3.6 storage split.
class InterventionPool {
  final List<InterventionPoolItem> mild;
  final List<InterventionPoolItem> intensive;

  const InterventionPool({required this.mild, required this.intensive});
}
