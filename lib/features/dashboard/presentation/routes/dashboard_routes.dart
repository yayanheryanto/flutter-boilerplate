import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/auction/presentation/routes/auction_routes.dart';
import 'package:emas/features/dashboard/presentation/pages/dashboard_page.dart';

/// Route shell dashboard. Child route kategori disediakan fitur auction.
final List<RouteBase> dashboardRoutes = [
  GoRoute(
    path: AppRoutes.dashboard,
    name: 'dashboard',
    builder: (context, state) => const DashboardPage(),
    routes: [auctionCategoryRoute],
  ),
];
