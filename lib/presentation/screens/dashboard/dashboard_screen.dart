import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/models/calibration_stats.dart';
import '../../../domain/models/device_state.dart';
import '../../../domain/models/feature_vector.dart';
import '../../../domain/models/inference_output.dart';
import '../../providers/ble_providers.dart';
import '../../providers/calibration_stats_provider.dart';
import '../../providers/device_state_provider.dart';
import '../../providers/inference_providers.dart';
import '../../providers/warmup_reset_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // FIX: this watch is the entire fix. Feature Vector (A5B30004) is
    // deliberately NOT subscribed at connection time (see Phase 7 of
    // the nine-phase sequence in app_architecture_handoff.md) — only
    // while this screen is visible. subscribeFeatureVector() and
    // unsubscribeFeatureVector() were both correctly implemented in
    // RealBleService, but nothing was calling them. Watching this
    // autoDispose provider here is what starts the subscription while
    // this screen is on the widget tree, and lets it clean up
    // automatically shortly after the screen is navigated away from.
    // See the doc comment on featureVectorSubscriptionProvider itself
    // for the full diagnosis.
    ref.watch(featureVectorSubscriptionProvider);

    final deviceState = ref.watch(deviceStateNotifierProvider).value;
    final connected = ref.watch(bleConnectionProvider).value ?? false;
    final warmup = ref.watch(warmupActiveProvider);
    final inference = ref.watch(latestInferenceProvider);
    final featureVector = ref.watch(windowFeatureVectorProvider);
    final calibration = ref.watch(calibrationStatsNotifierProvider).value;
    final battery = ref.watch(batteryLevelProvider);

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.transparent,
            title: const Text('NervGuard'),
            actions: [
              _BatteryIndicator(percent: battery),
              const SizedBox(width: 8),
              _ConnectionDot(connected: connected),
              const SizedBox(width: 16),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (!connected) _DisconnectedBanner(),
                if (connected && deviceState is NotWorn) _NotWornBanner(),
                if (connected && warmup) _WarmupBanner(),
                if (connected && deviceState is DeviceErrorState)
                  _ErrorBanner(deviceState.error),
                const SizedBox(height: 8),
                if (connected && deviceState is Monitoring && !warmup) ...[
                  _StressCard(inference: inference),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                          child: _EdaCard(fv: featureVector, cal: calibration)),
                      const SizedBox(width: 12),
                      Expanded(
                          child:
                              _TempCard(fv: featureVector, cal: calibration)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _HrvCard(fv: featureVector, cal: calibration),
                  const SizedBox(height: 8),
                  _DetailRow(fv: featureVector),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _AccCard(fv: featureVector)),
                      const SizedBox(width: 12),
                      Expanded(child: _WindowCard(inference: inference)),
                    ],
                  ),
                ] else if (connected && deviceState is Idle) ...[
                  _IdleCard(ref: ref),
                ] else if (!connected) ...[
                  _ConnectCard(ref: ref),
                ],
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Banners ──────────────────────────────────────────────────────────────────

class _DisconnectedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Banner(
        icon: Icons.bluetooth_disabled,
        message: 'Device not connected.',
        color: AppColors.fontSecondary);
  }
}

class _NotWornBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Banner(
        icon: Icons.watch_off_outlined,
        message: 'Device not on wrist. Monitoring resumes automatically.',
        color: AppColors.stressMid);
  }
}

class _WarmupBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Banner(
        icon: Icons.hourglass_top,
        message: 'Device warming up — first reading arriving shortly…',
        color: AppColors.primary);
  }
}

class _ErrorBanner extends StatelessWidget {
  final DeviceError error;
  const _ErrorBanner(this.error);
  @override
  Widget build(BuildContext context) {
    return _Banner(
        icon: Icons.error_outline,
        message: 'Device error: ${error.name}. Check the device.',
        color: AppColors.error);
  }
}

class _Banner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  const _Banner(
      {required this.icon, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderColor: color.withValues(alpha: 0.4),
        backgroundColor: color.withValues(alpha: 0.08),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
                child: Text(message,
                    style: TextStyle(
                        fontSize: 13,
                        color: color,
                        fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}

// ── Stress Card ──────────────────────────────────────────────────────────────

class _StressCard extends StatelessWidget {
  final InferenceOutput? inference;
  const _StressCard({this.inference});

  @override
  Widget build(BuildContext context) {
    final cls = inference?.inferenceClass ?? 0;
    final prob = inference?.probability ?? 0.0;
    final (label, color) = switch (cls) {
      2 => ('Stress', AppColors.stressHigh),
      1 => ('Watch Zone', AppColors.stressMid),
      _ => ('Baseline', AppColors.stressLow),
    };

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: color.withValues(alpha: 0.4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stress Level',
                  style: Theme.of(context).textTheme.labelLarge),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Text(label,
                    style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: prob),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 12,
                color: color,
                backgroundColor: color.withValues(alpha: 0.1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stress probability',
                  style: Theme.of(context).textTheme.bodyMedium),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: prob * 100),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (_, v, __) => Text('${v.toStringAsFixed(0)}%',
                    style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Physiological Cards ──────────────────────────────────────────────────────

double? _relSD(
    double? current, List<double>? means, List<double>? stds, int index) {
  if (current == null || means == null || stds == null) return null;
  if (index >= means.length || index >= stds.length) return null;
  final std = stds[index];
  if (std == 0) return null;
  return (current - means[index]) / std;
}

String _sdLabel(double? sd) {
  if (sd == null) return '—';
  final sign = sd >= 0 ? '+' : '';
  return '$sign${sd.toStringAsFixed(1)}σ';
}

class _EdaCard extends StatelessWidget {
  final FeatureVector? fv;
  final CalibrationStats? cal;
  const _EdaCard({this.fv, this.cal});

  @override
  Widget build(BuildContext context) {
    final val = fv?.edaMean;
    final sd = _relSD(val, cal?.means, cal?.stds, 0);
    return _PhysioCard(
      label: 'EDA',
      unit: 'µS',
      value: val?.toStringAsFixed(2) ?? '—',
      sdLabel: _sdLabel(sd),
      icon: Icons.electric_bolt_outlined,
      color: AppColors.secondary,
    );
  }
}

class _TempCard extends StatelessWidget {
  final FeatureVector? fv;
  final CalibrationStats? cal;
  const _TempCard({this.fv, this.cal});

  @override
  Widget build(BuildContext context) {
    final val = fv?.tempMean;
    final sd = _relSD(val, cal?.means, cal?.stds, 8);
    return _PhysioCard(
      label: 'Temp',
      unit: '°C',
      value: val?.toStringAsFixed(1) ?? '—',
      sdLabel: _sdLabel(sd),
      icon: Icons.thermostat_outlined,
      color: AppColors.stressMid,
    );
  }
}

/// Two numbers the band already sends but the tiles do not show, plus the window
/// number of the tiles above. Heart rate is derived from the mean beat interval.
class _DetailRow extends StatelessWidget {
  final FeatureVector? fv;
  const _DetailRow({this.fv});

  @override
  Widget build(BuildContext context) {
    final f = fv;
    final rr = f?.hrvMeanRr;
    final bool haveRate = f != null && f.hrvAvailable && rr != null && rr > 0;
    final String rateText =
        haveRate ? '${(60000 / rr).toStringAsFixed(0)} bpm' : 'unavailable';
    final range = f?.edaRange;
    final String rangeText =
        range != null ? '${range.toStringAsFixed(2)} \u00b5S' : '-';
    final String windowText = f != null ? '${f.windowSequence}' : '-';
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Heart rate: $rateText    EDA range: $rangeText',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
              'Window $windowText. RMSSD is indicative only; '
              'heart rate is the more reliable pulse measure.',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _HrvCard extends StatelessWidget {
  final FeatureVector? fv;
  final CalibrationStats? cal;
  const _HrvCard({this.fv, this.cal});

  @override
  Widget build(BuildContext context) {
    final available = fv?.hrvAvailable ?? false;
    final val = fv?.hrvRmssd;
    final sd = _relSD(val, cal?.means, cal?.stds, 4);

    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.stressLow.withValues(alpha: 0.1)),
            child: const Icon(Icons.favorite_border,
                color: AppColors.stressLow, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HRV · RMSSD',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 2),
                available
                    ? Text('${val?.toStringAsFixed(0) ?? '—'} ms',
                        style: const TextStyle(
                            color: AppColors.stressLow,
                            fontSize: 20,
                            fontWeight: FontWeight.w700))
                    : const Text('HRV unavailable',
                        style: TextStyle(
                            color: AppColors.fontSecondary, fontSize: 13)),
              ],
            ),
          ),
          if (available && sd != null)
            Text(_sdLabel(sd),
                style: TextStyle(
                  color: sd.abs() > 1.5
                      ? AppColors.stressHigh
                      : AppColors.fontSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                )),
        ],
      ),
    );
  }
}

class _AccCard extends StatelessWidget {
  final FeatureVector? fv;
  const _AccCard({this.fv});

  @override
  Widget build(BuildContext context) {
    final active = fv?.accActivity ?? false;
    return _PhysioCard(
      label: 'Motion',
      unit: '',
      value: active ? 'Moving' : 'Still',
      sdLabel: '',
      icon: Icons.directions_walk_outlined,
      color: active ? AppColors.stressMid : AppColors.fontSecondary,
    );
  }
}

class _WindowCard extends StatelessWidget {
  final InferenceOutput? inference;
  const _WindowCard({this.inference});

  @override
  Widget build(BuildContext context) {
    return _PhysioCard(
      label: 'Window',
      unit: '',
      value: inference != null ? '#${inference!.windowSequence}' : '—',
      sdLabel: 'rolling',
      icon: Icons.timeline_outlined,
      color: AppColors.primary,
    );
  }
}

class _PhysioCard extends StatelessWidget {
  final String label;
  final String unit;
  final String value;
  final String sdLabel;
  final IconData icon;
  final Color color;
  const _PhysioCard(
      {required this.label,
      required this.unit,
      required this.value,
      required this.sdLabel,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '$value${unit.isNotEmpty ? ' $unit' : ''}',
              key: ValueKey(value),
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          if (sdLabel.isNotEmpty)
            Text(sdLabel, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

// ── Action Cards ─────────────────────────────────────────────────────────────

class _IdleCard extends StatelessWidget {
  final WidgetRef ref;
  const _IdleCard({required this.ref});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          const Icon(Icons.play_circle_outline,
              color: AppColors.primary, size: 48),
          const SizedBox(height: 12),
          Text('Ready to Monitor',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
              'Device is calibrated and idle. Start monitoring to begin stress detection.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref
                .read(deviceStateNotifierProvider.notifier)
                .startMonitoring(),
            child: const Text('Start Monitoring'),
          ),
        ],
      ),
    );
  }
}

class _ConnectCard extends StatelessWidget {
  final WidgetRef ref;
  const _ConnectCard({required this.ref});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          const Icon(Icons.bluetooth_searching,
              color: AppColors.primary, size: 48),
          const SizedBox(height: 12),
          Text('No Device Connected',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
              'Your NervGuard wearable is not connected. Make sure it is charged and in range.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref.read(bleServiceProvider).connect(),
            child: const Text('Connect Device'),
          ),
        ],
      ),
    );
  }
}

class _BatteryIndicator extends StatelessWidget {
  final int percent;
  const _BatteryIndicator({required this.percent});

  @override
  Widget build(BuildContext context) {
    final color = percent > 20 ? AppColors.stressLow : AppColors.error;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          percent > 80
              ? Icons.battery_full
              : percent > 40
                  ? Icons.battery_4_bar
                  : Icons.battery_1_bar,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 2),
        Text('$percent%',
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ConnectionDot extends StatelessWidget {
  final bool connected;
  const _ConnectionDot({required this.connected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: connected ? AppColors.stressLow : AppColors.fontSecondary,
      ),
    );
  }
}
