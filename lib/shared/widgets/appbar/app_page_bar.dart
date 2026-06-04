import 'package:emas/shared/theme/color_tokens.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double? elevation;
  final double? titleSpacing;

  const AppPageAppBar({
    super.key,
    this.title,
    this.backgroundColor = ColorTokens.white,
    this.showBackButton = true,
    this.onBack,
    this.elevation = 0,
    this.titleSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      scrolledUnderElevation: 0,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 28,
                color: ColorTokens.primary500,
              ),
              onPressed: onBack ?? () => context.pop(),
            )
          : null,
      title: title == null
          ? null
          : AppText(
              title!,
              variant: AppTextVariant.titleMedium,
              fontWeight: FontWeight.w600,
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
