import 'package:emas/core/constants/images.dart';
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
                horizontal: AppSpacings.md,
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
                horizontal: AppSpacings.md,
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

                  const SizedBox(width: 10),

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
                      horizontal: AppSpacings.md,
                    ),
                    itemCount: dummyJadwalLelang.length,
                    itemBuilder: (_, index) {
                      return JadwalLelangCard(
                        data: dummyJadwalLelang[index],
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
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacings.md),
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

          const SizedBox(width: 10),

          // ===============================================================
          // TEXT
          // ===============================================================
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
                SizedBox(height: 3),
                AppText(
                  'Dapatkan banyak keuntungan',
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ===============================================================
          // BUTTON
          // ===============================================================
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              await context.push(
                AppRoutes.verificationPreparation,
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
