import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_apb_flutter/app/router/route_paths.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_state.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/change_password_screen.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/landing_screen.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/otp_screen.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/register_screen.dart';
import 'package:tubes_apb_flutter/features/auth/presentation/screens/success_change_password_screen.dart';
import 'package:tubes_apb_flutter/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:tubes_apb_flutter/features/dashboard/presentation/screens/dashboard_shell_screen.dart';
import 'package:tubes_apb_flutter/features/settings/presentation/screens/personal_info_screen.dart';
import 'package:tubes_apb_flutter/features/settings/presentation/screens/security_screen.dart';
import 'package:tubes_apb_flutter/features/settings/presentation/screens/settings_screen.dart';
import 'package:tubes_apb_flutter/shared/widgets/coming_soon_screen.dart';

final _publicPaths = <String>{
  RoutePaths.landing,
  RoutePaths.register,
  RoutePaths.login,
  RoutePaths.forgotPassword,
  RoutePaths.otp,
  RoutePaths.changePassword,
  RoutePaths.changePasswordSuccess,
};

final _guestOnlyPaths = <String>{
  RoutePaths.landing,
  RoutePaths.register,
  RoutePaths.login,
};

final routerRefreshListenableProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);

  ref.listen<AuthSessionState>(authSessionControllerProvider, (previous, next) {
    notifier.value = notifier.value + 1;
  });

  ref.onDispose(notifier.dispose);

  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(routerRefreshListenableProvider);

  return GoRouter(
    initialLocation: RoutePaths.landing,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final authState = ref.read(authSessionControllerProvider);
      final location = state.uri.path;

      if (authState.isChecking) {
        return null;
      }

      final isPublic = _publicPaths.contains(location);
      if (!authState.isAuthenticated && !isPublic) {
        return RoutePaths.login;
      }

      if (authState.isAuthenticated && _guestOnlyPaths.contains(location)) {
        return RoutePaths.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.otp,
        redirect: (context, state) {
          final email = state.uri.queryParameters['email']?.trim();
          final expiresInMinutes = int.tryParse(
            state.uri.queryParameters['expires'] ?? '30',
          );

          if (email == null || email.isEmpty) {
            return RoutePaths.forgotPassword;
          }

          if (expiresInMinutes == null || expiresInMinutes <= 0) {
            return RoutePaths.forgotPassword;
          }

          return null;
        },
        builder: (context, state) {
          final email = state.uri.queryParameters['email']!;
          final expiresInMinutes =
              int.tryParse(state.uri.queryParameters['expires'] ?? '30') ?? 30;

          return OtpScreen(email: email, expiresInMinutes: expiresInMinutes);
        },
      ),
      GoRoute(
        path: RoutePaths.changePassword,
        redirect: (context, state) {
          final email = state.uri.queryParameters['email']?.trim();
          final otp = state.uri.queryParameters['otp']?.trim();

          if (email == null || email.isEmpty || otp == null || otp.isEmpty) {
            return RoutePaths.forgotPassword;
          }

          return null;
        },
        builder: (context, state) {
          final email = state.uri.queryParameters['email']!;
          final otp = state.uri.queryParameters['otp']!;

          return ChangePasswordScreen(email: email, otp: otp);
        },
      ),
      GoRoute(
        path: RoutePaths.changePasswordSuccess,
        builder: (context, state) => const SuccessChangePasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.budget,
                builder: (context, state) => const ComingSoonScreen(
                  title: 'Budget',
                  description: 'Budget planning is coming soon in V1.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.saving,
                builder: (context, state) => const ComingSoonScreen(
                  title: 'Saving',
                  description: 'Saving planner is coming soon in V1.',
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'personal-info',
                    builder: (context, state) => const PersonalInfoScreen(),
                  ),
                  GoRoute(
                    path: 'security',
                    builder: (context, state) => const SecurityScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.transactions,
        builder: (context, state) => const ComingSoonScreen(
          title: 'Transactions',
          description:
              'Transaction history will be available in the next sprint.',
        ),
      ),
    ],
  );
});
