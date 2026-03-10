import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
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
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
          ),
          const AppSpacer.sm(),
          AppText(
            value,
            variant: AppTextVariant.headlineSmall,
            fontWeight: FontWeight.w800,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.xs(),
          AppText(
            label,
            variant: AppTextVariant.labelSmall,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
            textAlign: TextAlign.center,
            height: 1.3,
          ),
        ],
      ),
    );
  }
}
