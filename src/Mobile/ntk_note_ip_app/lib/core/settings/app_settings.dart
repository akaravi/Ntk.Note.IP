import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.locale,
    required this.themeMode,
    this.localeChosen = false,
    this.biometricUnlockEnabled = false,
    this.backgroundIpMonitorEnabled = false,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final bool localeChosen;
  final bool biometricUnlockEnabled;
  final bool backgroundIpMonitorEnabled;

  static const AppSettings defaults = AppSettings(
    locale: Locale('fa'),
    themeMode: ThemeMode.system,
    localeChosen: false,
  );

  AppSettings copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? localeChosen,
    bool? biometricUnlockEnabled,
    bool? backgroundIpMonitorEnabled,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      localeChosen: localeChosen ?? this.localeChosen,
      biometricUnlockEnabled:
          biometricUnlockEnabled ?? this.biometricUnlockEnabled,
      backgroundIpMonitorEnabled:
          backgroundIpMonitorEnabled ?? this.backgroundIpMonitorEnabled,
    );
  }
}
