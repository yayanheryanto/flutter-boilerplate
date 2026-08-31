import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppPageBarTitleVariant {
  textOnly,
  withIcon,
  withImage,
}

class AppPageBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double? elevation;
  final double? titleSpacing;
  final AppPageBarTitleVariant titleVariant;
  final IconData? titleIcon;
  final Color? titleIconColor;
  final double titleIconSize;
  final Widget? titleImage;
  final double titleGap;
  final List<Widget>? actions;
  final double topMargin;

  const AppPageBar({
    super.key,
    this.title,
    this.backgroundColor = AppColors.white,
    this.showBackButton = true,
    this.onBack,
    this.elevation = 0,
    this.titleSpacing = 0,
    this.titleVariant = AppPageBarTitleVariant.textOnly,
    this.titleIcon,
    this.titleIconColor,
    this.titleIconSize = 22,
    this.titleImage,
    this.titleGap = 8,
    this.actions,
    this.topMargin = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bar = AppBar(
      elevation: elevation ?? 0,
      shadowColor: AppColors.black,
      scrolledUnderElevation: 0,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor,
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
      title: _buildTitle(context),
      actions: actions,
    );

    if (topMargin == 0) return bar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: topMargin, color: backgroundColor),
        bar,
      ],
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (title == null) return null;

    final textWidget = AppText(
      title!,
      variant: AppTextVariant.titleMedium,
      fontWeight: FontWeight.w600,
    );

    switch (titleVariant) {
      case AppPageBarTitleVariant.textOnly:
        return textWidget;

      case AppPageBarTitleVariant.withIcon:
        assert(
          titleIcon != null,
          'titleIcon harus diisi saat menggunakan AppPageBarTitleVariant.withIcon',
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              titleIcon,
              size: titleIconSize,
              color: titleIconColor ?? AppColors.primary500,
            ),
            SizedBox(width: titleGap),
            textWidget,
          ],
        );

      case AppPageBarTitleVariant.withImage:
        assert(
          titleImage != null,
          'titleImage harus diisi saat menggunakan AppPageBarTitleVariant.withImage',
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            titleImage!,
            SizedBox(width: titleGap),
            textWidget,
          ],
        );
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + topMargin);
}
