import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppPageBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double? elevation;
  final double? titleSpacing;

  const AppPageBar({
    super.key,
    this.title,
    this.backgroundColor = AppColors.white,
    this.showBackButton = true,
    this.onBack,
    this.elevation = 0,
    this.titleSpacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation ?? 0,
      shadowColor: AppColors.black,
      scrolledUnderElevation: 0,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                size: 28,
                color: AppColors.primary500,
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
