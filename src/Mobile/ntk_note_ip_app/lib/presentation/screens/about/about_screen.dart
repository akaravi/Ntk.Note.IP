import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../widgets/app_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppScaffold(
      title: l10n.aboutTitle,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.aboutSubtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _Section(
            title: l10n.aboutProductTitle,
            body: l10n.aboutProductBody,
            bullets: [
              l10n.aboutFeatureLookup,
              l10n.aboutFeatureNotes,
              l10n.aboutFeatureTools,
              l10n.aboutFeatureMobile,
            ],
          ),
          _Section(
            title: l10n.aboutNtkTitle,
            body: l10n.aboutNtkBody,
            links: [
              ('ntk.ir', 'https://ntk.ir/'),
              ('ntkhost.com', 'https://ntkhost.com/'),
            ],
            onLink: _open,
          ),
          _Section(
            title: l10n.aboutAuthorTitle,
            body: l10n.aboutAuthorBody,
            bullets: [
              l10n.aboutAuthorSkill1,
              l10n.aboutAuthorSkill2,
              l10n.aboutAuthorSkill3,
            ],
            links: [
              ('alikaravi.com', 'https://alikaravi.com/'),
              ('GitHub', 'https://github.com/akaravi'),
            ],
            onLink: _open,
          ),
          _Section(
            title: l10n.aboutEcosystemTitle,
            body: l10n.aboutEcosystemHint,
            links: [
              ('karavi.ca', 'https://karavi.ca/'),
              ('alonak.com', 'https://alonak.com/'),
              ('alonak.ae', 'https://alonak.ae/'),
            ],
            onLink: _open,
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: () => context.go('/'), child: Text(l10n.aboutBack)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.body,
    this.bullets = const [],
    this.links = const [],
    this.onLink,
  });

  final String title;
  final String body;
  final List<String> bullets;
  final List<(String, String)> links;
  final Future<void> Function(String url)? onLink;

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
            if (bullets.isNotEmpty) ...[
              const SizedBox(height: 8),
              for (final item in bullets)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 8, bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
            ],
            if (links.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: [
                  for (final (label, url) in links)
                    TextButton(
                      onPressed: onLink == null ? null : () => onLink!(url),
                      child: Text(label),
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
