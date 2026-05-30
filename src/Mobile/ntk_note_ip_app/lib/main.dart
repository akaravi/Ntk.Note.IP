import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'core/background/background_ip_monitor_service.dart';
import 'core/background/background_monitor_prefs.dart';
import 'core/background/workmanager_callback.dart';
import 'core/config/app_config.dart';
import 'core/push/push_bootstrap.dart';
import 'core/splash/native_splash_binding.dart';
import 'core/widget/ip_home_widget_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    preserveNativeSplash(widgetsBinding);
  }
  await PushBootstrap.init();
  if (!kIsWeb) {
    await Workmanager().initialize(ipnoteWorkmanagerCallback);
    await BackgroundMonitorPrefs.persistApiBaseUrl(AppConfig.current.apiBaseUrl);
    await IpHomeWidgetService.bootstrapNativeConfig();
    if (await BackgroundMonitorPrefs.isEnabled()) {
      await BackgroundIpMonitorService().syncRegistration(enabled: true);
    }
    final cachedIp = await BackgroundMonitorPrefs.readLastPublicIp();
    if (cachedIp != null && cachedIp.trim().isNotEmpty) {
      await IpHomeWidgetService.sync(address: cachedIp.trim());
    }
  }

  runApp(const ProviderScope(child: IpNoteApp()));
}
