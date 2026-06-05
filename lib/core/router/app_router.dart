import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/auth/presentation/pages/account_processed_page.dart';
import 'package:emas/features/auth/presentation/pages/address_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/bank_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/change_password_page.dart';
import 'package:emas/features/auth/presentation/pages/ktp_guide_page.dart';
import 'package:emas/features/auth/presentation/pages/ktp_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/verification_preparation_page.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:emas/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:emas/features/auth/presentation/pages/login_page.dart';
import 'package:emas/features/auth/presentation/pages/otp_page.dart';
import 'package:emas/features/auth/presentation/pages/register_page.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/features/dashboard/presentation/pages/category_page.dart';
import 'package:emas/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:emas/features/demo/ui_demo_page.dart';
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
          builder: (context, state) => const LoginPage(),
        ),

        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),

        GoRoute(
          path: AppRoutes.otp,
          name: 'otp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final phone = extra['phone'] as String? ?? '';
            return OtpPage(phone: phone);
          },
        ),

        GoRoute(
          path: AppRoutes.verificationPreparation,
          name: 'verification-preparation',
          builder: (context, state) => const VerificationPreparationPage(),
        ),

        GoRoute(
          path: AppRoutes.ktpGuide,
          name: 'ktp-guide',
          builder: (context, state) => const KtpGuidePage(),
        ),

        GoRoute(
          path: AppRoutes.changePassword,
          name: 'change-password',
          builder: (context, state) => const ChangePasswordPage(),
        ),

        GoRoute(
          path: AppRoutes.ktpVerification,
          name: 'ktp-verification',
          builder: (context, state) => const KtpVerificationPage(),
        ),

        GoRoute(
          path: AppRoutes.addressVerification,
          name: 'address-verification',
          builder: (context, state) => const AddressVerificationPage(),
        ),

        GoRoute(
          path: AppRoutes.bankVerification,
          name: 'bank-verification',
          builder: (context, state) => const BankVerificationPage(),
        ),

        GoRoute(
          path: AppRoutes.accountProcessed,
          name: 'account-processed',
          builder: (context, state) => const AccountProcessedPage(),
        ),

        // ── App ──────────────────────────────────────────────────────────────
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardPage(),
          routes: [
            // /dashboard/category/:slug
            GoRoute(
              path: 'category/:slug',
              name: 'category-detail',
              builder: (_, state) {
                final slug = state.pathParameters['slug'] ?? '';
                final category = AuctionCategory.fromSlug(slug);
                return CategoryPage(category: category);
              },
            ),
          ],
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
