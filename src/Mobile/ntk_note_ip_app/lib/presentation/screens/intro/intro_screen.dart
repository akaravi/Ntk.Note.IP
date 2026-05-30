import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../widgets/app_scaffold.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      title: l10n.introTitle,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.introBody, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          _LinkTile(
            icon: Icons.search,
            title: l10n.toolsHubLookup,
            onTap: () => context.go('/'),
          ),
          _LinkTile(
            icon: Icons.build_circle_outlined,
            title: l10n.toolsTitle,
            onTap: () => context.go('/tools'),
          ),
          _LinkTile(
            icon: Icons.dashboard,
            title: l10n.dashboardTitle,
            onTap: () => context.go('/dashboard'),
          ),
          _LinkTile(
            icon: Icons.sticky_note_2_outlined,
            title: l10n.notesTitle,
            onTap: () => context.go('/ip-notes'),
          ),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
