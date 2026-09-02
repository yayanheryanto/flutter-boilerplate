import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const MetricCard({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Spacings.md,
          horizontal: Spacings.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 15)),
              ),
            ),
            const SizedBox(height: Spacings.sm),
            AppText(
              value,
              variant: AppTextVariant.titleLarge,
              fontWeight: FontWeight.w800,
            ),
            AppText(
              label,
              variant: AppTextVariant.labelSmall,
              color: scheme.onSurface.withOpacity(0.45),
              height: 1.3,
            ),
          ],
        ),
      ),
    );
  }
}
