import 'package:firebase_core/firebase_core.dart';

/// Initializes Firebase when platform config files are present.
class PushBootstrap {
  static bool _ready = false;

  static bool get firebaseReady => _ready;

  static Future<void> init() async {
    if (_ready) {
      return;
    }

    try {
      await Firebase.initializeApp();
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }
}
