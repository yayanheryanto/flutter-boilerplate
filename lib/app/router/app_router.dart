import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:emas/features/auction/presentation/routes/auction_routes.dart';
import 'package:emas/features/auth/presentation/routes/auth_routes.dart';
import 'package:emas/features/dashboard/presentation/routes/dashboard_routes.dart';
import 'package:emas/features/kyc/domain/entities/account_type.dart';
import 'package:emas/features/kyc/presentation/routes/kyc_routes.dart';
import 'package:emas/features/live_auction/presentation/routes/live_auction_routes.dart';
import 'package:emas/features/npl/presentation/routes/npl_routes.dart';
import 'package:emas/features/payment/presentation/routes/payment_routes.dart';
import 'package:emas/features/profile/presentation/routes/profile_routes.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';

/// Router aplikasi. Setiap fitur mendefinisikan route-nya sendiri di
/// `features/<fitur>/presentation/routes/`; kelas ini hanya menggabungkan.
///
/// Menambah fitur baru: buat `<fitur>_routes.dart`, lalu tambahkan ke
/// daftar [routes] di bawah — tidak perlu menyentuh fitur lain.
@singleton
class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      // Shares the same navigatorKey used by AppToast, AppPopover, etc.
      navigatorKey: AppNavigator.navigatorKey,
      initialLocation: AppRoutes.login,
      debugLogDiagnostics: true,
      extraCodec: const _AppExtraCodec(),
      routes: [
        ...authRoutes,
        ...kycRoutes,
        ...dashboardRoutes,
        ...auctionRoutes,
        ...liveAuctionRoutes,
        ...nplRoutes,
        ...paymentRoutes,
        ...profileRoutes,

        // TODO: ganti placeholder dengan halaman sungguhan.
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

    if (input is AccountType) {
      return {'__type': 'AccountType', 'value': input.name};
    }

    if (input is Map<String, dynamic>) return input;
    if (input is String || input is int || input is double || input is bool) {
      return input;
    }

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

      if (type == 'AccountType') {
        return AccountType.values.byName(input['value'] as String);
      }

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
