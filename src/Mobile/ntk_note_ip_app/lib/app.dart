import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/settings/app_settings.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/settings_controller.dart';
import 'presentation/router/app_router.dart';
import 'presentation/widgets/app_lock_overlay.dart';

class IpNoteApp extends ConsumerWidget {
  const IpNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final router = ref.watch(appRouterProvider);

    return settingsAsync.when(
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (_, _) => _buildApp(context, ref, AppSettings.defaults, router),
      data: (settings) => _buildApp(context, ref, settings, router),
    );
  }

  Widget _buildApp(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    GoRouter router,
  ) {
    final useFaFont = settings.locale.languageCode == 'fa';

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(usePersianFont: useFaFont),
      darkTheme: AppTheme.dark(usePersianFont: useFaFont),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (context, child) {
        return AppLockOverlay(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
