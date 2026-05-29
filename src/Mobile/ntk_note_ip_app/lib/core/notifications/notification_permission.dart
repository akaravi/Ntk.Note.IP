import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Requests notification permission on Android 13+ (no-op when already granted).
Future<bool> requestNotificationPermissionIfNeeded() async {
  if (kIsWeb) {
    return true;
  }

  final android = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (android == null) {
    return true;
  }

  final granted = await android.requestNotificationsPermission();
  return granted ?? true;
}
