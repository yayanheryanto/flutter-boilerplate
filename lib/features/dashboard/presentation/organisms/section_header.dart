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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
      child: Row(
        children: [
          AppText(
            title,
            variant: AppTextVariant.titleMedium,
            fontWeight: FontWeight.w800,
          ),
          if (trailing != null) ...[
            const AppSpacer(SpacingTokens.sm, horizontal: true),
            trailing!,
          ],
          const Spacer(),
          if (onSeeAll != null)
            AppLinkText(
              'Lihat Semua',
              onTap: onSeeAll!,
              variant: AppTextVariant.labelLarge,
            ),
        ],
      ),
    );
  }
}
