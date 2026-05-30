import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/dashboard/dashboard_timeline.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_controller.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/ltr_technical_text.dart';
import '../../widgets/background_monitor_setting_tile.dart';
import '../../widgets/biometric_setting_tile.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(dashboardControllerProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        actions: [
          IconButton(
            tooltip: l10n.toolsTitle,
            onPressed: () => context.go('/tools'),
            icon: const Icon(Icons.build_circle_outlined),
          ),
          IconButton(
            tooltip: l10n.notesTitle,
            onPressed: () => context.go('/ip-notes'),
            icon: const Icon(Icons.sticky_note_2_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              final notifier = ref.read(dashboardControllerProvider.notifier);
              if (value == 'csv') {
                notifier.exportCsv();
              } else if (value == 'json') {
                notifier.exportJson();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'csv', child: Text(l10n.exportCsv)),
              PopupMenuItem(value: 'json', child: Text(l10n.exportJson)),
            ],
          ),
          IconButton(
            tooltip: l10n.refresh,
            onPressed: () => ref.read(dashboardControllerProvider.notifier).load(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: l10n.logout,
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(dashboardControllerProvider.notifier).load(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.dashboardSubtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  const BiometricSettingTile(),
                  const SizedBox(height: 8),
                  const BackgroundMonitorSettingTile(),
                  if (state.error != null) ...[
                    const SizedBox(height: 12),
                    Text(state.error!, style: TextStyle(color: scheme.error)),
                  ],
                  const SizedBox(height: 16),
                  _StatsRow(stats: state.stats, l10n: l10n),
                  if (state.mapLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.mapUrl != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        state.mapUrl!,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                  if (state.countryBreakdown.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(l10n.dashboardCountries,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final row in state.countryBreakdown)
                          FilterChip(
                            label: Text('${row.code} (${row.count})'),
                            selected: state.countryFilter == row.code,
                            onSelected: (_) => ref
                                .read(dashboardControllerProvider.notifier)
                                .toggleCountryFilter(row.code),
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.search,
                    decoration: InputDecoration(
                      labelText: l10n.dashboardSearch,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: ref
                        .read(dashboardControllerProvider.notifier)
                        .setSearch,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.dashboardTimeline,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (state.filteredItems.isEmpty)
                    Text(l10n.dashboardEmpty)
                  else
                    ...state.filteredItems.map(
                      (item) => _TimelineTile(
                        item: item,
                        l10n: l10n,
                        onTap: () {
                          if (item.kind == DashboardTimelineKind.note) {
                            context.go(
                              '/ip-notes?address=${Uri.encodeComponent(item.address)}',
                            );
                          } else {
                            context.go(
                              '/?address=${Uri.encodeComponent(item.address)}',
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats, required this.l10n});

  final DashboardStats stats;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(label: l10n.statTotal, value: '${stats.total}'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                label: l10n.statUniqueIp,
                value: '${stats.uniqueAddresses}',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: l10n.statCountries,
                value: '${stats.uniqueCountries}',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatCard(
                label: l10n.statNotes,
                value: '${stats.noteCount}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: scheme.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.item,
    required this.l10n,
    required this.onTap,
  });

  final DashboardTimelineItem item;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final when = DateTime.tryParse(item.recordedAt);
    final whenText = when != null
        ? DateFormat.yMMMd().add_Hm().format(when.toLocal())
        : item.recordedAt;

    final subtitle = [
      if (item.city != null && item.city!.isNotEmpty) item.city,
      if (item.countryCode != null && item.countryCode!.isNotEmpty)
        item.countryCode!.toUpperCase(),
      if (item.deviceLabel != null && item.deviceLabel!.isNotEmpty)
        item.deviceLabel,
    ].join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          item.kind == DashboardTimelineKind.note
              ? Icons.sticky_note_2
              : Icons.public,
        ),
        title: LtrText(
          item.address,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        subtitle: subtitle.isEmpty ? Text(whenText) : Text('$subtitle\n$whenText'),
        isThreeLine: subtitle.isNotEmpty,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
