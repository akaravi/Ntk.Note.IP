import 'package:workmanager/workmanager.dart';

import 'background_monitor_prefs.dart';

class BackgroundIpMonitorService {
  static const uniqueName = 'ipnoteIpChangeMonitor';
  static const taskTag = 'ipChangeMonitor';

  Future<void> syncRegistration({required bool enabled}) async {
    await BackgroundMonitorPrefs.setEnabled(enabled);
    if (enabled) {
      await Workmanager().registerPeriodicTask(
        uniqueName,
        taskTag,
        frequency: const Duration(minutes: 30),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
    } else {
      await Workmanager().cancelByUniqueName(uniqueName);
    }
  }
}
