import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';

const _bannerData = [
  (
    emoji: '🔥',
    tag: 'HARI INI',
    title: 'Flash Auction',
    sub: '47 lot eksklusif mulai jam 13.00',
    c1: Color(0xFFBF360C),
    c2: Color(0xFFEF6C00),
  ),
  (
    emoji: '💰',
    tag: 'PROMO',
    title: 'Biaya Admin 0%',
    sub: 'Gratis untuk pemenang perdana',
    c1: Color(0xFF0D47A1),
    c2: Color(0xFF1976D2),
  ),
  (
    emoji: '📖',
    tag: 'PANDUAN',
    title: 'Cara Bid yang Benar',
    sub: 'Strategi memenangkan lelang',
    c1: Color(0xFF1B5E20),
    c2: Color(0xFF388E3C),
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
          height: 172,
          child: PageView.builder(
            controller: ctrl,
            onPageChanged: onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: _bannerData.length,
            itemBuilder: (_, i) => _BannerItem(data: _bannerData[i]),
          ),
        ),
        const AppSpacer.sm(),
        _DotIndicator(count: _bannerData.length, currentIndex: currentPage),
      ],
    );
  }
}

class _BannerItem extends StatelessWidget {
  final ({String emoji, String tag, String title, String sub, Color c1, Color c2}) data;

  const _BannerItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.xs),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [data.c1, data.c2],
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.lg,
          vertical: SpacingTokens.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pill tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingTokens.sm,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(RadiusTokens.full),
                    ),
                    child: AppText(
                      data.tag,
                      variant: AppTextVariant.labelSmall,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const AppSpacer.xs(),
                  AppText(
                    data.title,
                    variant: AppTextVariant.headlineSmall,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  const AppSpacer.xs(),
                  AppText(
                    data.sub,
                    variant: AppTextVariant.bodySmall,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const AppSpacer.sm(),
                  const Row(
                    children: [
                      AppText(
                        'Lihat detail',
                        variant: AppTextVariant.labelMedium,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      AppSpacer(4, horizontal: true),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(data.emoji, style: const TextStyle(fontSize: 64)),
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
