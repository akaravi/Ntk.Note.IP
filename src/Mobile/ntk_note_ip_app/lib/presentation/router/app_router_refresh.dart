import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admin_access_provider.dart';
import '../providers/auth_controller.dart';

/// Notifies [GoRouter] when auth/admin state changes without recreating the router.
final appRouterRefreshProvider = Provider<AppRouterRefresh>((ref) {
  final refresh = AppRouterRefresh(ref);
  ref.onDispose(refresh.dispose);
  return refresh;
});

class AppRouterRefresh extends ChangeNotifier {
  AppRouterRefresh(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) => notifyListeners());
    ref.listen(adminAccessProvider, (previous, next) => notifyListeners());
  }
}
