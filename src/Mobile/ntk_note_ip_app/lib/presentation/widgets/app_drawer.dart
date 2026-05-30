import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/settings/supported_app_locales.dart';
import '../../l10n/app_localizations.dart';
import '../providers/admin_access_provider.dart';
import '../providers/auth_controller.dart';
import '../providers/settings_controller.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Future<void> _openLanguagePicker(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _LanguagePickerSheet(
        onSelected: (locale) async {
          await ref.read(settingsControllerProvider.notifier).setLocale(locale);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Future<void> _launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authControllerProvider);
    final adminAccess = ref.watch(adminAccessProvider);
    final apiBase = AppConfig.current.apiBaseUrl;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeTagline,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text(l10n.toolsHubLookup),
              onTap: () {
                Navigator.pop(context);
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build_circle_outlined),
              title: Text(l10n.toolsTitle),
              onTap: () {
                Navigator.pop(context);
                context.go('/tools');
              },
            ),
            if (auth.isAuthenticated) ...[
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: Text(l10n.dashboardTitle),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/dashboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.sticky_note_2_outlined),
                title: Text(l10n.notesTitle),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/ip-notes');
                },
              ),
            ],
            if (adminAccess.valueOrNull?.isAdministrator == true)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: Text(l10n.adminTitle),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin');
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.aboutTitle),
              onTap: () {
                Navigator.pop(context);
                context.go('/about');
              },
            ),
            ListTile(
              leading: const Icon(Icons.mail_outline),
              title: Text(l10n.footerContact),
              onTap: () {
                Navigator.pop(context);
                context.go('/contact');
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel_outlined),
              title: Text(l10n.copyrightTitle),
              onTap: () {
                Navigator.pop(context);
                context.go('/copyright');
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(l10n.footerChangelog),
              onTap: () {
                Navigator.pop(context);
                _launchExternal('$apiBase/changelog.html');
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_heart_outlined),
              title: Text(l10n.footerStatus),
              onTap: () {
                Navigator.pop(context);
                _launchExternal('$apiBase/status.html');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text(l10n.toggleLanguage),
              onTap: () => _openLanguagePicker(context, ref),
            ),
            if (auth.isAuthenticated)
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(l10n.logout),
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
              )
            else ...[
              ListTile(
                leading: const Icon(Icons.login),
                title: Text(l10n.loginTitle),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/login');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_outlined),
                title: Text(l10n.registerTitle),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/register');
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet({required this.onSelected});

  final ValueChanged<Locale> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.languagePickerTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final item in supportedAppLocales)
            ListTile(
              title: Text(item.nativeLabel),
              onTap: () => onSelected(item.locale),
            ),
        ],
      ),
    );
  }
}
