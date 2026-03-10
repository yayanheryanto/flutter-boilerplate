import 'package:boilerplate/core/responsive/responsive_builder.dart';
import 'package:boilerplate/features/dashboard/presentation/templates/dashboard_templates.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final PageController bannerCtrl;
  final int bannerPage;
  final ValueChanged<int> onBannerChanged;

  const HomeTab({
    super.key,
    required this.bannerCtrl,
    required this.bannerPage,
    required this.onBannerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      mobile: MobileDashboardTemplate(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
      ),
      tablet: TabletDashboardTemplate(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
      ),
      desktop: TabletDashboardTemplate(
        bannerCtrl: bannerCtrl,
        bannerPage: bannerPage,
        onBannerChanged: onBannerChanged,
      ),
    );
  }
}
