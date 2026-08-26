import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/data/models/dashboard_formatters.dart';
import 'package:flutter/material.dart';

class BidCard extends StatelessWidget {
  final AuctionItem item;

  const BidCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isWinning = item.winning;
    final statusColor = isWinning ? AppColors.success500 : AppColors.error500;
    final statusLabel = isWinning ? 'Tertinggi' : 'Tersalip';

    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.md,
          vertical: AppSpacings.sm + 4,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(RadiusTokens.md),
              ),
              child: Center(
                child: Text(item.image, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const AppSpacer(AppSpacings.sm, horizontal: true),
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
                  const SizedBox(height: 2),
                  AppText(
                    formatRupiah(item.bid),
                    variant: AppTextVariant.bodySmall,
                    color: scheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(RadiusTokens.full),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  AppText(
                    statusLabel,
                    variant: AppTextVariant.labelSmall,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
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
