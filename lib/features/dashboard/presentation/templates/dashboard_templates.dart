import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/features/dashboard/data/models/dashboard_dummy_data.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/activity_section.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/auction_list_section.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/banner_carousel.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/category_section.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/dashboard_header.dart';
import 'package:flutter/material.dart';

/// Dashboard layout templates for different devices.
///
/// - [MobileDashboardTemplate] : single-column scroll layout.
/// - [TabletDashboardTemplate] : two-column layout for wider screens.

class MobileDashboardTemplate extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;
  final Future<void> Function() onRefresh;

  const MobileDashboardTemplate({
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
          const SliverToBoxAdapter(child: DashboardHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: context.responsivePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BannerCarousel(
                    ctrl: bannerCtrl,
                    currentPage: bannerPage,
                    onPageChanged: onBannerChanged,
                  ),
                  const AppSpacer.lg(),
                  const CategorySection(),
                  const AppSpacer.xl(),
                  const ActivitySection(),
                  const AppSpacer.xl(),
                  const EndingSoonSection(items: dummyEndingSoon),
                  const AppSpacer.xl(),
                  // RecommendedSection(items: dummyRecommended),
                  // const AppSpacer.xl(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabletDashboardTemplate extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;
  final Future<void> Function() onRefresh;

  const TabletDashboardTemplate({
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
          const SliverToBoxAdapter(child: DashboardHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: context.responsivePadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BannerCarousel(
                              ctrl: bannerCtrl,
                              currentPage: bannerPage,
                              onPageChanged: onBannerChanged,
                            ),
                            const AppSpacer.lg(),
                            const CategorySection(),
                            const AppSpacer.xl(),
                            const ActivitySection(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EndingSoonSection(items: dummyEndingSoon),
                            AppSpacer.xl(),
                            // RecommendedSection(items: dummyRecommended),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
