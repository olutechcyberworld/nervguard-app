import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../../domain/models/device_state.dart';
// import '../../../domain/models/feature_vector.dart';
import '../../providers/device_state_provider.dart';
import '../../providers/inference_providers.dart';
import '../../providers/onboarding_provider.dart';

class CalibrationScreen extends ConsumerStatefulWidget {
  const CalibrationScreen({super.key});

  @override
  ConsumerState<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends ConsumerState<CalibrationScreen> {
  bool _advanced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(deviceStateNotifierProvider, (previous, next) async {
        if (_advanced) return;
        final prev = previous?.value;
        final curr = next.value;
        if (prev is Calibrating && curr is Idle) {
          _advanced = true;
          await ref
              .read(onboardingStatusProvider.notifier)
              .advance(OnboardingStep.complete);
          if (mounted) context.go('/home/dashboard');
        }
        if (curr is Uncalibrated && prev is Calibrating) {
          // Calibration failed
          if (mounted) setState(() {});
        }
      });
    });
  }

  Future<void> _startCalibration() async {
    await ref.read(deviceStateNotifierProvider.notifier).startCalibration();
  }

  @override
  Widget build(BuildContext context) {
    final deviceState = ref.watch(deviceStateNotifierProvider).value;
    final featureVector = ref.watch(latestFeatureVectorProvider);
    final isCalibrating = deviceState is Calibrating;
    final progress = deviceState is Calibrating ? deviceState.progress : 0;
    final failed = deviceState is Uncalibrated;
    final moving = featureVector?.accActivity ?? false;

    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: isCalibrating
                        ? Column(
                            key: const ValueKey('calibrating'),
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value: progress / 100.0,
                                      strokeWidth: 8,
                                      color: AppColors.primary,
                                      backgroundColor: AppColors.primary
                                          .withValues(alpha: 0.1),
                                    ),
                                    Text('$progress%',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                color: AppColors.primary)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text('Calibrating…',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                  textAlign: TextAlign.center),
                            ],
                          )
                        : Icon(
                            failed
                                ? Icons.warning_amber_rounded
                                : Icons.back_hand_sharp,
                            color: failed ? AppColors.error : AppColors.primary,
                            size: 80,
                            key: const ValueKey('idle'),
                          ),
                  ),
                  const SizedBox(height: 24),
                  if (!isCalibrating) ...[
                    Text(
                      failed ? 'Calibration Failed' : 'Baseline Calibration',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      failed
                          ? 'Not enough valid windows were collected. Please keep your wrist still and try again.'
                          : 'Sit comfortably and keep your wrist still for 3 minutes. NervGuard will learn your personal baseline.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (isCalibrating && moving) ...[
                    const SizedBox(height: 16),
                    GlassCard(
                      backgroundColor:
                          AppColors.stressMid.withValues(alpha: 0.1),
                      borderColor: AppColors.stressMid.withValues(alpha: 0.4),
                      child: Row(
                        children: [
                          const Icon(Icons.back_hand_outlined,
                              color: AppColors.stressMid),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                                'Movement detected — please stay still.',
                                style: const TextStyle(
                                    color: AppColors.stressMid,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (!isCalibrating)
                    FilledButton(
                      onPressed: _startCalibration,
                      child: Text(failed ? 'Try Again' : 'Start Calibration'),
                    ),
                  if (isCalibrating)
                    GlassCard(
                      child: Text(
                        'Calibration in progress. Do not remove the device.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
