import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../config/app_config.dart';
import '../history/database/app_database.dart';
import '../history/ip_history_store.dart';
import '../network/api_client.dart';
import 'background_monitor_prefs.dart';
import 'ip_change_detector.dart';

/// Runs outside the UI isolate (Workmanager callback).
class IpChangeBackgroundRunner {
  static const _notificationChannelId = 'ipnote_ip_change';
  static const _notificationId = 41001;

  static Future<void> run({
    String notificationTitle = 'IPNote.ir',
    String notificationBodyPrefix = 'Public IP changed to',
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (!await BackgroundMonitorPrefs.isEnabled()) {
      return;
    }

    final baseUrl =
        await BackgroundMonitorPrefs.readApiBaseUrl() ?? AppConfig.current.apiBaseUrl;
    final client = ApiClient(
      dio: Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          headers: const {'Accept': 'application/json'},
        ),
      ),
    );

    final result = await client.getData<Map<String, dynamic>>(
      '/api/v1/IpLookup/GetMyIp',
      parse: (json) => (json as Map).cast<String, dynamic>(),
    );

    if (!result.isSuccess || result.data == null) {
      return;
    }

    final address = result.data!['address']?.toString() ?? '';
    if (address.isEmpty) {
      return;
    }

    final isIPv6 = result.data!['isIPv6'] == true;
    final scope = result.data!['scope']?.toString();
    final previous = await BackgroundMonitorPrefs.readLastPublicIp();
    final changed = detectPublicIpChange(
      previousAddress: previous,
      currentAddress: address,
    );

    final db = AppDatabase();
    try {
      final store = IpHistoryStore(db, skipLegacyMigration: true);
      await store.add(
        address: address,
        isIPv6: isIPv6,
        scope: scope,
        deviceLabel: 'background',
      );
    } finally {
      await db.close();
    }

    await BackgroundMonitorPrefs.writeLastPublicIp(address);

    if (changed != null) {
      await _showNotification(
        title: notificationTitle,
        body: '$notificationBodyPrefix $changed',
      );
    }
  }

  static Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    final plugin = FlutterLocalNotificationsPlugin();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await plugin.initialize(const InitializationSettings(android: androidInit));

    const channel = AndroidNotificationChannel(
      _notificationChannelId,
      'IP changes',
      description: 'Alerts when your public IP address changes',
    );

    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);

    await plugin.show(
      _notificationId,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _notificationChannelId,
          'IP changes',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
      ),
    );
  }
}
