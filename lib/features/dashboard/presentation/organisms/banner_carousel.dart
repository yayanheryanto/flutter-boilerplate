import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/buttons/app_button.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';

const _bannerData = [
  (
    emoji: '🔥',
    title: 'Flash Auction Hari Ini',
    sub: '47 lot eksklusif — mulai jam 13.00',
    c1: Color(0xFFBF360C),
    c2: Color(0xFFEF6C00),
  ),
  (
    emoji: '💰',
    title: 'Biaya Admin 0%',
    sub: 'Untuk pemenang lelang perdana',
    c1: Color(0xFF0D47A1),
    c2: Color(0xFF1565C0),
  ),
  (
    emoji: '📖',
    title: 'Cara Bid yang Benar',
    sub: 'Pelajari strategi memenangkan lelang',
    c1: Color(0xFF1B5E20),
    c2: Color(0xFF2E7D32),
  ),
];

class BannerCarousel extends StatelessWidget {
  final PageController ctrl;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  const BannerCarousel({
    super.key,
    required this.ctrl,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: ctrl,
            onPageChanged: onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: _bannerData.length,
            itemBuilder: (_, i) => _BannerItem(data: _bannerData[i]),
          ),
        ),
        const AppSpacer.sm(),
        _DotIndicator(
          count: _bannerData.length,
          currentIndex: currentPage,
        ),
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  final ({String emoji, String title, String sub, Color c1, Color c2}) data;

  const _BannerItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [data.c1, data.c2],
          ),
        ),
        padding: const EdgeInsets.all(SpacingTokens.md),
        child: Row(
          children: [
            Text(data.emoji, style: const TextStyle(fontSize: 52)),
            const AppSpacer(SpacingTokens.md, horizontal: true),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    data.title,
                    variant: AppTextVariant.titleMedium,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  const AppSpacer.xs(),
                  AppText(
                    data.sub,
                    variant: AppTextVariant.bodySmall,
                    color: Colors.white.withOpacity(0.75),
                  ),
                  const AppSpacer.sm(),
                  AppButton(
                    label: 'Lihat Sekarang',
                    onPressed: () {},
                    variant: AppButtonVariant.outlined,
                    size: AppButtonSize.small,
                    isExpanded: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
