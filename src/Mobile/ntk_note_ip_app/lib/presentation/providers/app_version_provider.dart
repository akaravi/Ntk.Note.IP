import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appVersionProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});

final splashMinimumDurationProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 1400),
);

/// Max wait for settings + auth before leaving splash (web secure-storage hangs).
final authBootstrapTimeoutProvider = Provider<Duration>(
  (ref) => const Duration(seconds: 8),
);
