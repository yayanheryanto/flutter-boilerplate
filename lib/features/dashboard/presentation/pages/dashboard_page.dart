import 'dart:async';

import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/core/ui/design_system/organisms/app_scaffold_wrapper.dart';
import 'package:boilerplate/features/dashboard/presentation/pages/home_tab.dart';
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
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      _bannerCtrl.animateToPage(
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

  /// Dipanggil saat user pull-to-refresh di tab mana pun.
  /// Ganti dengan pemanggilan BLoC/repository yang sesuai per tab.
  Future<void> _onRefresh() async {
    // TODO: dispatch refresh event ke BLoC masing-masing tab
    await Future.delayed(const Duration(milliseconds: 800));
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_navIndex) {
      case 0:
        return HomeTab(
          bannerCtrl: _bannerCtrl,
          bannerPage: _bannerPage,
          onBannerChanged: (i) => setState(() => _bannerPage = i),
          onRefresh: _onRefresh,
        );
      default:
        // Tab placeholder — bisa di-refresh juga
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: AppText(
                    ['', 'Katalog', 'Transaksi', 'Profil'][_navIndex],
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
}