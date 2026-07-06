import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:flutter_template_appwrite/services/auth_service.dart';
import 'package:flutter_template_appwrite/services/logger_service.dart';
import 'package:flutter_template_appwrite/views/about/about_view.dart';
import 'package:flutter_template_appwrite/views/help/help_view.dart';
import 'package:flutter_template_appwrite/views/home/home_view.dart';
import 'package:flutter_template_appwrite/views/login/login_view.dart';
import 'package:flutter_template_appwrite/views/logs/logs_view.dart';
import 'package:flutter_template_appwrite/views/profile/profile_view.dart';
import 'package:flutter_template_appwrite/views/settings/settings_view.dart';
import 'package:flutter_template_appwrite/views/shell/app_shell.dart';
import 'package:flutter_template_appwrite/views/splash/splash_view.dart';

part 'app_router.g.dart';

/// The route paths used across the app.
///
/// Kept as named constants so views navigate via `AppRoutes.settings`
/// instead of scattering string literals.
class AppRoutes {
  // This class is a namespace for constants; it is never instantiated.
  const AppRoutes._();

  /// Shown while the startup session check is still running.
  static const String splash = '/splash';

  /// The login/register screen (the only unauthenticated page).
  static const String login = '/login';

  /// The home page inside the authenticated shell.
  static const String home = '/';

  /// The settings page inside the authenticated shell.
  static const String settings = '/settings';

  /// The profile page inside the authenticated shell.
  static const String profile = '/profile';

  /// The about page inside the authenticated shell.
  static const String about = '/about';

  /// The help page inside the authenticated shell.
  static const String help = '/help';

  /// The live log view inside the authenticated shell
  /// (visible when developer mode is on, or always in debug builds).
  static const String logs = '/logs';
}

/// Provides the app's [GoRouter].
///
/// Auth guard: the top-level [GoRouter.redirect] reads the current auth
/// state ([currentUserProvider]) on every navigation:
/// - While the startup session check runs, everything shows the splash page.
/// - Without a session, everything redirects to `/login`.
/// - With a session, `/login` and `/splash` redirect to the shell.
///
/// The [GoRouter.refreshListenable] is bumped whenever the auth state
/// changes, so login/logout re-run the redirect immediately — without it,
/// the guard would only run on explicit navigation events.
@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final Talker talker = ref.watch(loggerServiceProvider).talker;

  // Re-evaluate the redirect whenever the auth state changes.
  final ValueNotifier<int> authChangeNotifier = ValueNotifier<int>(0);
  ref.onDispose(authChangeNotifier.dispose);
  ref.listen(
    currentUserProvider,
    (AsyncValue<appwrite_models.User?>? previous,
        AsyncValue<appwrite_models.User?> next) {
      authChangeNotifier.value = authChangeNotifier.value + 1;
    },
  );

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authChangeNotifier,
    debugLogDiagnostics: kDebugMode,
    // Logs top-level route changes (login <-> shell) through Talker.
    observers: <NavigatorObserver>[TalkerRouteObserver(talker)],
    redirect: (BuildContext context, GoRouterState state) {
      final AsyncValue<appwrite_models.User?> authState =
          ref.read(currentUserProvider);

      final bool isCheckingSession = authState.isLoading;
      final bool isLoggedIn = authState.value != null;
      final String location = state.matchedLocation;
      final bool isOnSplashPage = location == AppRoutes.splash;
      final bool isOnLoginPage = location == AppRoutes.login;

      // 1) Startup: park on the splash page until account.get() resolves.
      if (isCheckingSession) {
        if (isOnSplashPage) {
          return null;
        }
        return AppRoutes.splash;
      }

      // 2) Not logged in: everything except the login page goes to /login.
      if (isLoggedIn == false) {
        if (isOnLoginPage) {
          return null;
        }
        return AppRoutes.login;
      }

      // 3) Logged in: keep the user out of login/splash.
      if (isOnLoginPage || isOnSplashPage) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginView();
        },
      ),
      // The authenticated shell: a persistent sidebar with one navigator
      // per tab (indexed stack), so every tab keeps its own state and the
      // browser URL/back button still work correctly.
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          _buildBranch(talker, AppRoutes.home, const HomeView()),
          _buildBranch(talker, AppRoutes.settings, const SettingsView()),
          _buildBranch(talker, AppRoutes.profile, const ProfileView()),
          _buildBranch(talker, AppRoutes.about, const AboutView()),
          _buildBranch(talker, AppRoutes.help, const HelpView()),
          _buildBranch(talker, AppRoutes.logs, const LogsView()),
        ],
      ),
    ],
  );
}

// Builds one shell branch with its own TalkerRouteObserver: branch
// navigators do not report to the root observer, so each branch needs its
// own observer for tab navigation to show up in the logs.
StatefulShellBranch _buildBranch(Talker talker, String path, Widget view) {
  return StatefulShellBranch(
    observers: <NavigatorObserver>[TalkerRouteObserver(talker)],
    routes: <RouteBase>[
      GoRoute(
        path: path,
        builder: (BuildContext context, GoRouterState state) {
          return view;
        },
      ),
    ],
  );
}
