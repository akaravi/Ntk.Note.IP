import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LocalIpService {
  Future<String?> discoverLocalIpv4() async {
    if (kIsWeb) {
      return null;
    }

    try {
      final info = NetworkInfo();
      final wifiIp = await info.getWifiIP();
      if (wifiIp != null && wifiIp.isNotEmpty && wifiIp != '0.0.0.0') {
        return wifiIp;
      }

      return await info.getWifiIPv6();
    } catch (_) {
      return null;
    }
  }
}
