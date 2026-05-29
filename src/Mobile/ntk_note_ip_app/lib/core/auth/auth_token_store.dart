import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_tokens.dart';

abstract class AuthTokenStorePort {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens);

  Future<void> clear();
}

class AuthTokenStore implements AuthTokenStorePort {
  static const _accessKey = 'auth.access_token';
  static const _refreshKey = 'auth.refresh_token';

  static const _legacyAccessKey = 'auth.access_token';
  static const _legacyRefreshKey = 'auth.refresh_token';

  AuthTokenStore({FlutterSecureStorage? secureStorage})
      : _secure = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _secure;

  @override
  Future<AuthTokens?> read() async {
    final access = await _secure.read(key: _accessKey);
    final refresh = await _secure.read(key: _refreshKey);
    if (access != null && access.isNotEmpty) {
      return AuthTokens(
        accessToken: access,
        refreshToken: refresh ?? '',
      );
    }

    return _migrateFromSharedPreferences();
  }

  Future<AuthTokens?> _migrateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final legacyAccess = prefs.getString(_legacyAccessKey);
    if (legacyAccess == null || legacyAccess.isEmpty) {
      return null;
    }

    final tokens = AuthTokens(
      accessToken: legacyAccess,
      refreshToken: prefs.getString(_legacyRefreshKey) ?? '',
    );
    await write(tokens);
    await prefs.remove(_legacyAccessKey);
    await prefs.remove(_legacyRefreshKey);
    return tokens;
  }

  @override
  Future<void> write(AuthTokens tokens) async {
    await _secure.write(key: _accessKey, value: tokens.accessToken);
    await _secure.write(key: _refreshKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    await _secure.delete(key: _accessKey);
    await _secure.delete(key: _refreshKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_legacyAccessKey);
    await prefs.remove(_legacyRefreshKey);
  }
}
