import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.locale,
    required this.themeMode,
    this.biometricUnlockEnabled = false,
    this.backgroundIpMonitorEnabled = false,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final bool biometricUnlockEnabled;
  final bool backgroundIpMonitorEnabled;

  static const AppSettings defaults = AppSettings(
    locale: Locale('fa'),
    themeMode: ThemeMode.system,
  );

  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? biometricUnlockEnabled,
    bool? backgroundIpMonitorEnabled,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      biometricUnlockEnabled:
          biometricUnlockEnabled ?? this.biometricUnlockEnabled,
      backgroundIpMonitorEnabled:
          backgroundIpMonitorEnabled ?? this.backgroundIpMonitorEnabled,
    );
  }
}
