import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/features/dashboard/presentation/sections/home/jadwal_lelang_card.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/features/dashboard/presentation/sections/home/banner_carousel.dart';
import 'package:emas/features/dashboard/presentation/sections/home/category_section.dart';
import 'package:emas/features/dashboard/presentation/sections/home/dashboard_header.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/features/dashboard/presentation/sections/home/dashboard_dummy_data.dart';

/// Responsive home-tab layout.
///
/// - Mobile  : single-column scroll.
/// - Tablet/Desktop : two-column grid.
class DashboardLayout extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;
  final Future<void> Function() onRefresh;

  const DashboardLayout({
    super.key,
    required this.bannerCtrl,
    required this.bannerPage,
    required this.onBannerChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Header
          const SliverToBoxAdapter(child: DashboardHeader()),

          // Banner — edge to edge (no horizontal padding)
          SliverToBoxAdapter(
            child: BannerCarousel(
              ctrl: bannerCtrl,
              currentPage: bannerPage,
              onPageChanged: onBannerChanged,
            ),
          ),

          // Rest of content — with padding
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacings.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacer.lg(),
                  _VerificationBanner(),
                  AppSpacer.lg(),
                  CategorySection(),
                  AppSpacer.xl(),
                ],
              ),
            ),
          ),

          // Jadwal Lelang header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      size: 16,
                      color: AppColors.primary500,
                    ),
                  ),
                  const AppSpacer(8, horizontal: true),
                  const AppText(
                    'Jadwal Lelang',
                    variant: AppTextVariant.titleSmall,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const AppText(
                      'Lihat Semua',
                      variant: AppTextVariant.bodySmall,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Jadwal Lelang cards — horizontal scroll
          SliverToBoxAdapter(
            child: Column(
              children: [
                const AppSpacer.sm(),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.md,
                    ),
                    itemCount: dummyJadwalLelang.length,
                    itemBuilder: (_, i) => JadwalLelangCard(data: dummyJadwalLelang[i]),
                  ),
                ),
                const AppSpacer.xl(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mobile layout ──────────────────────────────────────────────────────────────

// class _MobileDashboardLayout extends StatelessWidget {
//   final PageController bannerCtrl;
//   final int bannerPage;
//   final ValueChanged<int> onBannerChanged;
//   final Future<void> Function() onRefresh;
//
//   const _MobileDashboardLayout({
//     required this.bannerCtrl,
//     required this.bannerPage,
//     required this.onBannerChanged,
//     required this.onRefresh,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: CustomScrollView(
//         physics: const AlwaysScrollableScrollPhysics(
//           parent: BouncingScrollPhysics(),
//         ),
//         slivers: [
//           // Header
//           const SliverToBoxAdapter(child: DashboardHeader()),
//
//           // Banner — edge to edge (no horizontal padding)
//           SliverToBoxAdapter(
//             child: BannerCarousel(
//               ctrl: bannerCtrl,
//               currentPage: bannerPage,
//               onPageChanged: onBannerChanged,
//             ),
//           ),
//
//           // Rest of content — with padding
//           const SliverToBoxAdapter(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppSpacings.md,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AppSpacer.lg(),
//                   _VerificationBanner(),
//                   AppSpacer.lg(),
//                   CategorySection(),
//                   AppSpacer.xl(),
//                 ],
//               ),
//             ),
//           ),
//
//           // Jadwal Lelang header
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 28,
//                     height: 28,
//                     decoration: BoxDecoration(
//                       color: AppColors.primary500.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Icon(
//                       Icons.calendar_month_rounded,
//                       size: 16,
//                       color: AppColors.primary500,
//                     ),
//                   ),
//                   const AppSpacer(8, horizontal: true),
//                   const AppText(
//                     'Jadwal Lelang',
//                     variant: AppTextVariant.titleSmall,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   const Spacer(),
//                   GestureDetector(
//                     onTap: () {},
//                     child: const AppText(
//                       'Lihat Semua',
//                       variant: AppTextVariant.bodySmall,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.primary500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Jadwal Lelang cards — horizontal scroll
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 const AppSpacer.sm(),
//                 SizedBox(
//                   height: 220,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     physics: const BouncingScrollPhysics(),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: AppSpacings.md,
//                     ),
//                     itemCount: dummyJadwalLelang.length,
//                     itemBuilder: (_, i) => JadwalLelangCard(data: dummyJadwalLelang[i]),
//                   ),
//                 ),
//                 const AppSpacer.xl(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Tablet / Desktop layout ────────────────────────────────────────────────────
//
// class _TabletDashboardLayout extends StatelessWidget {
//   final PageController bannerCtrl;
//   final int bannerPage;
//   final ValueChanged<int> onBannerChanged;
//   final Future<void> Function() onRefresh;
//
//   const _TabletDashboardLayout({
//     required this.bannerCtrl,
//     required this.bannerPage,
//     required this.onBannerChanged,
//     required this.onRefresh,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: onRefresh,
//       child: CustomScrollView(
//         physics: const AlwaysScrollableScrollPhysics(
//           parent: BouncingScrollPhysics(),
//         ),
//         slivers: [
//           const SliverToBoxAdapter(child: DashboardHeader()),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: context.responsivePadding,
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 5,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             BannerCarousel(
//                               ctrl: bannerCtrl,
//                               currentPage: bannerPage,
//                               onPageChanged: onBannerChanged,
//                             ),
//                             const AppSpacer.lg(),
//                             const CategorySection(),
//                             const AppSpacer.xl(),
//                             const ActivitySection(),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ─── Verification Banner ──────────────────────────────────────────────────────

class _VerificationBanner extends StatelessWidget {
  const _VerificationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Illustration
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(RadiusTokens.md),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: AppColors.primary500,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacings.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Verifikasi Akun Sekarang!',
                  fontWeight: FontWeight.bold,
                ),
                AppText(
                  'Dapatkan banyak keuntungan',
                  variant: AppTextVariant.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacings.sm),
          // Button — GestureDetector+Container to avoid infinite width constraint
          GestureDetector(
            onTap: () async => context.push(AppRoutes.verificationPreparation),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.md,
                vertical: AppSpacings.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(RadiusTokens.full),
              ),
              child: const AppText(
                'Verifikasi',
                variant: AppTextVariant.labelMedium,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
