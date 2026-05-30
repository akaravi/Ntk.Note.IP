import 'package:flutter/material.dart';

class SupportedAppLocale {
  const SupportedAppLocale({
    required this.locale,
    required this.nativeLabel,
    required this.textDirection,
  });

  final Locale locale;
  final String nativeLabel;
  final TextDirection textDirection;
}

const supportedAppLocales = <SupportedAppLocale>[
  SupportedAppLocale(
    locale: Locale('fa'),
    nativeLabel: 'فارسی',
    textDirection: TextDirection.rtl,
  ),
  SupportedAppLocale(
    locale: Locale('en'),
    nativeLabel: 'English',
    textDirection: TextDirection.ltr,
  ),
  SupportedAppLocale(
    locale: Locale('ar'),
    nativeLabel: 'العربية',
    textDirection: TextDirection.rtl,
  ),
  SupportedAppLocale(
    locale: Locale('fr'),
    nativeLabel: 'Français',
    textDirection: TextDirection.ltr,
  ),
];

Locale resolveBootstrapLocale(Locale? deviceLocale) {
  final code = deviceLocale?.languageCode;
  if (code != null && supportedAppLocales.any((e) => e.locale.languageCode == code)) {
    return Locale(code);
  }

  return const Locale('fa');
}

extension AppLocaleTypography on Locale {
  bool get usesRtlTypography =>
      languageCode == 'fa' || languageCode == 'ar';
}
