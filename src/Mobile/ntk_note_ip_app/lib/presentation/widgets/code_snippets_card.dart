import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/cli/code_snippet_samples.dart';
import '../../l10n/app_localizations.dart';
import 'ltr_technical_text.dart';

class CodeSnippetsCard extends StatefulWidget {
  const CodeSnippetsCard({super.key});

  @override
  State<CodeSnippetsCard> createState() => _CodeSnippetsCardState();
}

class _CodeSnippetsCardState extends State<CodeSnippetsCard> {
  CodeSnippetTabId _activeTab = CodeSnippetTabId.csharp;
  var _copied = false;

  String _label(AppLocalizations l10n, String key) {
    return switch (key) {
      'codeTabCsharp' => l10n.codeTabCsharp,
      'codeTabJavascript' => l10n.codeTabJavascript,
      'codeTabPython' => l10n.codeTabPython,
      'codeTabBash' => l10n.codeTabBash,
      _ => key,
    };
  }

  Future<void> _copy(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
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
    final tab = codeSnippetTabs.firstWhere((t) => t.id == _activeTab);
    final code = tab.build(myIpPlainUrl);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.codeTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              l10n.codeHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final item in codeSnippetTabs)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: LtrText(_label(l10n, item.labelKey)),
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
              child: LtrCodeBlock(code: code),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: () => _copy(code),
                icon: const Icon(Icons.copy),
                label: Text(_copied ? l10n.copied : l10n.codeCopy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
