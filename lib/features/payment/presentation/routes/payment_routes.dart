import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/payment/presentation/pages/payment_guide_page.dart';
import 'package:emas/features/payment/presentation/pages/payment_page.dart';

/// Route fitur pembayaran. Digabungkan oleh `AppRouter`.
final List<RouteBase> paymentRoutes = [
  GoRoute(
    path: AppRoutes.payment,
    name: 'payment',
    builder: (context, state) => const PaymentPage(),
  ),
  GoRoute(
    path: AppRoutes.paymentGuide,
    name: 'payment-guide',
    builder: (context, state) => const PaymentGuidePage(),
  ),
];
