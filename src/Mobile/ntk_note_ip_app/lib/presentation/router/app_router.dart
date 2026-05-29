import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_controller.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/ip_notes/ip_notes_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/tools/tools_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      final needsAuth =
          state.matchedLocation == '/dashboard' ||
          state.matchedLocation == '/ip-notes';

      if (auth.loading) {
        return null;
      }

      if (needsAuth && !auth.isAuthenticated) {
        return '/login?from=${Uri.encodeComponent(state.uri.toString())}';
      }

      if (loggingIn && auth.isAuthenticated) {
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty && from != '/login') {
          return from;
        }

        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/ip-lookup',
        redirect: (context, state) {
          final address = state.uri.queryParameters['address'];
          if (address != null && address.trim().isNotEmpty) {
            return '/?address=${Uri.encodeQueryComponent(address.trim())}';
          }

          return '/';
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(
          initialAddress: state.uri.queryParameters['address'],
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/ip-notes',
        builder: (context, state) => IpNotesScreen(
          initialAddress: state.uri.queryParameters['address'],
          captureSnapshot: state.uri.queryParameters['capture'] == '1',
        ),
      ),
      GoRoute(
        path: '/tools',
        builder: (context, state) => const ToolsScreen(),
      ),
    ],
  );
});
