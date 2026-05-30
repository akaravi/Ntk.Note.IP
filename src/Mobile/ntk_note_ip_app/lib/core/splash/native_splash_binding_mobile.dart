import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void preserveNativeSplash(WidgetsBinding binding) {
  FlutterNativeSplash.preserve(widgetsBinding: binding);
}

void removeNativeSplash() {
  FlutterNativeSplash.remove();
}
