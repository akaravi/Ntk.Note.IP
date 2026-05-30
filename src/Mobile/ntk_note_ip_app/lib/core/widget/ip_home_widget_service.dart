import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../config/app_config.dart';
import 'ip_home_widget_keys.dart';

/// Syncs the latest public IP into the Android home-screen widget.
class IpHomeWidgetService {
  IpHomeWidgetService._();

  static bool get isSupported => !kIsWeb && Platform.isAndroid;

  /// Persists API base URL so the native widget can fetch IP without opening the app.
  static Future<void> bootstrapNativeConfig() async {
    if (!isSupported) {
      return;
    }

    await HomeWidget.saveWidgetData<String>(
      IpHomeWidgetKeys.apiBaseUrl,
      AppConfig.current.apiBaseUrl.trim(),
    );
  }

  static Future<void> sync({
    required String address,
    String? scope,
    bool isIPv6 = false,
    String? city,
    String? countryCode,
    DateTime? updatedAt,
  }) async {
    if (!isSupported || address.trim().isEmpty) {
      return;
    }

    final location = _formatLocation(city, countryCode);
    final stamp = (updatedAt ?? DateTime.now().toUtc()).toIso8601String();

    await HomeWidget.saveWidgetData<String>(
      IpHomeWidgetKeys.ipAddress,
      address.trim(),
    );
    await HomeWidget.saveWidgetData<String>(
      IpHomeWidgetKeys.ipScope,
      scope?.trim() ?? '',
    );
    await HomeWidget.saveWidgetData<bool>(
      IpHomeWidgetKeys.isIpv6,
      isIPv6,
    );
    await HomeWidget.saveWidgetData<String>(
      IpHomeWidgetKeys.location,
      location,
    );
    await HomeWidget.saveWidgetData<String>(
      IpHomeWidgetKeys.updatedAt,
      stamp,
    );
    await HomeWidget.saveWidgetData<String>(
      IpHomeWidgetKeys.apiBaseUrl,
      AppConfig.current.apiBaseUrl.trim(),
    );

    await HomeWidget.updateWidget(
      qualifiedAndroidName: IpHomeWidgetKeys.qualifiedAndroidProvider,
      androidName: IpHomeWidgetKeys.androidProvider,
      iOSName: IpHomeWidgetKeys.androidProvider,
    );
  }

  static String _formatLocation(String? city, String? countryCode) {
    final parts = <String>[
      if (city != null && city.trim().isNotEmpty) city.trim(),
      if (countryCode != null && countryCode.trim().isNotEmpty)
        countryCode.trim().toUpperCase(),
    ];
    return parts.join(' · ');
  }
}
