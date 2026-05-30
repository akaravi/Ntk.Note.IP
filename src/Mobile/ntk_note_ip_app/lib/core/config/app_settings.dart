import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppSettings {
  AppSettings._({
    required this.clientId,
    required this.apiBaseUrl,
    required this.clientSecret,
  });

  static AppSettings? _instance;

  static AppSettings get instance {
    final value = _instance;
    if (value == null) {
      throw StateError('AppSettings.load() must complete before use.');
    }
    return value;
  }

  static bool get isLoaded => _instance != null;

  final String clientId;
  final String apiBaseUrl;
  final String clientSecret;

  static Future<void> load() async {
    final fileName = kReleaseMode
        ? 'appsettings.Production.json'
        : 'appsettings.json';
    final raw = await rootBundle.loadString(fileName);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    _instance = AppSettings._(
      clientId: (json['ClientId'] as String? ?? 'flutter-app').trim(),
      apiBaseUrl: (json['ApiBaseUrl'] as String? ?? '').trim(),
      clientSecret: (json['Secret'] as String? ?? '').trim(),
    );
  }
}
