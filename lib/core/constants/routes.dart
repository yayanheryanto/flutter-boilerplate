import 'package:emas/features/dashboard/domain/entities/auction_item.dart';

class Routes {
  Routes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otp = '/otp';
  static const String verificationPreparation = '/verification-preparation';
  static const String idCardGuide = '/id-card-guide';
  static const String faceGuide = '/face-guide';
  static const String idCardVerification = '/id-card-verification';
  static const String taxIdVerification = '/tax-id-verification';
  static const String faceVerification = '/face-verification';
  static const String cameraPick = '/camera-pick';
  static const String facePick = '/face-pick';
  static const String addressVerification = '/address-verification';
  static const String bankVerification = '/bank-verification';
  static const String accountProcessed = '/account-processed';
  static const String changePassword = '/change-password';
  static const String confirmationVerification = '/confirmation-verification';
  static const String dashboard = '/dashboard';

  // ── Category ──────────────────────────────────────────────────────────────
  /// Param: :slug  (value of [AuctionCategory.slug])
  static const categoryDetail = '/dashboard/category/:slug';
  static String category(String slug) => '/dashboard/category/$slug';

  static const String profile = '/profile';
  static const String joinAuction = '/join-auction';
  static const String auctionList = '/auction-list';
  static const String auctionDetail = '/auction-detail';
  static const String liveAuction = '/live-auction';
  static const String settings = '/settings';
  static const String buyNplDetail = '/buy-npl-detail';
  static const String buyNplConfirmation = '/buy-npl-confirmation';
  static const String notifications = '/notifications';
  static const String uiDemo = '/ui-demo';

  static const String payment = '/payment';
  static const String paymentGuide = '/payment-guide';

  static const String buyNpl = '/buy-npl';
}
