/// Decoded payload of the Calibration Statistics characteristic
/// (A5B30005). Order of both lists matches the Feature Vector field
/// order from the BLE GATT contract: eda_mean, eda_std, eda_slope,
/// eda_range, hrv_rmssd, hrv_mean_rr, hrv_sdnn, hrv_sd2, temp_mean,
/// temp_slope, acc_mag_mean, acc_mag_std, acc_activity.
class CalibrationStats {
  final List<double> means; // length 13
  final List<double> stds; // length 13

  const CalibrationStats({required this.means, required this.stds});
}
