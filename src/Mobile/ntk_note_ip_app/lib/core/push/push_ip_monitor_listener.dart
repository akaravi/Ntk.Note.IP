import 'package:firebase_messaging/firebase_messaging.dart';

import 'push_bootstrap.dart';

/// Handles server-initiated FCM data messages that request a client IP report.
class PushIpMonitorListener {
  PushIpMonitorListener(this._onMonitorIpRequested);

  final Future<void> Function() _onMonitorIpRequested;
  bool _bound = false;

  static const monitorIpType = 'monitor_ip';

  void bind() {
    if (_bound || !PushBootstrap.firebaseReady) {
      return;
    }

    _bound = true;
    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final type = message.data['type'];
    if (type != monitorIpType) {
      return;
    }

    await _onMonitorIpRequested();
  }
}
