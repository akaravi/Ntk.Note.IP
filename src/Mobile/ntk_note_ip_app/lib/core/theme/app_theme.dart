import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const Color _seed = Color(0xFF6D28D9);

  static ThemeData light({required bool usePersianFont}) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, usePersianFont),
    );
  }

  static ThemeData dark({required bool usePersianFont}) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
      ),
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, usePersianFont),
    );
  }

  static TextTheme _textTheme(TextTheme base, bool usePersianFont) {
    if (!usePersianFont) {
      return base;
    }

    return GoogleFonts.vazirmatnTextTheme(base);
  }
}
