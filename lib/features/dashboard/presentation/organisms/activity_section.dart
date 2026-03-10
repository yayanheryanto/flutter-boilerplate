import 'package:boilerplate/core/theme/tokens/color_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/features/dashboard/data/models/dashboard_dummy_data.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/bid_card.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/metric_card.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/section_header.dart';
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
              SpacingTokens.md,
              0,
              SpacingTokens.md,
              SpacingTokens.sm,
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
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
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
          const AppSpacer(SpacingTokens.sm, horizontal: true),
          Expanded(
            child: MetricCard(
              emoji: '🏆',
              value: '2',
              label: 'Dimenangkan',
              color: ColorTokens.warning500,
              onTap: () {},
            ),
          ),
          const AppSpacer(SpacingTokens.sm, horizontal: true),
          Expanded(
            child: MetricCard(
              emoji: '❤️',
              value: '8',
              label: 'Disukai',
              color: ColorTokens.error500,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
