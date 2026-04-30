import 'package:boilerplate/core/responsive/responsive_builder.dart';
import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/shared/widgets/display/app_display.dart';
import 'package:boilerplate/features/dashboard/data/models/dashboard_dummy_data.dart';
import 'package:boilerplate/features/dashboard/presentation/sections/home/activity_section.dart';
import 'package:boilerplate/features/dashboard/presentation/sections/home/auction_list_section.dart';
import 'package:boilerplate/features/dashboard/presentation/sections/home/banner_carousel.dart';
import 'package:boilerplate/features/dashboard/presentation/sections/home/category_section.dart';
import 'package:boilerplate/features/dashboard/presentation/sections/home/dashboard_header.dart';
import 'package:flutter/material.dart';

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
    return ResponsiveLayoutBuilder(
      mobile: _MobileDashboardLayout(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
        onRefresh: onRefresh,
      ),
      tablet: _TabletDashboardLayout(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
        onRefresh: onRefresh,
      ),
      desktop: _TabletDashboardLayout(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
        onRefresh: onRefresh,
      ),
    );
  }
}

// ── Mobile layout ──────────────────────────────────────────────────────────────

class _MobileDashboardLayout extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;
  final Future<void> Function() onRefresh;

  const _MobileDashboardLayout({
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tablet / Desktop layout ────────────────────────────────────────────────────

class _TabletDashboardLayout extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;
  final Future<void> Function() onRefresh;

  const _TabletDashboardLayout({
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
