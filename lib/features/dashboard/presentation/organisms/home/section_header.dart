import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';

class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final Widget? trailing;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
      child: Row(
        children: [
          AppText(
            title,
            variant: AppTextVariant.titleSmall,
            fontWeight: FontWeight.w700,
          ),
          if (trailing != null) ...[
            const AppSpacer(SpacingTokens.xs, horizontal: true),
            trailing!,
          ],
          const Spacer(),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: AppText(
                'Semua',
                variant: AppTextVariant.labelMedium,
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
