/// Decoded payload of the Feature Vector characteristic (A5B30004).
/// HRV fields are nullable: when fewer than 30 clean RR intervals were
/// available firmware-side, all four HRV fields arrive as the -1.0f
/// sentinel and are mapped to null here, with hrvAvailable set to
/// false, per the locked BLE GATT contract.
class FeatureVector {
  final int windowSequence;

  final double edaMean;
  final double edaStd;
  final double edaSlope;
  final double edaRange;

  final double? hrvRmssd;
  final double? hrvMeanRr;
  final double? hrvSdnn;
  final double? hrvSd2;
  final bool hrvAvailable;

  final double tempMean;
  final double tempSlope;

  final double accMagMean;
  final double accMagStd;
  final bool accActivity;

  const FeatureVector({
    required this.windowSequence,
    required this.edaMean,
    required this.edaStd,
    required this.edaSlope,
    required this.edaRange,
    required this.hrvRmssd,
    required this.hrvMeanRr,
    required this.hrvSdnn,
    required this.hrvSd2,
    required this.hrvAvailable,
    required this.tempMean,
    required this.tempSlope,
    required this.accMagMean,
    required this.accMagStd,
    required this.accActivity,
  });
}
