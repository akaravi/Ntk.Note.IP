import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/auth_controller.dart';
import '../../providers/ip_history_provider.dart' show ipHistoryListProvider, ipHistoryStoreProvider;
import '../../providers/settings_controller.dart';
import '../../widgets/curl_commands_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/ip_map_preview.dart';
import 'home_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.initialAddress});

  final String? initialAddress;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final address = widget.initialAddress?.trim();
    if (address != null && address.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(homeControllerProvider.notifier).lookupExternal(address);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(homeControllerProvider);
    final auth = ref.watch(authControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final details = state.details;
    final historyAsync = ref.watch(ipHistoryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.toggleLanguage,
            onPressed: () =>
                ref.read(settingsControllerProvider.notifier).toggleLocale(),
            icon: const Icon(Icons.translate),
          ),
          IconButton(
            tooltip: l10n.toggleTheme,
            onPressed: () =>
                ref.read(settingsControllerProvider.notifier).cycleThemeMode(),
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            tooltip: l10n.toolsTitle,
            onPressed: () => context.go('/tools'),
            icon: const Icon(Icons.build_circle_outlined),
          ),
          if (auth.isAuthenticated)
            IconButton(
              tooltip: l10n.notesTitle,
              onPressed: () => context.go('/ip-notes'),
              icon: const Icon(Icons.sticky_note_2_outlined),
            ),
          IconButton(
            tooltip: auth.isAuthenticated ? l10n.dashboardTitle : l10n.loginTitle,
            onPressed: () => context.go(
              auth.isAuthenticated ? '/dashboard' : '/login',
            ),
            icon: Icon(auth.isAuthenticated ? Icons.dashboard : Icons.login),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.homeTagline, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _HeroCard(
              l10n: l10n,
              state: state,
              scheme: scheme,
              onCopy: () => ref.read(homeControllerProvider.notifier).copyAddress(),
              onQr: () => ref.read(homeControllerProvider.notifier).toggleQr(),
              onRetry: () => ref.read(homeControllerProvider.notifier).load(),
              onNoteThis: () => _noteThisIp(context, ref, state),
            ),
            if (state.showQr && state.myIp?.address.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              Center(
                child: QrImageView(
                  data: state.myIp!.address,
                  size: 180,
                  backgroundColor: scheme.surface,
                ),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              key: ValueKey('lookup-${state.myIp?.address ?? ''}'),
              initialValue: state.lookupAddress,
              decoration: InputDecoration(
                labelText: l10n.lookupAddress,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: state.loading
                      ? null
                      : () => ref.read(homeControllerProvider.notifier).lookupAddress(),
                ),
              ),
              onChanged: ref.read(homeControllerProvider.notifier).setLookupAddress,
              onFieldSubmitted: (_) =>
                  ref.read(homeControllerProvider.notifier).lookupAddress(),
            ),
            if (state.localIp != null) ...[
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.wifi),
                  title: Text(l10n.localIp),
                  subtitle: Text(
                    state.localIp!,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ],
            if (state.detailsLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (details != null) ...[
              const SizedBox(height: 16),
              IpMapPreview(geo: details.geo, openMapLabel: l10n.openMap),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.geoTitle, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      InfoRow(label: l10n.country, value: details.geo.country ?? '—'),
                      InfoRow(
                        label: l10n.region,
                        value: [
                          details.geo.city,
                          details.geo.region,
                        ].where((v) => v != null && v.isNotEmpty).join(' · '),
                      ),
                      InfoRow(label: l10n.timezone, value: details.geo.timezone ?? ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.networkTitle, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      InfoRow(label: l10n.isp, value: details.isp ?? '—'),
                      InfoRow(label: l10n.asn, value: details.asn.number ?? '—'),
                      InfoRow(
                        label: l10n.organization,
                        value: details.asn.organization ?? '',
                      ),
                      InfoRow(label: l10n.reverseDns, value: details.reverseDns ?? ''),
                    ],
                  ),
                ),
              ),
              if (state.deviceInfo != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.devices),
                    title: Text(l10n.deviceTitle),
                    subtitle: Text(state.deviceInfo!.label),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 16),
            const CurlCommandsCard(),
            historyAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (entries) {
                if (entries.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.recentHistory,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ref.read(ipHistoryStoreProvider).clear();
                            ref.invalidate(ipHistoryListProvider);
                          },
                          child: Text(l10n.historyClear),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...entries.take(8).map(
                          (entry) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(
                                entry.address,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                              subtitle: Text(
                                [
                                  entry.city,
                                  entry.countryCode?.toUpperCase(),
                                ].whereType<String>().where((v) => v.isNotEmpty).join(' · '),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => ref
                                  .read(homeControllerProvider.notifier)
                                  .lookupExternal(entry.address),
                            ),
                          ),
                        ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _noteThisIp(BuildContext context, WidgetRef ref, HomeState state) {
    final ip = state.myIp?.address.trim();
    if (ip == null || ip.isEmpty) {
      return;
    }

    final target =
        '/ip-notes?address=${Uri.encodeQueryComponent(ip)}&capture=1';
    final auth = ref.read(authControllerProvider);
    if (auth.isAuthenticated) {
      context.go(target);
      return;
    }

    context.go('/login?from=${Uri.encodeComponent(target)}');
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.l10n,
    required this.state,
    required this.scheme,
    required this.onCopy,
    required this.onQr,
    required this.onRetry,
    required this.onNoteThis,
  });

  final AppLocalizations l10n;
  final HomeState state;
  final ColorScheme scheme;
  final VoidCallback onCopy;
  final VoidCallback onQr;
  final VoidCallback onRetry;
  final VoidCallback onNoteThis;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.loading)
              Center(child: Text(l10n.loading))
            else if (state.error != null && state.myIp == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(state.error!, style: TextStyle(color: scheme.error)),
                  const SizedBox(height: 8),
                  FilledButton.tonal(onPressed: onRetry, child: Text(l10n.retry)),
                ],
              )
            else if (state.myIp != null) ...[
              Text(
                state.myIp!.address,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.myIp,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  Chip(
                    label: Text(state.myIp!.isIPv6 ? l10n.ipv6 : l10n.ipv4),
                  ),
                  Chip(label: Text('${l10n.scope}: ${state.myIp!.scope}')),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onNoteThis,
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: Theme.of(context).textTheme.labelMedium,
                ),
                child: Text(l10n.noteThis),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onCopy,
                      icon: const Icon(Icons.copy),
                      label: Text(state.copied ? l10n.copied : l10n.copy),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: l10n.showQr,
                    onPressed: onQr,
                    icon: const Icon(Icons.qr_code_2),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
