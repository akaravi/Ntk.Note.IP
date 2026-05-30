import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/settings/app_settings.dart';
import 'core/settings/supported_app_locales.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/auth_controller.dart';
import 'presentation/providers/settings_controller.dart';
import 'presentation/router/app_router.dart';
import 'presentation/screens/onboarding/language_picker_screen.dart';
import 'presentation/screens/splash/app_splash_screen.dart';
import 'presentation/widgets/app_lock_overlay.dart';

enum _BootstrapStep { splash, language, main }

class IpNoteApp extends ConsumerStatefulWidget {
  const IpNoteApp({super.key});

  @override
  ConsumerState<IpNoteApp> createState() => _IpNoteAppState();
}

class _IpNoteAppState extends ConsumerState<IpNoteApp> {
  _BootstrapStep _step = _BootstrapStep.splash;

  void _onSplashFinished() {
    if (!mounted) {
      return;
    }

    final settings = ref.read(settingsControllerProvider).value ?? AppSettings.defaults;
    final nextStep = settings.localeChosen
        ? _BootstrapStep.main
        : _BootstrapStep.language;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _step != _BootstrapStep.splash) {
        return;
      }
      setState(() => _step = nextStep);
    });
  }

  void _onLanguageFinished() {
    if (mounted) {
      setState(() => _step = _BootstrapStep.main);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final auth = ref.watch(authControllerProvider);
    final router = ref.watch(appRouterProvider);
    final settings = settingsAsync.value ?? AppSettings.defaults;
    final bootstrapReady = settingsAsync.hasValue && !auth.loading;

    switch (_step) {
      case _BootstrapStep.splash:
        return _buildSplashShell(settings, bootstrapReady);
      case _BootstrapStep.language:
        return _buildLanguageShell(settings);
      case _BootstrapStep.main:
        return _buildApp(context, ref, settings, router);
    }
  }

  Widget _buildSplashShell(AppSettings settings, bool bootstrapReady) {
    return _buildBootstrapMaterialApp(
      settings: settings,
      home: AppSplashScreen(
        ready: bootstrapReady,
        onFinished: _onSplashFinished,
      ),
      themeMode: ThemeMode.dark,
    );
  }

  Widget _buildLanguageShell(AppSettings settings) {
    final previewLocale = settings.localeChosen
        ? settings.locale
        : resolveBootstrapLocale(
            WidgetsBinding.instance.platformDispatcher.locale,
          );

    return _buildBootstrapMaterialApp(
      settings: settings.copyWith(locale: previewLocale),
      home: LanguagePickerScreen(onFinished: _onLanguageFinished),
      themeMode: ThemeMode.dark,
    );
  }

  Widget _buildBootstrapMaterialApp({
    required AppSettings settings,
    required Widget home,
    required ThemeMode themeMode,
  }) {
    final useRtlFont = settings.locale.usesRtlTypography;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(usePersianFont: useRtlFont),
      darkTheme: AppTheme.dark(usePersianFont: useRtlFont),
      themeMode: themeMode,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );
  }

  Widget _buildApp(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    GoRouter router,
  ) {
    final useRtlFont = settings.locale.usesRtlTypography;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(usePersianFont: useRtlFont),
      darkTheme: AppTheme.dark(usePersianFont: useRtlFont),
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
