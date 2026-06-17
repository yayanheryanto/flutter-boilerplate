import 'dart:async';

import 'package:emas/features/dashboard/presentation/pages/ikut_lelang_page.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/features/dashboard/presentation/layouts/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
    _bannerCtrl = PageController();
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

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: Colors.white,
      body: _buildBody(),
      floatingActionButton: _CenterFAB(
        selected: _navIndex == 2,
        onTap: () => setState(() => _navIndex = 2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Custom bottom nav — AppScaffoldWrapper bypasses its default
      // NavigationBar/NavigationRail when this is provided.
      bottomNavigationBar: _DashboardBottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          if (i != 2) setState(() => _navIndex = i);
        },
      ),
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _navIndex,
      children: [
        // Index 0 — Beranda
        DashboardLayout(
          bannerCtrl: _bannerCtrl,
          bannerPage: _bannerPage,
          onBannerChanged: (i) => setState(() => _bannerPage = i),
          onRefresh: _onRefresh,
        ),
        // Index 1 — Beli NPL
        _buildPlaceholder('Beli NPL'),
        // Index 2 — Ikut Lelang (FAB)
        const IkutLelangPage(),
        // Index 3 — Transaksi
        _buildPlaceholder('Transaksi'),
        // Index 4 — Profil
        _buildPlaceholder('Profil'),
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

// ─── Bottom Navigation ────────────────────────────────────────────────────────

class _DashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _DashboardBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = currentIndex == 2 ? AppColors.primary500 : Colors.grey.shade400;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Beranda',
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.description_outlined,
                selectedIcon: Icons.description_rounded,
                label: 'Beli NPL',
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              // Gap for FAB + label
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 2),
                    const SizedBox(height: 24),
                    const SizedBox(height: 2),
                    Text(
                      'Ikut Lelang',
                      style: TextStyle(
                        fontSize: 10,
                        color: labelColor,
                        fontWeight: currentIndex == 2 ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              _NavItem(
                icon: Icons.swap_horiz_outlined,
                selectedIcon: Icons.swap_horiz_rounded,
                label: 'Transaksi',
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: 'Profil',
                index: 4,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primary500 : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          children: [
            // Active indicator — zero margin, flush to top
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: isSelected ? 15.w : 0,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? selectedIcon : icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ─── Center FAB ───────────────────────────────────────────────────────────────

class _CenterFAB extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _CenterFAB({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary500,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary500.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.gavel_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
