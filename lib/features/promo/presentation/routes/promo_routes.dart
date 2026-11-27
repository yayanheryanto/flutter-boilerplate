import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/promo/presentation/pages/promo_detail_page.dart';

/// Route fitur promo. Digabungkan oleh `AppRouter`.
final List<RouteBase> promoRoutes = [
  GoRoute(
    path: AppRoutes.promoDetail,
    name: 'promo-detail',
    builder: (context, state) => PromoDetailPage(promoId: state.pathParameters['id'] ?? ''),
  ),
];
