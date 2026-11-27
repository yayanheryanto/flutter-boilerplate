import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/promo/domain/entities/promo.dart';
import 'package:emas/features/promo/presentation/bloc/promo_list/promo_list_bloc.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';

/// Carousel gambar promo (auto-slide). Tap gambar → halaman detail promo.
///
/// Membutuhkan [PromoListBloc] di atasnya (disediakan `DashboardPage`
/// agar pull-to-refresh dashboard juga memuat ulang promo).
class PromoCarousel extends StatelessWidget {
  const PromoCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final height = 28.h;

    return BlocBuilder<PromoListBloc, PromoListState>(
      builder: (context, state) {
        return switch (state) {
          PromoListLoading() => SkeletonBox(width: double.infinity, height: height, borderRadius: 0),
          PromoListFailure(:final message) => _PromoError(height: height, message: message),
          PromoListLoaded(:final promos) when promos.isEmpty => const SizedBox.shrink(),
          PromoListLoaded(:final promos) => _PromoPager(promos: promos, height: height),
        };
      },
    );
  }
}

class _PromoPager extends StatefulWidget {
  final List<Promo> promos;
  final double height;

  const _PromoPager({required this.promos, required this.height});

  @override
  State<_PromoPager> createState() => _PromoPagerState();
}

class _PromoPagerState extends State<_PromoPager> {
  static const _autoSlideInterval = Duration(seconds: 4);

  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant _PromoPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jumlah promo berubah setelah refresh → pastikan indeks tetap valid.
    if (_page >= widget.promos.length) {
      _page = 0;
      if (_controller.hasClients) _controller.jumpToPage(0);
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    if (widget.promos.length < 2) return;
    _timer = Timer.periodic(_autoSlideInterval, (_) async {
      if (!mounted || !_controller.hasClients) return;
      final next = (_page + 1) % widget.promos.length;
      await _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDetail(Promo promo) async {
    _timer?.cancel();
    await context.push(AppRoutes.promoDetailPath(promo.id));
    if (mounted) _startAutoSlide();
  }

  @override
  Widget build(BuildContext context) {
    final promos = widget.promos;

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _controller,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _page = i),
            itemCount: promos.length,
            itemBuilder: (context, i) {
              final promo = promos[i];
              return Semantics(
                button: true,
                label: promo.title,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async => _openDetail(promo),
                  child: Hero(
                    tag: 'promo-image-${promo.id}',
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: AppImage(
                        src: promo.imageUrl,
                        width: double.infinity,
                        height: widget.height,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const AppSpacer.sm(),
        _DotIndicator(count: promos.length, currentIndex: _page),
      ],
    );
  }
}

class _PromoError extends StatelessWidget {
  final double height;
  final String message;

  const _PromoError({required this.height, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.image_not_supported_outlined, color: AppColors.neutral400),
          const AppSpacer.sm(),
          AppText(message, variant: AppTextVariant.bodySmall, color: AppColors.neutral500),
          TextButton(
            onPressed: () => context.read<PromoListBloc>().add(const PromoListRequested()),
            child: const Text('Coba lagi'),
          ),
        ],
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
            color: active ? AppColors.primary500 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(AppRadius.xxs),
          ),
        );
      }),
    );
  }
}
