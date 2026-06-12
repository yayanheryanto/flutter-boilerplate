import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:flutter/material.dart';

const _bannerCount = 3;

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
          height: 200,
          child: PageView.builder(
            controller: ctrl,
            onPageChanged: onPageChanged,
            physics: const BouncingScrollPhysics(),
            itemCount: _bannerCount,
            itemBuilder: (_, i) => const _BannerPlaceholder(),
          ),
        ),
        const AppSpacer.sm(),
        _DotIndicator(count: _bannerCount, currentIndex: currentPage),
      ],
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      // TODO: replace with actual banner image
      // child: Image.network(url, fit: BoxFit.cover),
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
            color: active ? AppColors.primary500 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}