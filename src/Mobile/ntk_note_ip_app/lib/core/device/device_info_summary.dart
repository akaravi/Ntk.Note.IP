import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DeviceInfoSummary {
  const DeviceInfoSummary({
    required this.label,
    required this.os,
    required this.device,
    required this.language,
  });

  final String label;
  final String os;
  final String device;
  final String language;

  static Future<DeviceInfoSummary> load() async {
    final plugin = DeviceInfoPlugin();
    final language =
        WidgetsBinding.instance.platformDispatcher.locale.toLanguageTag();

    if (kIsWeb) {
      final web = await plugin.webBrowserInfo;
      return DeviceInfoSummary(
        label: '${web.browserName.name} · Web',
        os: 'Web',
        device: web.userAgent ?? 'Browser',
        language: language,
      );
    }

    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      final os = 'Android ${info.version.release}';
      return DeviceInfoSummary(
        label: '$os · ${info.model}',
        os: os,
        device: info.model,
        language: language,
      );
    }

    if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      final os = '${info.systemName} ${info.systemVersion}';
      return DeviceInfoSummary(
        label: '$os · ${info.model}',
        os: os,
        device: info.model,
        language: language,
      );
    }

    if (Platform.isWindows) {
      final info = await plugin.windowsInfo;
      return DeviceInfoSummary(
        label: 'Windows · ${info.computerName}',
        os: 'Windows',
        device: info.computerName,
        language: language,
      );
    }

    return DeviceInfoSummary(
      label: Platform.operatingSystem,
      os: Platform.operatingSystem,
      device: Platform.localHostname,
      language: language,
    );
  }
}
