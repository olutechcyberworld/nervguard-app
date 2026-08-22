import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../providers/intervention_pool_provider.dart';
import '../../providers/onboarding_provider.dart';

const _mildOptions = [
  'Lo-fi music',
  'Classical music',
  'Nature sounds',
  'Box breathing',
  '4-7-8 breathing',
  'Affirmations',
  'Calming imagery',
  'Humour content',
  'Guided relaxation',
];

const _intensiveOptions = [
  '4-7-8 Breathing',
  '5-4-3-2-1 Grounding',
  'Cognitive reframing',
  'Progressive muscle relaxation',
];

class InterventionPoolScreen extends ConsumerStatefulWidget {
  const InterventionPoolScreen({super.key});

  @override
  ConsumerState<InterventionPoolScreen> createState() =>
      _InterventionPoolScreenState();
}

class _InterventionPoolScreenState
    extends ConsumerState<InterventionPoolScreen> {
  final Set<String> _mild = {};
  final Set<String> _intensive = {};
  bool _saving = false;

  bool get _valid =>
      _mild.length >= 2 && _mild.length <= 4 && _intensive.isNotEmpty;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(interventionPoolProvider.notifier).setPools(
            mild: _mild.toList(),
            intensive: _intensive.toList(),
          );
      await ref
          .read(onboardingStatusProvider.notifier)
          .advance(OnboardingStep.calibration);
      if (mounted) context.go('/onboarding/calibration');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Your Intervention Pool',
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 8),
                      Text(
                          'Select 2–4 mild activities and at least 1 intensive exercise. '
                          'NervGuard will draw from these when stress is detected.',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _SectionHeader(
                        label: 'Mild Activities (select 2–4)',
                        selected: _mild.length,
                        max: 4,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 8),
                      ..._mildOptions.map((item) => _PoolChip(
                            label: item,
                            selected: _mild.contains(item),
                            onTap: () => setState(() {
                              if (_mild.contains(item)) {
                                _mild.remove(item);
                              } else if (_mild.length < 4) {
                                _mild.add(item);
                              }
                            }),
                          )),
                      const SizedBox(height: 24),
                      _SectionHeader(
                        label: 'Intensive (iCBT) — select ≥1',
                        selected: _intensive.length,
                        max: _intensiveOptions.length,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(height: 8),
                      ..._intensiveOptions.map((item) => _PoolChip(
                            label: item,
                            selected: _intensive.contains(item),
                            accentColor: AppColors.secondary,
                            onTap: () => setState(() {
                              if (_intensive.contains(item)) {
                                _intensive.remove(item);
                              } else {
                                _intensive.add(item);
                              }
                            }),
                          )),
                      const SizedBox(height: 24),
                      if (_saving)
                        const Center(child: CircularProgressIndicator())
                      else
                        FilledButton(
                          onPressed: _valid ? _save : null,
                          child: const Text('Continue'),
                        ),
                      if (!_valid && _mild.length < 2)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Select at least 2 mild activities.',
                            style: TextStyle(
                                color: AppColors.fontSecondary, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int selected;
  final int max;
  final Color color;
  const _SectionHeader(
      {required this.label,
      required this.selected,
      required this.max,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: color))),
        Text('$selected / $max',
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PoolChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accentColor;
  const _PoolChip(
      {required this.label,
      required this.selected,
      required this.onTap,
      this.accentColor = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderColor: selected
              ? accentColor.withValues(alpha: 0.6)
              : AppColors.glassBorder,
          backgroundColor: selected
              ? accentColor.withValues(alpha: 0.1)
              : AppColors.glassWhite,
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected ? accentColor : AppColors.fontSecondary,
                  key: ValueKey(selected),
                ),
              ),
              const SizedBox(width: 12),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
