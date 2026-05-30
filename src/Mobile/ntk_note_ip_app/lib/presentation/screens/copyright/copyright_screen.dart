import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../widgets/app_scaffold.dart';

class CopyrightScreen extends StatelessWidget {
  const CopyrightScreen({super.key});

  Future<void> _email() async {
    final uri = Uri.parse('mailto:karavi.alireza@gmail.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      title: l10n.copyrightTitle,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.copyrightSubtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _Block(title: l10n.copyrightOwnershipTitle, body: l10n.copyrightOwnershipBody),
          _Block(title: l10n.copyrightLicenseTitle, body: l10n.copyrightLicenseBody),
          _Block(title: l10n.copyrightTrademarksTitle, body: l10n.copyrightTrademarksBody),
          _Block(title: l10n.copyrightThirdPartyTitle, body: l10n.copyrightThirdPartyBody),
          _Block(title: l10n.copyrightPrivacyTitle, body: l10n.copyrightPrivacyBody),
          _Block(title: l10n.copyrightContactTitle, body: l10n.copyrightContactBody),
          TextButton(onPressed: _email, child: const Text('karavi.alireza@gmail.com')),
          const SizedBox(height: 8),
          TextButton(onPressed: () => context.go('/'), child: Text(l10n.copyrightBack)),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
