import 'dart:async';

import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/features/dashboard/presentation/layouts/dashboard_layout.dart';
import 'package:emas/features/dashboard/presentation/layouts/profile_layout.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _navIndex = 0;
  int _bannerPage = 0;
  late final PageController _bannerCtrl;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerCtrl = PageController(viewportFraction: 0.92);
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (!mounted || !_bannerCtrl.hasClients) return;
      await _bannerCtrl.animateToPage(
        (_bannerPage + 1) % 3,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerCtrl.dispose();
    super.dispose();
  }

  /// Called when user pull-to-refreshes on any tab.
  /// Replace with per-tab BLoC dispatch as needed.
  Future<void> _onRefresh() async {
    // TODO: dispatch refresh event to each tab's BLoC
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      currentIndex: _navIndex,
      onNavigationTap: (i) => setState(() => _navIndex = i),
      navigationItems: const [
        NavigationItem(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
          label: 'Beranda',
        ),
        NavigationItem(
          icon: Icons.grid_view_outlined,
          selectedIcon: Icons.grid_view_rounded,
          label: 'Katalog',
        ),
        NavigationItem(
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long_rounded,
          label: 'Transaksi',
        ),
        NavigationItem(
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          label: 'Profil',
        ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _navIndex,
      children: [
        // Index 0 — Home
        DashboardLayout(
          bannerCtrl: _bannerCtrl,
          bannerPage: _bannerPage,
          onBannerChanged: (i) => setState(() => _bannerPage = i),
          onRefresh: _onRefresh,
        ),
        // Index 1 — Katalog
        _buildPlaceholder('Katalog'),
        // Index 2 — Transaksi
        _buildPlaceholder('Transaksi'),
        // Index 3 — Profil
        ProfileLayout(onRefresh: _onRefresh),
      ],
    );
  }

  Widget _buildPlaceholder(String title) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: AppText(
                title,
                variant: AppTextVariant.titleMedium,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
