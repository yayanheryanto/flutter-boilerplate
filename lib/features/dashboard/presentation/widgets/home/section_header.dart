import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
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
            AppLinkText(
              'Semua',
              color: scheme.primary,
              onTap: onSeeAll!,
            ),
        ],
      ),
    );
  }
}
