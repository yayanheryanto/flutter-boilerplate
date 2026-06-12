import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/features/dashboard/data/models/dashboard_dummy_data.dart';
import 'package:emas/features/dashboard/presentation/widgets/home/bid_card.dart';
import 'package:emas/features/dashboard/presentation/widgets/home/metric_card.dart';
import 'package:emas/features/dashboard/presentation/widgets/home/section_header.dart';
import 'package:flutter/material.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(title: 'Aktivitas Saya', onSeeAll: () {}),
        const AppSpacer.sm(),
        const _MetricRow(),
        const AppSpacer.md(),
        ...dummyMyBids.map(
          (item) => Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.md,
              0,
              AppSpacings.md,
              AppSpacings.sm,
            ),
            child: BidCard(item: item),
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md),
      child: Row(
        children: [
          Expanded(
            child: MetricCard(
              emoji: '📈',
              value: '${dummyMyBids.length}',
              label: 'Tawaran\nAktif',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {},
            ),
          ),
          const AppSpacer(AppSpacings.sm, horizontal: true),
          Expanded(
            child: MetricCard(
              emoji: '🏆',
              value: '2',
              label: 'Dimenangkan',
              color: AppColors.warning500,
              onTap: () {},
            ),
          ),
          const AppSpacer(AppSpacings.sm, horizontal: true),
          Expanded(
            child: MetricCard(
              emoji: '❤️',
              value: '8',
              label: 'Disukai',
              color: AppColors.error500,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
