sealed class InterventionOverlayState {
  const InterventionOverlayState();
}

class NoOverlay extends InterventionOverlayState {
  const NoOverlay();
}

class OverlayActive extends InterventionOverlayState {
  final String logId;
  final String intervention;
  final String tier; // 'mild' | 'intensive'

  const OverlayActive({
    required this.logId,
    required this.intervention,
    required this.tier,
  });
}
