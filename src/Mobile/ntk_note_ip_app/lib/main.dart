import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/background/background_ip_monitor_service.dart';
import 'core/background/background_monitor_prefs.dart';
import 'core/background/workmanager_callback.dart';
import 'core/config/app_config.dart';
import 'core/push/push_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushBootstrap.init();
  await Workmanager().initialize(ipnoteWorkmanagerCallback);
  await BackgroundMonitorPrefs.persistApiBaseUrl(AppConfig.current.apiBaseUrl);
  if (await BackgroundMonitorPrefs.isEnabled()) {
    await BackgroundIpMonitorService().syncRegistration(enabled: true);
  }

  runApp(const ProviderScope(child: IpNoteApp()));
}
