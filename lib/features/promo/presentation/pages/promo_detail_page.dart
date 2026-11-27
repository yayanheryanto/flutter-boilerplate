import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/promo/domain/entities/promo.dart';
import 'package:emas/features/promo/presentation/bloc/promo_detail/promo_detail_bloc.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';

/// Detail promo: gambar, judul, masa berlaku, dan deskripsi.
class PromoDetailPage extends StatelessWidget {
  final String promoId;

  const PromoDetailPage({super.key, required this.promoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PromoDetailBloc>()..add(PromoDetailRequested(promoId)),
      child: AppScaffoldWrapper(
        backgroundColor: AppColors.white,
        appBar: const AppPageBar(title: 'Detail Promo'),
        body: BlocBuilder<PromoDetailBloc, PromoDetailState>(
          builder: (context, state) {
            return switch (state) {
              PromoDetailLoading() => const _PromoDetailSkeleton(),
              PromoDetailFailure(:final message) => ErrorStateWidget(
                  message: message,
                  onRetry: () => context.read<PromoDetailBloc>().add(PromoDetailRequested(promoId)),
                ),
              PromoDetailLoaded(:final promo) => _PromoDetailContent(promo: promo),
            };
          },
        ),
      ),
    );
  }
}

class _PromoDetailContent extends StatelessWidget {
  final Promo promo;

  const _PromoDetailContent({required this.promo});

  @override
  Widget build(BuildContext context) {
    final validUntil = promo.validUntil;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacings.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag Hero sama dengan carousel → transisi gambar mulus.
          Hero(
            tag: 'promo-image-${promo.id}',
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              child: AppImage(
                src: promo.imageUrl,
                width: double.infinity,
                height: 28.h,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacings.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  promo.title,
                  variant: AppTextVariant.headlineSmall,
                  fontWeight: FontWeight.w700,
                ),
                if (promo.subtitle.isNotEmpty) ...[
                  const AppSpacer.xs(),
                  AppText(
                    promo.subtitle,
                    variant: AppTextVariant.bodyMedium,
                    color: AppColors.neutral600,
                  ),
                ],
                if (validUntil != null) ...[
                  const AppSpacer.md(),
                  _ValidityBadge(validUntil: validUntil),
                ],
                const AppSpacer.lg(),
                const AppText(
                  'Deskripsi',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w700,
                ),
                const AppSpacer.sm(),
                AppText(
                  promo.description,
                  variant: AppTextVariant.bodyMedium,
                  color: AppColors.neutral700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidityBadge extends StatelessWidget {
  final DateTime validUntil;

  const _ValidityBadge({required this.validUntil});

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('d MMMM yyyy', 'id_ID').format(validUntil);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.sm, vertical: AppSpacings.xs),
      decoration: BoxDecoration(
        color: AppColors.primary500.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.schedule_rounded, size: 16, color: AppColors.primary500),
          const AppSpacer.xs(horizontal: true),
          AppText(
            'Berlaku hingga $label',
            variant: AppTextVariant.bodySmall,
            fontWeight: FontWeight.w600,
            color: AppColors.primary500,
          ),
        ],
      ),
    );
  }
}

class _PromoDetailSkeleton extends StatelessWidget {
  const _PromoDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(width: double.infinity, height: 28.h, borderRadius: 0),
        const Padding(
          padding: EdgeInsets.all(AppSpacings.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 240, height: 24),
              AppSpacer.sm(),
              SkeletonBox(width: 180, height: 16),
              AppSpacer.lg(),
              SkeletonBox(width: double.infinity, height: 14),
              AppSpacer.xs(),
              SkeletonBox(width: double.infinity, height: 14),
              AppSpacer.xs(),
              SkeletonBox(width: 200, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}
