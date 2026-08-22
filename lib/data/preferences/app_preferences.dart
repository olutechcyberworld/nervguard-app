import 'package:shared_preferences/shared_preferences.dart';

/// The six-step onboarding sequence locked in Phase 3.5, plus a terminal
/// `complete` value used by GoRouter redirect guards to gate navigation
/// to /home until onboarding has fully finished. Steps are persisted by
/// ordinal position; reordering this enum without a migration plan would
/// corrupt onboarding progress already stored on existing installs.
enum OnboardingStep {
  welcome,
  account,
  permissions,
  deviceScan,
  interventionPool,
  calibration,
  complete,
}

class _PrefKeys {
  const _PrefKeys._();

  static const onboardingStep = 'onboarding_step';
  static const localOnlyMode = 'local_only_mode';
  static const mildPool = 'intervention_pool_mild';
  static const intensivePool = 'intervention_pool_intensive';
}

/// Thin persistence wrapper around SharedPreferences for the two pieces
/// of application configuration Phase 3 locked as SharedPreferences
/// scope rather than Drift scope: onboarding progress and intervention
/// pool item selection. This class performs no validation of pool size
/// (2-4 mild items, >=1 intensive item) or onboarding sequencing; that
/// business logic belongs to interventionPoolProvider and the onboarding
/// screens in Sprint 3/4, keeping this data-layer class a pure read/write
/// shim consistent with the locked layer decomposition.
class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPreferences(prefs);
  }

  OnboardingStep getOnboardingStep() {
    final index = _prefs.getInt(_PrefKeys.onboardingStep);
    if (index == null || index < 0 || index >= OnboardingStep.values.length) {
      return OnboardingStep.welcome;
    }
    return OnboardingStep.values[index];
  }

  Future<void> setOnboardingStep(OnboardingStep step) {
    return _prefs.setInt(_PrefKeys.onboardingStep, step.index);
  }

  /// Set on Onboarding Step 2 ("Skip for now") and read by SyncService to
  /// short-circuit all sync calls when no Supabase account exists, per the
  /// local-only mode recovery behaviour locked in Phase 3.6. Creating an
  /// account later from Settings does not require clearing this flag
  /// directly here; SyncService's own _userId() check against Supabase
  /// auth state is what actually governs sync resumption.
  bool getLocalOnlyMode() {
    return _prefs.getBool(_PrefKeys.localOnlyMode) ?? false;
  }

  Future<void> setLocalOnlyMode(bool value) {
    return _prefs.setBool(_PrefKeys.localOnlyMode, value);
  }

  List<String> getMildPool() {
    return _prefs.getStringList(_PrefKeys.mildPool) ?? const [];
  }

  Future<void> setMildPool(List<String> items) {
    return _prefs.setStringList(_PrefKeys.mildPool, items);
  }

  List<String> getIntensivePool() {
    return _prefs.getStringList(_PrefKeys.intensivePool) ?? const [];
  }

  Future<void> setIntensivePool(List<String> items) {
    return _prefs.setStringList(_PrefKeys.intensivePool, items);
  }

  /// Exposed for full local-configuration reset flows (for example, a
  /// "Reset app" action in Settings). Not invoked automatically by any
  /// protocol locked in Phase 2.0 or Phase 3; the device-side
  /// requestReset/confirmReset sequence governs NVS calibration data
  /// only and is unrelated to this preferences store.
  Future<void> clearAll() async {
    await _prefs.remove(_PrefKeys.onboardingStep);
    await _prefs.remove(_PrefKeys.localOnlyMode);
    await _prefs.remove(_PrefKeys.mildPool);
    await _prefs.remove(_PrefKeys.intensivePool);
  }
}
