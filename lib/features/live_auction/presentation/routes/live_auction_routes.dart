import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/live_auction/presentation/pages/live_auction_page.dart';

/// Route fitur lelang live. Digabungkan oleh `AppRouter`.
final List<RouteBase> liveAuctionRoutes = [
  GoRoute(
    path: AppRoutes.liveAuction,
    name: 'live-auction',
    builder: (context, state) => const LiveAuctionPage(),
  ),
];
