import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/admin_access_provider.dart';
import '../providers/auth_controller.dart';
import '../screens/about/about_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/contact/contact_screen.dart';
import '../screens/copyright/copyright_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/intro/intro_screen.dart';
import '../screens/ip_notes/ip_notes_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';
import '../screens/tools/domain_tool_screen.dart';
import '../screens/tools/network_tool_screen.dart';
import '../screens/tools/tools_hub.dart';
import '../screens/tools/tools_screen.dart';
import 'app_router_refresh.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(appRouterRefreshProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final adminAccess = ref.read(adminAccessProvider);
      final onAuthScreen =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final needsAuth =
          state.matchedLocation == '/dashboard' ||
          state.matchedLocation == '/ip-notes' ||
          state.matchedLocation.startsWith('/admin');

      if (auth.loading) {
        return null;
      }

      if (needsAuth && !auth.isAuthenticated) {
        return '/login?from=${Uri.encodeComponent(state.uri.toString())}';
      }

      if (state.matchedLocation.startsWith('/admin')) {
        if (adminAccess.isLoading) {
          return null;
        }

        if (adminAccess.valueOrNull?.isAdministrator != true) {
          return '/dashboard';
        }
      }

      if (onAuthScreen && auth.isAuthenticated) {
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
        path: '/home',
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
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
        routes: [
          GoRoute(
            path: 'network',
            builder: (context, state) {
              final focus = NetworkToolFocus.fromQuery(
                    state.uri.queryParameters['focus'],
                  ) ??
                  NetworkToolFocus.whoisIp;

              if (focus.isDomainTool) {
                return DomainToolScreen(
                  initialDomain: state.uri.queryParameters['domain'],
                  initialTab: focus.domainTab,
                );
              }

              return NetworkToolScreen(
                focus: focus,
                initialAddress: state.uri.queryParameters['address'],
                initialDomain: state.uri.queryParameters['domain'],
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/copyright',
        builder: (context, state) => const CopyrightScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScreen(),
      ),
    ],
  );
});
