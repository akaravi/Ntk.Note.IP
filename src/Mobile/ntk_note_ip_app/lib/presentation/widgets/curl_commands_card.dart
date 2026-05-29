import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/cli/curl_command_snippets.dart';
import '../../l10n/app_localizations.dart';

class CurlCommandsCard extends StatefulWidget {
  const CurlCommandsCard({super.key});

  @override
  State<CurlCommandsCard> createState() => _CurlCommandsCardState();
}

class _CurlCommandsCardState extends State<CurlCommandsCard> {
  CurlCommandTabId _activeTab = CurlCommandTabId.linux;
  var _copied = false;

  String _label(AppLocalizations l10n, String key) {
    return switch (key) {
      'cmdTabLinux' => l10n.cmdTabLinux,
      'cmdTabMac' => l10n.cmdTabMac,
      'cmdTabWindows' => l10n.cmdTabWindows,
      'cmdTabPowershell' => l10n.cmdTabPowershell,
      'cmdTabMikrotik' => l10n.cmdTabMikrotik,
      _ => key,
    };
  }

  Future<void> _copyCommand(String command) async {
    await Clipboard.setData(ClipboardData(text: command));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final plainUrl = myIpPlainUrl;
    final tab = curlCommandTabs.firstWhere((t) => t.id == _activeTab);
    final command = tab.build(plainUrl);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.cmdTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in curlCommandTabs)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text(_label(l10n, item.labelKey)),
                        selected: _activeTab == item.id,
                        onSelected: (_) => setState(() => _activeTab = item.id),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                command,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: () => _copyCommand(command),
                icon: const Icon(Icons.copy),
                label: Text(_copied ? l10n.copied : l10n.copy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
