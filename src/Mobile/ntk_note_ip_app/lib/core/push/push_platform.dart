import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

String pushPlatformName() {
  if (kIsWeb) {
    return 'web';
  }

  if (Platform.isAndroid) {
    return 'android';
  }

  if (Platform.isIOS) {
    return 'ios';
  }

  return 'unknown';
}
