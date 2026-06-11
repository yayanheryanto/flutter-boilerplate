import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

class JadwalLelangData {
  final String itemName;
  final String locationName;
  final String dateLabel;   // e.g. "12 Jun 2026"
  final String timeLabel;   // e.g. "10.00"
  final String emoji;
  final Color tint;
  final bool isLive;

  const JadwalLelangData({
    required this.itemName,
    required this.locationName,
    required this.dateLabel,
    required this.timeLabel,
    required this.emoji,
    this.tint = const Color(0xFFFFE0B2),
    this.isLive = true,
  });
}

class JadwalLelangCard extends StatelessWidget {
  final JadwalLelangData data;

  const JadwalLelangCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: SpacingTokens.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Thumbnail ─────────────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(RadiusTokens.lg),
            ),
            child: Container(
              height: 90,
              width: double.infinity,
              color: data.tint,
              child: Center(
                child: Text(
                  data.emoji,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),

          // ── Info ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              SpacingTokens.sm,
              SpacingTokens.sm,
              SpacingTokens.sm,
              SpacingTokens.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data.itemName,
                  variant: AppTextVariant.labelMedium,
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                AppText(
                  data.locationName,
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                // Date + time row
                Row(
                  children: [
                    AppText(
                      data.dateLabel,
                      variant: AppTextVariant.labelSmall,
                      color: Colors.grey.shade600,
                    ),
                    AppText(
                      '  |  ',
                      variant: AppTextVariant.labelSmall,
                      color: Colors.grey.shade400,
                    ),
                    AppText(
                      data.timeLabel,
                      variant: AppTextVariant.labelSmall,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                const SizedBox(height: SpacingTokens.sm),

                // ── Live Auction badge ─────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                  ),
                  child: Center(
                    child: AppText(
                      'Live Auction',
                      variant: AppTextVariant.labelSmall,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}