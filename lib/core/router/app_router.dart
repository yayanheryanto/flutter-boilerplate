import 'dart:convert';

import 'package:emas/core/constants/routes.dart';
import 'package:emas/features/auth/presentation/pages/face_detection_page.dart';
import 'package:emas/core/utils/account_type.dart';
import 'package:emas/features/auth/presentation/pages/account_processed_page.dart';
import 'package:emas/features/auth/presentation/pages/address_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/bank_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/camera_pick_page.dart';
import 'package:emas/features/auth/presentation/pages/change_password_page.dart';
import 'package:emas/features/auth/presentation/pages/confirmation_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/face_verification_guide_page.dart';
import 'package:emas/features/auth/presentation/pages/face_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/ktp_guide_page.dart';
import 'package:emas/features/auth/presentation/pages/ktp_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/npwp_verification_page.dart';
import 'package:emas/features/auth/presentation/pages/verification_preparation_page.dart';
import 'package:emas/features/dashboard/presentation/pages/buy_npl_confirmation_page.dart';
import 'package:emas/features/dashboard/presentation/pages/buy_npl_detail_page.dart';
import 'package:emas/features/dashboard/presentation/pages/buy_npl_page.dart';
import 'package:emas/features/dashboard/presentation/pages/join_auction_page.dart';
import 'package:emas/features/dashboard/presentation/pages/auction_detail_page.dart';
import 'package:emas/features/dashboard/presentation/pages/auction_list_page.dart';
import 'package:emas/features/dashboard/presentation/pages/live_auction_page.dart';
import 'package:emas/features/dashboard/presentation/pages/payment_guide_page.dart';
import 'package:emas/features/dashboard/presentation/pages/payment_page.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:emas/features/auth/presentation/pages/login_page.dart';
import 'package:emas/features/auth/presentation/pages/otp_page.dart';
import 'package:emas/features/auth/presentation/pages/register_page.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/presentation/pages/category_page.dart';
import 'package:emas/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/features/auth/presentation/pages/forgot_password_page.dart';

@singleton
class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      // Shares the same navigatorKey used by AppToast, AppPopover, etc.
      navigatorKey: AppNavigator.navigatorKey,
      initialLocation: Routes.login,
      debugLogDiagnostics: true,
      extraCodec: const _AppExtraCodec(),
      routes: [
        // ── Auth ─────────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.login,
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),

        GoRoute(
          path: Routes.forgotPassword,
          name: 'forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),

        GoRoute(
          path: Routes.otp,
          name: 'otp',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            final phone = extra['phone'] as String? ?? '';
            return OtpPage(phone: phone);
          },
        ),

        GoRoute(
          path: Routes.verificationPreparation,
          name: 'verification-preparation',
          builder: (context, state) => const VerificationPreparationPage(),
        ),

        GoRoute(
          path: Routes.ktpGuide,
          name: 'ktp-guide',
          builder: (context, state) {
            final accountType = state.extra as AccountType? ?? AccountType.personal;
            return KtpGuidePage(
              accountType: accountType,
            );
          },
        ),

        GoRoute(
          path: Routes.ktpVerification,
          name: 'ktp-verification',
          builder: (context, state) {
            final accountType = state.extra as AccountType? ?? AccountType.personal;
            return KtpVerificationPage(
              accountType: accountType,
            );
          },
        ),

        GoRoute(
          path: Routes.npwpVerification,
          name: 'npwp-verification',
          builder: (context, state) {
            final accountType = state.extra as AccountType? ?? AccountType.personal;
            return NPWPVerificationPage(
              accountType: accountType,
            );
          },
        ),

        GoRoute(
          path: Routes.faceGuide,
          name: 'face-guide',
          builder: (context, state) {
            final accountType = state.extra as AccountType? ?? AccountType.personal;
            return FaceVerificationGuidePage(
              accountType: accountType,
            );
          },
        ),

        GoRoute(
          path: Routes.faceVerification,
          name: 'face-verification',
          builder: (context, state) {
            final accountType = state.extra as AccountType? ?? AccountType.personal;
            return FaceVerificationPage(
              accountType: accountType,
            );
          },
        ),

        GoRoute(
          path: Routes.confirmationVerification,
          name: 'confirmation-verification',
          builder: (context, state) => const ConfirmationVerificationPage(),
        ),

        GoRoute(
          path: Routes.changePassword,
          name: 'change-password',
          builder: (context, state) => const ChangePasswordPage(),
        ),

        GoRoute(
          path: Routes.cameraPick,
          name: 'camera-pick',
          builder: (context, state) => const CameraPickPage(),
        ),

        GoRoute(
          path: Routes.facePick,
          name: 'face-pick',
          builder: (context, state) => const FaceDetectionPage(),
        ),

        GoRoute(
          path: Routes.addressVerification,
          name: 'address-verification',
          builder: (context, state) => const AddressVerificationPage(),
        ),

        GoRoute(
          path: Routes.bankVerification,
          name: 'bank-verification',
          builder: (context, state) => const BankVerificationPage(),
        ),

        GoRoute(
          path: Routes.accountProcessed,
          name: 'account-processed',
          builder: (context, state) => const AccountProcessedPage(),
        ),

        // ── App ──────────────────────────────────────────────────────────────
        GoRoute(
          path: Routes.dashboard,
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
          path: Routes.joinAuction,
          name: 'join-auction',
          builder: (context, state) => const JoinAuctionPage(),
        ),

        GoRoute(
          path: Routes.auctionList,
          name: 'auction-list',
          builder: (context, state) => const AuctionListPage(),
        ),
        GoRoute(
          path: Routes.auctionDetail,
          name: 'auction-detail',
          builder: (context, state) => const AuctionDetailPage(),
        ),
        GoRoute(
          path: Routes.liveAuction,
          name: 'live-auction',
          builder: (context, state) => const LiveAuctionPage(),
        ),
        GoRoute(
          path: Routes.buyNplDetail,
          name: 'buy-npl-detail',
          builder: (context, state) => const BuyNplDetailPage(),
        ),
        GoRoute(
          path: Routes.buyNplConfirmation,
          name: 'buy-npl-confirmation',
          builder: (context, state) => const BuyNplConfirmationPage(),
        ),
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (context, state) => const _PlaceholderPage(title: 'Profile'),
        ),
        GoRoute(
          path: Routes.settings,
          name: 'settings',
          builder: (context, state) => const _PlaceholderPage(title: 'Settings'),
        ),
        GoRoute(
          path: Routes.register,
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),

        GoRoute(
          path: Routes.payment,
          name: 'payment',
          builder: (context, state) => const PaymentPage(),
        ),

        GoRoute(
          path: Routes.paymentGuide,
          name: 'payment-guide',
          builder: (context, state) => const PaymentGuidePage(),
        ),

        GoRoute(
          path: Routes.buyNpl,
          name: 'buy-npl',
          builder: (context, state) => const BuyNplPage(),
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

// ── Extra codec — handles complex types passed via context.go/push ─────────────
//
// Cara menambah tipe baru:
// 1. Pastikan class punya toJson() dan fromJson() / factory constructor
// 2. Tambah case di _AppExtraEncoder.convert()  → {'__type': 'NamaClass', ...data}
// 3. Tambah case di _AppExtraDecoder.convert()  → NamaClass.fromJson(input)
//
// Contoh penggunaan:
//   context.go(AppRoutes.someRoute, extra: MyObject(...))
//   final obj = state.extra as MyObject;

class _AppExtraCodec extends Codec<Object?, Object?> {
  const _AppExtraCodec();

  @override
  Converter<Object?, Object?> get encoder => const _AppExtraEncoder();

  @override
  Converter<Object?, Object?> get decoder => const _AppExtraDecoder();
}

class _AppExtraEncoder extends Converter<Object?, Object?> {
  const _AppExtraEncoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;

    // ── Enums ────────────────────────────────────────────────────────────────
    if (input is AccountType) {
      return {'__type': 'AccountType', 'value': input.name};
    }

    // ── Objects with toJson ──────────────────────────────────────────────────
    // Tambah case baru di sini mengikuti pola yang sama:
    //
    // if (input is UserModel) {
    //   return {'__type': 'UserModel', ...input.toJson()};
    // }
    //
    // if (input is AuctionItem) {
    //   return {'__type': 'AuctionItem', ...input.toJson()};
    // }

    // ── Primitives & Map (pass-through) ──────────────────────────────────────
    if (input is Map<String, dynamic>) return input;
    if (input is String || input is int || input is double || input is bool) {
      return input;
    }

    // Fallback — tidak diketahui, biarkan GoRouter handle
    return input;
  }
}

class _AppExtraDecoder extends Converter<Object?, Object?> {
  const _AppExtraDecoder();

  @override
  Object? convert(Object? input) {
    if (input == null) return null;

    if (input is Map<String, dynamic>) {
      final type = input['__type'];

      // ── Enums ──────────────────────────────────────────────────────────────
      if (type == 'AccountType') {
        return AccountType.values.byName(input['value'] as String);
      }

      // ── Objects ────────────────────────────────────────────────────────────
      // Tambah case baru di sini:
      //
      // if (type == 'UserModel') {
      //   return UserModel.fromJson(input);
      // }
      //
      // if (type == 'AuctionItem') {
      //   return AuctionItem.fromJson(input);
      // }

      // Map biasa (tidak punya __type), kembalikan apa adanya
      return input;
    }

    return input;
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
