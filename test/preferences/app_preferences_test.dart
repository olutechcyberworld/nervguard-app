import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nervguard/data/preferences/app_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await AppPreferences.create();
  });

  group('onboarding step', () {
    test('defaults to welcome on fresh install', () {
      expect(prefs.getOnboardingStep(), OnboardingStep.welcome);
    });

    test('round-trips a set value', () async {
      await prefs.setOnboardingStep(OnboardingStep.calibration);
      expect(prefs.getOnboardingStep(), OnboardingStep.calibration);
    });

    test('round-trips the terminal complete value', () async {
      await prefs.setOnboardingStep(OnboardingStep.complete);
      expect(prefs.getOnboardingStep(), OnboardingStep.complete);
    });
  });

  group('local-only mode', () {
    test('defaults to false', () {
      expect(prefs.getLocalOnlyMode(), isFalse);
    });

    test('round-trips true', () async {
      await prefs.setLocalOnlyMode(true);
      expect(prefs.getLocalOnlyMode(), isTrue);
    });
  });

  group('intervention pools', () {
    test('default to empty lists', () {
      expect(prefs.getMildPool(), isEmpty);
      expect(prefs.getIntensivePool(), isEmpty);
    });

    test('round-trips mild pool selection', () async {
      await prefs.setMildPool(['Lo-fi music', 'Box breathing']);
      expect(prefs.getMildPool(), ['Lo-fi music', 'Box breathing']);
    });

    test('round-trips intensive pool selection', () async {
      await prefs.setIntensivePool(['4-7-8 Breathing']);
      expect(prefs.getIntensivePool(), ['4-7-8 Breathing']);
    });
  });

  group('clearAll', () {
    test('resets onboarding step, local-only mode, and both pools', () async {
      await prefs.setOnboardingStep(OnboardingStep.complete);
      await prefs.setLocalOnlyMode(true);
      await prefs.setMildPool(['Nature sounds']);
      await prefs.setIntensivePool(['5-4-3-2-1 Grounding']);

      await prefs.clearAll();

      expect(prefs.getOnboardingStep(), OnboardingStep.welcome);
      expect(prefs.getLocalOnlyMode(), isFalse);
      expect(prefs.getMildPool(), isEmpty);
      expect(prefs.getIntensivePool(), isEmpty);
    });
  });
}
