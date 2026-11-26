import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/auction/domain/entities/auction_item.dart';
import 'package:emas/features/auction/presentation/pages/auction_detail_page.dart';
import 'package:emas/features/auction/presentation/pages/auction_list_page.dart';
import 'package:emas/features/auction/presentation/pages/category_page.dart';
import 'package:emas/features/auction/presentation/pages/join_auction_page.dart';

/// Route kategori — dipasang sebagai child route `/dashboard`
/// sehingga path lengkapnya `/dashboard/category/:slug`.
final GoRoute auctionCategoryRoute = GoRoute(
  path: 'category/:slug',
  name: 'category-detail',
  builder: (_, state) {
    final slug = state.pathParameters['slug'] ?? '';
    return CategoryPage(category: AuctionCategory.fromSlug(slug));
  },
);

/// Route fitur auction (top-level). Digabungkan oleh `AppRouter`.
final List<RouteBase> auctionRoutes = [
  GoRoute(
    path: AppRoutes.joinAuction,
    name: 'join-auction',
    builder: (context, state) => const JoinAuctionPage(),
  ),
  GoRoute(
    path: AppRoutes.auctionList,
    name: 'auction-list',
    builder: (context, state) => const AuctionListPage(),
  ),
  GoRoute(
    path: AppRoutes.auctionDetail,
    name: 'auction-detail',
    builder: (context, state) => const AuctionDetailPage(),
  ),
];
