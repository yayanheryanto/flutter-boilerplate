import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/kyc/domain/entities/account_type.dart';
import 'package:emas/features/kyc/presentation/pages/account_processed_page.dart';
import 'package:emas/features/kyc/presentation/pages/address_verification_page.dart';
import 'package:emas/features/kyc/presentation/pages/bank_verification_page.dart';
import 'package:emas/features/kyc/presentation/pages/camera_pick_page.dart';
import 'package:emas/features/kyc/presentation/pages/confirmation_verification_page.dart';
import 'package:emas/features/kyc/presentation/pages/face_detection_page.dart';
import 'package:emas/features/kyc/presentation/pages/face_verification_guide_page.dart';
import 'package:emas/features/kyc/presentation/pages/face_verification_page.dart';
import 'package:emas/features/kyc/presentation/pages/id_card_guide_page.dart';
import 'package:emas/features/kyc/presentation/pages/id_card_verification_page.dart';
import 'package:emas/features/kyc/presentation/pages/tax_id_verification_page.dart';
import 'package:emas/features/kyc/presentation/pages/verification_preparation_page.dart';

AccountType _accountTypeOf(GoRouterState state) =>
    state.extra as AccountType? ?? AccountType.personal;

/// Route alur verifikasi akun (KYC). Digabungkan oleh `AppRouter`.
final List<RouteBase> kycRoutes = [
  GoRoute(
    path: AppRoutes.verificationPreparation,
    name: 'verification-preparation',
    builder: (context, state) => const VerificationPreparationPage(),
  ),
  GoRoute(
    path: AppRoutes.idCardGuide,
    name: 'id-card-guide',
    builder: (context, state) => IdCardGuidePage(accountType: _accountTypeOf(state)),
  ),
  GoRoute(
    path: AppRoutes.idCardVerification,
    name: 'id-card-verification',
    builder: (context, state) => IdCardVerificationPage(accountType: _accountTypeOf(state)),
  ),
  GoRoute(
    path: AppRoutes.taxIdVerification,
    name: 'tax-id-verification',
    builder: (context, state) => TaxIdVerificationPage(accountType: _accountTypeOf(state)),
  ),
  GoRoute(
    path: AppRoutes.faceGuide,
    name: 'face-guide',
    builder: (context, state) => FaceVerificationGuidePage(accountType: _accountTypeOf(state)),
  ),
  GoRoute(
    path: AppRoutes.faceVerification,
    name: 'face-verification',
    builder: (context, state) => FaceVerificationPage(accountType: _accountTypeOf(state)),
  ),
  GoRoute(
    path: AppRoutes.confirmationVerification,
    name: 'confirmation-verification',
    builder: (context, state) => const ConfirmationVerificationPage(),
  ),
  GoRoute(
    path: AppRoutes.cameraPick,
    name: 'camera-pick',
    builder: (context, state) => const CameraPickPage(),
  ),
  GoRoute(
    path: AppRoutes.facePick,
    name: 'face-pick',
    builder: (context, state) => const FaceDetectionPage(),
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
];
