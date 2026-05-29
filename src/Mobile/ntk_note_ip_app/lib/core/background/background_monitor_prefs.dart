import 'package:shared_preferences/shared_preferences.dart';

/// Keys shared between UI isolate and Workmanager background isolate.
class BackgroundMonitorPrefs {
  static const enabledKey = 'settings.background_ip_monitor';
  static const lastPublicIpKey = 'background.last_public_ip';
  static const apiBaseUrlKey = 'background.api_base_url';

  static Future<void> persistApiBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(apiBaseUrlKey, url.trim());
  }

  static Future<String?> readApiBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(apiBaseUrlKey);
  }

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(enabledKey) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(enabledKey, value);
  }

  static Future<String?> readLastPublicIp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastPublicIpKey);
  }

  static Future<void> writeLastPublicIp(String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(lastPublicIpKey, address);
  }
}
