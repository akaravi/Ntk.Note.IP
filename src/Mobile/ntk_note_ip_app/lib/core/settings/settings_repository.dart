import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';

class SettingsRepository {
  static const _localeKey = 'settings.locale';
  static const _localeChosenKey = 'settings.locale_chosen';
  static const _themeModeKey = 'settings.theme_mode';
  static const _biometricKey = 'settings.biometric_unlock';
  static const _backgroundMonitorKey = 'settings.background_ip_monitor';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final hasStoredLocale = prefs.containsKey(_localeKey);
    final localeCode = prefs.getString(_localeKey) ?? 'fa';
    final localeChosen = prefs.getBool(_localeChosenKey) ?? hasStoredLocale;
    final themeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final themeMode = ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)];
    final biometric = prefs.getBool(_biometricKey) ?? false;
    final backgroundMonitor = prefs.getBool(_backgroundMonitorKey) ?? false;

    return AppSettings(
      locale: Locale(localeCode),
      themeMode: themeMode,
      localeChosen: localeChosen,
      biometricUnlockEnabled: biometric,
      backgroundIpMonitorEnabled: backgroundMonitor,
    );
  }

  Future<void> saveLocaleChosen(bool chosen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_localeChosenKey, chosen);
  }

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> saveBiometricUnlock(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, enabled);
  }

  Future<void> saveBackgroundIpMonitor(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundMonitorKey, enabled);
  }
}
