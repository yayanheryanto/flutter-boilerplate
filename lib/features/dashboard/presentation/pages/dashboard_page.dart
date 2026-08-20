import 'dart:async';

import 'package:emas/core/constants/images.dart';
import 'package:emas/features/dashboard/presentation/layouts/buy_npl_layout.dart';
import 'package:emas/features/dashboard/presentation/pages/ikut_lelang_page.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/features/dashboard/presentation/layouts/dashboard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        DashboardLayout(
          bannerCtrl: _bannerCtrl,
          bannerPage: _bannerPage,
          onBannerChanged: (i) => setState(() => _bannerPage = i),
          onRefresh: _onRefresh,
        ),
        const BuyNplLayout(),
        const IkutLelangPage(),
        _buildPlaceholder('Transaksi'),
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
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(
                svgOutline: Images.homeIcon,
                svgFilled: Images.homeIcon,
                label: 'Beranda',
                index: 0,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                svgOutline: Images.nplIcon,
                svgFilled: Images.nplIcon,
                label: 'Beli NPL',
                index: 1,
                currentIndex: currentIndex,
                onTap: onTap,
              ),

              // Gap tengah untuk FAB + label
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
                        color: currentIndex == 2
                            ? AppColors.primary500
                            : Colors.grey.shade400,
                        fontWeight: currentIndex == 2
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              _NavItem(
                svgOutline: Images.transactionIcon,
                svgFilled: Images.transactionIcon,
                label: 'Transaksi',
                index: 3,
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              _NavItem(
                svgOutline: Images.profileIcon,
                svgFilled: Images.profileIcon,
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

// ─── Nav Item ─────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final String svgOutline;
  final String svgFilled;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.svgOutline,
    required this.svgFilled,
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
            // Active indicator bar di atas
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
            SvgPicture.asset(
              isSelected ? svgFilled : svgOutline,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
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
        child: Center(
          child: SvgPicture.asset(
            Images.gavelIcon,
          ),
        ),
      ),
    );
  }
}
