import 'package:workmanager/workmanager.dart';

import 'background_ip_monitor_service.dart';
import 'ip_change_background_runner.dart';

@pragma('vm:entry-point')
void ipnoteWorkmanagerCallback() {
  Workmanager().executeTask((task, inputData) async {
    if (task == BackgroundIpMonitorService.uniqueName ||
        task == BackgroundIpMonitorService.taskTag) {
      await IpChangeBackgroundRunner.run();
    }

    return Future.value(true);
  });
}
