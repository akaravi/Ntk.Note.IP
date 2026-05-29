import '../../data/datasources/push_device_remote_datasource.dart';
import 'fcm_token_provider.dart';
import 'push_platform.dart';
import 'push_prefs.dart';

class PushRegistrationService {
  PushRegistrationService(this._remote, this._fcm);

  final PushDeviceRemoteDataSource _remote;
  final FcmTokenProvider _fcm;
  bool _refreshListenerBound = false;

  void bindTokenRefreshListener() {
    if (_refreshListenerBound) {
      return;
    }

    _refreshListenerBound = true;
    _fcm.listenTokenRefresh((token) async {
      final platform = pushPlatformName();
      if (platform == 'unknown' || platform == 'web') {
        return;
      }

      final result = await _remote.register(
        deviceToken: token,
        platform: platform,
      );
      if (result.isSuccess) {
        await PushPrefs.saveLastToken(token);
      }
    });
  }

  Future<void> registerForAuthenticatedUser() async {
    final platform = pushPlatformName();
    if (platform == 'unknown' || platform == 'web') {
      return;
    }

    bindTokenRefreshListener();

    final token = await _fcm.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    final result = await _remote.register(
      deviceToken: token,
      platform: platform,
    );
    if (result.isSuccess) {
      await PushPrefs.saveLastToken(token);
    }
  }

  Future<void> unregisterLastToken() async {
    final token = await PushPrefs.readLastToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await _remote.unregister(deviceToken: token);
    await PushPrefs.clearLastToken();
  }
}
