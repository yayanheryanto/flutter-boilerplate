import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/core/ui/design_system/design_system.dart';
import 'package:boilerplate/core/utils/navigator_key.dart';
import 'package:boilerplate/features/auth/presentation/pages/auth_page.dart';
import 'package:boilerplate/features/auth/presentation/pages/register_page.dart';
import 'package:boilerplate/features/demo/ui_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      // Shares the same navigatorKey used by AppToast, AppPopover, etc.
      navigatorKey: AppNavigator.navigatorKey,
      initialLocation: AppRoutes.login,
      debugLogDiagnostics: true,
      routes: [
        // ── Dev only: remove for production ──────────────────────────────────
        GoRoute(path: AppRoutes.uiDemo, builder: (_, __) => const UiDemoPage()),

        // ── Auth ─────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const AuthPage(),
        ),

        // ── App ──────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const _PlaceholderPage(title: 'Dashboard'),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const _PlaceholderPage(title: 'Profile'),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const _PlaceholderPage(title: 'Settings'),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),
      ],

      errorBuilder: (context, state) => _ErrorPage(error: state.error),

      redirect: (context, state) {
        // TODO: implement auth guard using AuthBloc/TokenService
        // Example:
        //   final isLoggedIn = getIt<TokenService>().hasToken();
        //   if (!isLoggedIn && state.matchedLocation != AppRoutes.login) {
        //     return AppRoutes.login;
        //   }
        return null;
      },
    );
  }
}

// ── Placeholder pages (replace with real pages) ───────────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class _ErrorPage extends StatelessWidget {
  final Exception? error;
  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Text(error?.toString() ?? '404 — Page not found'),
      ),
    );
  }
}
