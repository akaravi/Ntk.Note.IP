import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/background/background_ip_monitor_service.dart';
import '../../core/background/background_monitor_prefs.dart';
import '../../core/config/app_config.dart';
import '../../core/settings/app_settings.dart';
import '../../core/settings/settings_repository.dart';
import 'app_lock_controller.dart';

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    try {
      return await SettingsRepository()
          .load()
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      return AppSettings.defaults;
    } catch (_) {
      return AppSettings.defaults;
    }
  }

  Future<void> setLocale(Locale locale) async {
    final current = state.value ?? AppSettings.defaults;
    state = AsyncData(current.copyWith(locale: locale));
    await SettingsRepository().saveLocale(locale);
  }

  Future<void> completeLocaleOnboarding(Locale locale) async {
    final repo = SettingsRepository();
    final current = state.value ?? AppSettings.defaults;
    state = AsyncData(
      current.copyWith(locale: locale, localeChosen: true),
    );
    await repo.saveLocale(locale);
    await repo.saveLocaleChosen(true);
  }

  Future<void> cycleThemeMode() async {
    final current = state.value ?? AppSettings.defaults;
    final next = switch (current.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    state = AsyncData(current.copyWith(themeMode: next));
    await SettingsRepository().saveThemeMode(next);
  }

  Future<void> toggleLocale() async {
    final current = state.value ?? AppSettings.defaults;
    const order = [Locale('fa'), Locale('en'), Locale('ar'), Locale('fr')];
    final index = order.indexWhere(
      (locale) => locale.languageCode == current.locale.languageCode,
    );
    final next = order[(index + 1) % order.length];
    await setLocale(next);
  }

  /// Returns `null` on success, or an error code: `unavailable` | `failed`.
  Future<String?> setBiometricUnlock({
    required bool enabled,
    required String authReason,
  }) async {
    final repo = SettingsRepository();

    if (enabled) {
      final biometric = ref.read(biometricAuthServiceProvider);
      if (!await biometric.canCheckBiometrics) {
        return 'unavailable';
      }

      final ok = await biometric.authenticate(localizedReason: authReason);
      if (!ok) {
        return 'failed';
      }
    }

    final current = state.value ?? AppSettings.defaults;
    state = AsyncData(current.copyWith(biometricUnlockEnabled: enabled));
    await repo.saveBiometricUnlock(enabled);

    if (enabled) {
      ref.read(appLockControllerProvider.notifier).lock();
    } else {
      ref.read(appLockControllerProvider.notifier).unlockSilently();
    }

    return null;
  }

  Future<void> setBackgroundIpMonitor(bool enabled) async {
    final current = state.value ?? AppSettings.defaults;
    state = AsyncData(current.copyWith(backgroundIpMonitorEnabled: enabled));
    await SettingsRepository().saveBackgroundIpMonitor(enabled);
    await BackgroundMonitorPrefs.persistApiBaseUrl(AppConfig.current.apiBaseUrl);
    await BackgroundIpMonitorService().syncRegistration(enabled: enabled);
  }
}

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
