import 'package:emas/features/dashboard/data/models/auction_item.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String verificationPreparation = '/verification-preparation';
  static const String ktpGuide = '/ktp-guide';
  static const String faceGuide = '/face-guide';
  static const String ktpVerification = '/ktp-verification';
  static const String npwpVerification = '/npwp-verification';
  static const String faceVerification = '/face-verification';
  static const String camerPick = '/camera-pick';
  static const String facePick = '/face-pick';
  static const String addressVerification = '/address-verification';
  static const String bankVerification = '/bank-verification';
  static const String accountProcessed = '/account-processed';
  static const String changePassword = '/change-password';
  static const String confirmationVerification = '/confirmation-verification';
  static const String dashboard = '/dashboard';

  // ── Category ──────────────────────────────────────────────────────────────
  /// Param: :slug  (nilai dari [AuctionCategory.slug])
  static const categoryDetail = '/dashboard/category/:slug';
  static String category(String slug) => '/dashboard/category/$slug';

  static const String profile = '/profile';
  static const String ikutLelang = '/ikut-lelang';
  static const String lelangList = '/lelang-list';
  static const String liveAuction = '/live-auction';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String uiDemo = '/ui-demo';
}
