import 'package:flutter/services.dart';

/// Light haptic cues for primary user actions.
class AppHaptics {
  const AppHaptics._();

  static Future<void> success() => HapticFeedback.mediumImpact();

  static Future<void> selection() => HapticFeedback.selectionClick();

  static Future<void> light() => HapticFeedback.lightImpact();
}
