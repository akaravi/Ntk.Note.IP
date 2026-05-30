import 'package:flutter/foundation.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.clientId,
    required this.clientSecret,
  });

  final AppFlavor flavor;
  final String apiBaseUrl;
  final String clientId;
  final String clientSecret;

  static AppConfig? _current;

  static AppConfig get current {
    return _current ??= _buildFallback();
  }

  static void apply({
    required String apiBaseUrl,
    required String clientId,
    required String clientSecret,
  }) {
    _current = AppConfig(
      flavor: kReleaseMode ? AppFlavor.prod : AppFlavor.dev,
      apiBaseUrl: apiBaseUrl,
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }

  static AppConfig _buildFallback() {
    return AppConfig(
      flavor: kReleaseMode ? AppFlavor.prod : AppFlavor.dev,
      apiBaseUrl: _defaultApiBaseUrl(),
      clientId: 'flutter-app',
      clientSecret: '',
    );
  }

  static String _defaultApiBaseUrl() {
    const fromDefine = String.fromEnvironment('API_BASE_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }

    if (kReleaseMode) {
      return 'https://ipnote.ir';
    }

    if (kIsWeb) {
      return 'http://localhost:5340';
    }

    return 'http://10.0.2.2:5340';
  }
}
