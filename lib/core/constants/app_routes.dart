import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';

  // ── Category ──────────────────────────────────────────────────────────────
  /// Param: :slug  (nilai dari [AuctionCategory.slug])
  static const categoryDetail = '/dashboard/category/:slug';
  static String category(String slug) => '/dashboard/category/$slug';

  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String uiDemo = '/ui-demo';
}
