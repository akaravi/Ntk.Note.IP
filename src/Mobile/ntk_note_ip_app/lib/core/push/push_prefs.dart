import 'package:shared_preferences/shared_preferences.dart';

class PushPrefs {
  static const _lastTokenKey = 'push.last_device_token';

  static Future<String?> readLastToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastTokenKey);
  }

  static Future<void> saveLastToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastTokenKey, token);
  }

  static Future<void> clearLastToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastTokenKey);
  }
}
