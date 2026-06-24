import 'package:cached_network_image/cached_network_image.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const List<String> dummyBannerUrls = [
  'https://oss.megafinance.co.id/development/mitra-megapromotion/2024/04/05/promo1.jpeg',
  'https://oss.megafinance.co.id/development/mitra-megapromotion/2024/04/05/promo2.jpeg',
  'https://oss.megafinance.co.id/development/mitra-megapromotion/2024/04/05/promo3.jpeg',
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
        // Full-width banner — no horizontal padding
        SizedBox(
          height: 28.h,
          child: PageView.builder(
            controller: ctrl,
            onPageChanged: onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: dummyBannerUrls.length,
            itemBuilder: (_, i) => _BannerPlaceholder(
              imageUrl: dummyBannerUrls[i],
            ),
          ),
        ),
        const AppSpacer.sm(),
        _DotIndicator(
          count: dummyBannerUrls.length,
          currentIndex: currentPage,
        ),
      ],
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  final String imageUrl;

  const _BannerPlaceholder({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: AppImage(
        src: imageUrl,
        width: double.infinity,
        height: 28.h,
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _DotIndicator({
    required this.count,
    required this.currentIndex,
  });

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
            color: active ? AppColors.primary500 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
