import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_tokens.dart';

abstract class AuthTokenStorePort {
  Future<AuthTokens?> read();

  Future<void> write(AuthTokens tokens, {required bool persist});

  Future<bool> isPersistentSession();

  Future<void> clear();
}

class AuthTokenStore implements AuthTokenStorePort {
  static const _accessKey = 'auth.access_token';
  static const _refreshKey = 'auth.refresh_token';
  static const _expiresAtKey = 'auth.expires_at';
  static const _persistKey = 'auth.persist_session';

  static const _legacyAccessKey = 'auth.access_token';
  static const _legacyRefreshKey = 'auth.refresh_token';

  AuthTokenStore({FlutterSecureStorage? secureStorage})
      : _secure = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _secure;
  AuthTokens? _sessionTokens;

  bool get _useWebPrefs => kIsWeb;

  @override
  Future<bool> isPersistentSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_persistKey) ?? false;
  }

  @override
  Future<AuthTokens?> read() async {
    if (_sessionTokens != null) {
      return _sessionTokens;
    }

    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_persistKey) ?? false)) {
      return null;
    }

    if (_useWebPrefs) {
      return _readPersistedFromPrefs(prefs);
    }

    final access = await _secure.read(key: _accessKey);
    final refresh = await _secure.read(key: _refreshKey);
    if (access != null && access.isNotEmpty) {
      return AuthTokens(
        accessToken: access,
        refreshToken: refresh ?? '',
        expiresAt: _readExpiresAt(prefs),
      );
    }

    return _migrateFromSharedPreferences();
  }

  AuthTokens? _readPersistedFromPrefs(SharedPreferences prefs) {
    final access = prefs.getString(_accessKey);
    if (access == null || access.isEmpty) {
      return null;
    }

    return AuthTokens(
      accessToken: access,
      refreshToken: prefs.getString(_refreshKey) ?? '',
      expiresAt: _readExpiresAt(prefs),
    );
  }

  DateTime? _readExpiresAt(SharedPreferences prefs) {
    final raw = prefs.getString(_expiresAtKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    return DateTime.tryParse(raw);
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
    await write(tokens, persist: true);
    await prefs.remove(_legacyAccessKey);
    await prefs.remove(_legacyRefreshKey);
    return tokens;
  }

  @override
  Future<void> write(AuthTokens tokens, {required bool persist}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_persistKey, persist);

    if (persist) {
      _sessionTokens = null;
      if (_useWebPrefs) {
        await prefs.setString(_accessKey, tokens.accessToken);
        await prefs.setString(_refreshKey, tokens.refreshToken);
      } else {
        await _secure.write(key: _accessKey, value: tokens.accessToken);
        await _secure.write(key: _refreshKey, value: tokens.refreshToken);
      }

      if (tokens.expiresAt != null) {
        await prefs.setString(
          _expiresAtKey,
          tokens.expiresAt!.toUtc().toIso8601String(),
        );
      } else {
        await prefs.remove(_expiresAtKey);
      }
      return;
    }

    _sessionTokens = tokens;
    if (_useWebPrefs) {
      await prefs.remove(_accessKey);
      await prefs.remove(_refreshKey);
    } else {
      await _secure.delete(key: _accessKey);
      await _secure.delete(key: _refreshKey);
    }
    await prefs.remove(_expiresAtKey);
  }

  @override
  Future<void> clear() async {
    _sessionTokens = null;
    if (!_useWebPrefs) {
      await _secure.delete(key: _accessKey);
      await _secure.delete(key: _refreshKey);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_persistKey);
    await prefs.remove(_expiresAtKey);
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_legacyAccessKey);
    await prefs.remove(_legacyRefreshKey);
  }
}
