import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/providers/auth_provider.dart';
import '../features/auth/pages/login_page.dart';
import '../features/main/pages/main_shell.dart';
import '../features/home/pages/home_page.dart';
import '../features/clock/pages/clock_page.dart';
import '../features/clock/pages/liveness_page.dart';
import '../features/history/pages/history_page.dart';
import '../features/profile/pages/profile_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String home = '/';
  static const String clock = '/clock';
  static const String liveness = '/liveness';
  static const String history = '/history';
  static const String profile = '/profile';

  static GoRouter createRouter(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return GoRouter(
      initialLocation: login,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoginRoute = state.matchedLocation == login;

        // If not authenticated and not on login page, redirect to login
        if (!isAuthenticated && !isLoginRoute) {
          return login;
        }

        // If authenticated and on login page, redirect to home
        if (isAuthenticated && isLoginRoute) {
          return home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: login,
          builder: (context, state) => const LoginPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: home,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomePage(),
              ),
            ),
            GoRoute(
              path: clock,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ClockPage(),
              ),
            ),
            GoRoute(
              path: history,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HistoryPage(),
              ),
            ),
            GoRoute(
              path: profile,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfilePage(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: liveness,
          builder: (context, state) => const LivenessPage(),
        ),
      ],
    );
  }
}
