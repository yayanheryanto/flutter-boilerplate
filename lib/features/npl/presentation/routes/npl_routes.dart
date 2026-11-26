import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/npl/presentation/pages/buy_npl_confirmation_page.dart';
import 'package:emas/features/npl/presentation/pages/buy_npl_detail_page.dart';
import 'package:emas/features/npl/presentation/pages/buy_npl_page.dart';

/// Route fitur pembelian NPL. Digabungkan oleh `AppRouter`.
final List<RouteBase> nplRoutes = [
  GoRoute(
    path: AppRoutes.buyNpl,
    name: 'buy-npl',
    builder: (context, state) => const BuyNplPage(),
  ),
  GoRoute(
    path: AppRoutes.buyNplDetail,
    name: 'buy-npl-detail',
    builder: (context, state) => const BuyNplDetailPage(),
  ),
  GoRoute(
    path: AppRoutes.buyNplConfirmation,
    name: 'buy-npl-confirmation',
    builder: (context, state) => const BuyNplConfirmationPage(),
  ),
];
