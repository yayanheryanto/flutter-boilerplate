import 'package:emas/core/constants/images.dart';
import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/features/dashboard/presentation/sections/home/auction_schedule_card.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/features/dashboard/presentation/sections/home/banner_carousel.dart';
import 'package:emas/features/dashboard/presentation/sections/home/category_section.dart';
import 'package:emas/features/dashboard/presentation/sections/home/dashboard_header.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/features/dashboard/presentation/sections/home/dashboard_dummy_data.dart';

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
          const SliverToBoxAdapter(
            child: DashboardHeader(),
          ),
          SliverToBoxAdapter(
            child: BannerCarousel(
              ctrl: bannerCtrl,
              currentPage: bannerPage,
              onPageChanged: onBannerChanged,
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Spacings.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner → verification
                  AppSpacer.lg(),

                  _VerificationBanner(),

                  // Verification → category
                  AppSpacer.md(),

                  CategorySection(),

                  // Category → auction header
                  AppSpacer.md(),
                ],
              ),
            ),
          ),

          // ===============================================================
          // JADWAL LELANG HEADER
          // ===============================================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacings.md,
              ),
              child: Row(
                children: [
                  // Calendar icon
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary500.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                      color: AppColors.primary500,
                    ),
                  ),

                  const AppSpacer.sm(horizontal: true),

                  // Title
                  const AppText(
                    'Jadwal Lelang',
                    variant: AppTextVariant.titleSmall,
                    fontWeight: FontWeight.bold,
                  ),

                  const Spacer(),

                  // See all
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      // TODO: Navigate to all auction schedules.
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: AppText(
                        'Lihat Semua',
                        variant: AppTextVariant.bodySmall,
                        fontWeight: FontWeight.w500,
                        color: AppColors.info500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===============================================================
          // JADWAL LELANG CARDS
          // ===============================================================
          SliverToBoxAdapter(
            child: Column(
              children: [
                const AppSpacer.sm(),
                SizedBox(
                  height: 110, // tetap sebagai tinggi area ListView
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacings.md,
                    ),
                    itemCount: dummyAuctionSchedule.length,
                    itemBuilder: (_, index) {
                      return AuctionScheduleCard(
                        data: dummyAuctionSchedule[index],
                      );
                    },
                  ),
                ),
                const AppSpacer.lg(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// VERIFICATION BANNER
// ===========================================================================

class _VerificationBanner extends StatelessWidget {
  const _VerificationBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.md,
        vertical: Spacings.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Spacings.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
            spreadRadius: 0.3,
          ),
        ],
      ),
      child: Row(
        children: [
          // ===============================================================
          // VERIFICATION ILLUSTRATION
          // ===============================================================
          SizedBox(
            width: 58,
            height: 58,
            child: FittedBox(
              child: AppImage(
                src: Images.verifyIcon,
              ),
            ),
          ),

          const AppSpacer.sm(horizontal: true),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'Verifikasi Akun Sekarang!',
                  variant: AppTextVariant.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                AppSpacer.xs(),
                AppText(
                  'Dapatkan banyak keuntungan',
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ],
            ),
          ),

          const AppSpacer.sm(),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await context.push(
                Routes.verificationPreparation,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(
                  RadiusTokens.full,
                ),
              ),
              child: const AppText(
                'Verifikasi',
                variant: AppTextVariant.labelSmall,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
