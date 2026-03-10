import 'package:boilerplate/core/theme/tokens/color_tokens.dart';
import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';
import 'package:boilerplate/features/dashboard/data/models/dashboard_formatters.dart';
import 'package:flutter/material.dart';

class BidCard extends StatelessWidget {
  final AuctionItem item;

  const BidCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor =
        item.winning ? ColorTokens.success500 : ColorTokens.error500;

    return AppCard(
      onTap: () {},
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(RadiusTokens.md),
            ),
            child: Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const AppSpacer(SpacingTokens.sm, horizontal: true),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.title,
                  variant: AppTextVariant.labelLarge,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                const AppSpacer.xs(),
                AppText(
                  formatRupiah(item.bid),
                  variant: AppTextVariant.titleSmall,
                  color: scheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          AppBadge(
            label: item.winning ? '● Tertinggi' : '● Tersalip',
            backgroundColor: statusColor.withOpacity(0.12),
            textColor: statusColor,
          ),
        ],
      ),
    );
  }
}
