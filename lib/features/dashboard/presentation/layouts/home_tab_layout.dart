import 'package:boilerplate/core/responsive/responsive_builder.dart';
import 'package:boilerplate/features/dashboard/presentation/layouts/dashboard_layout.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;
  final Future<void> Function() onRefresh;

  const HomeTab({
    super.key,
    required this.bannerCtrl,
    required this.bannerPage,
    required this.onBannerChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      mobile: MobileDashboardTemplate(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
        onRefresh: onRefresh,
      ),
      tablet: TabletDashboardTemplate(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
        onRefresh: onRefresh,
      ),
      desktop: TabletDashboardTemplate(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
        onRefresh: onRefresh,
      ),
    );
  }
}
