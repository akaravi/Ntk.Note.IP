import 'package:firebase_messaging/firebase_messaging.dart';

import 'push_bootstrap.dart';

class FcmTokenProvider {
  Future<String?> getToken() async {
    if (!PushBootstrap.firebaseReady) {
      return null;
    }

    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      return await messaging.getToken();
    } catch (_) {
      return null;
    }
  }

  void listenTokenRefresh(void Function(String token) onToken) {
    if (!PushBootstrap.firebaseReady) {
      return;
    }

    FirebaseMessaging.instance.onTokenRefresh.listen(onToken);
  }
}
