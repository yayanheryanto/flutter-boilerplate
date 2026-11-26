import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/auth/presentation/pages/change_password_page.dart';
import 'package:emas/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:emas/features/auth/presentation/pages/login_page.dart';
import 'package:emas/features/auth/presentation/pages/otp_page.dart';
import 'package:emas/features/auth/presentation/pages/register_page.dart';
import 'package:emas/features/auth/presentation/pages/verify_old_password_page.dart';

/// Route fitur auth. Digabungkan oleh `AppRouter` di `lib/app/router/`.
final List<RouteBase> authRoutes = [
  GoRoute(
    path: AppRoutes.login,
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.register,
    name: 'register',
    builder: (context, state) => const RegisterPage(),
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
    path: AppRoutes.changePassword,
    name: 'change-password',
    builder: (context, state) => const ChangePasswordPage(),
  ),
  GoRoute(
    path: AppRoutes.inputOldPassword,
    name: 'input-old-password',
    builder: (context, state) => const VerifyOldPasswordPage(),
  ),
];
