import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/local/database/app_database.dart';
import '../../providers/infrastructure_providers.dart';

final _historyProvider = FutureProvider.autoDispose
    .family<_HistoryData, _HistoryFilter>((ref, filter) async {
  final db = ref.watch(appDatabaseProvider);
  final sessions = await db.monitoringSessionDao.getHistory(
    fromMs: filter.from?.millisecondsSinceEpoch,
    toMs: filter.to?.millisecondsSinceEpoch,
  );
  final logs = await db.interventionLogDao.getHistory(
    fromMs: filter.from?.millisecondsSinceEpoch,
    toMs: filter.to?.millisecondsSinceEpoch,
  );
  return _HistoryData(sessions: sessions, logs: logs);
});

class _HistoryFilter {
  final DateTime? from;
  final DateTime? to;
  const _HistoryFilter({this.from, this.to});
  @override
  bool operator ==(Object o) =>
      o is _HistoryFilter && o.from == from && o.to == to;
  @override
  int get hashCode => Object.hash(from, to);
}

class _HistoryData {
  final List<MonitoringSession> sessions;
  final List<InterventionLog> logs;
  const _HistoryData({required this.sessions, required this.logs});
}

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  _HistoryFilter _filter = const _HistoryFilter();
  String _filterLabel = 'All time';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) =>
          Theme(data: Theme.of(context), child: child!),
    );

    // FIX: Wrapped in a block
    if (range == null) {
      return;
    }

    setState(() {
      _filter = _HistoryFilter(
        from: range.start,
        to: range.end.add(const Duration(days: 1)),
      );
      _filterLabel = '${_fmt(range.start)} – ${_fmt(range.end)}';
    });
  }

  void _clearFilter() => setState(() {
        _filter = const _HistoryFilter();
        _filterLabel = 'All time';
      });

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(_historyProvider(_filter));

    return GlassBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Text('History',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const Spacer(),
                  GestureDetector(
                    onTap: _pickRange,
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.date_range,
                              size: 16, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(_filterLabel,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                          if (_filter.from != null) ...[
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: _clearFilter,
                              child: const Icon(Icons.close,
                                  size: 16, color: AppColors.fontSecondary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabs,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.fontSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [Tab(text: 'Sessions'), Tab(text: 'Interventions')],
            ),
            Expanded(
              child: historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (data) => TabBarView(
                  controller: _tabs,
                  children: [
                    _SessionList(sessions: data.sessions),
                    _LogList(logs: data.logs),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  final List<MonitoringSession> sessions;
  const _SessionList({required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const _EmptyState(message: 'No monitoring sessions yet.');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, i) {
        final s = sessions[i];
        final start = DateTime.fromMillisecondsSinceEpoch(s.startedAt);
        final end = s.endedAt != null
            ? DateTime.fromMillisecondsSinceEpoch(s.endedAt!)
            : null;

        // FIX: Used null-aware operator
        final duration = end?.difference(start);

        final avgProb = s.avgStressProb;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.monitor_heart_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(_fmtDate(start),
                        style: Theme.of(context).textTheme.labelLarge),
                    const Spacer(),
                    if (duration != null)
                      Text(_fmtDuration(duration),
                          style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Stat(
                        label: 'Stress events', value: '${s.stressEventCount}'),
                    const SizedBox(width: 16),
                    _Stat(
                        label: 'Interventions',
                        value: '${s.interventionCount}'),
                    if (avgProb != null) ...[
                      const SizedBox(width: 16),
                      _Stat(
                          label: 'Avg stress',
                          value: '${(avgProb * 100).toStringAsFixed(0)}%'),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}

class _LogList extends StatelessWidget {
  final List<InterventionLog> logs;
  const _LogList({required this.logs});

  @override
  Widget build(BuildContext context) {
    // FIX: Wrapped in a block
    if (logs.isEmpty) {
      return const _EmptyState(message: 'No interventions recorded yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, i) {
        final l = logs[i];
        final ts = DateTime.fromMillisecondsSinceEpoch(l.triggeredAt);
        final (statusColor, statusIcon) = switch (l.status) {
          'helped' => (AppColors.stressLow, Icons.thumb_up_outlined),
          'skipped' => (AppColors.fontSecondary, Icons.skip_next_outlined),
          _ => (AppColors.stressMid, Icons.notifications_outlined),
        };

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            borderColor: statusColor.withValues(alpha: 0.3),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.intervention,
                          style: Theme.of(context).textTheme.labelLarge),
                      Text('${l.tier} · ${l.status}',
                          style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Text(
                  '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.fontPrimary)),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined,
              size: 48, color: AppColors.fontSecondary),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
