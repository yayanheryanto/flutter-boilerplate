import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Varian tampilan judul pada [AppPageBar].
enum AppPageBarTitleVariant {
  /// Hanya teks judul biasa (default — tidak breaking behaviour lama).
  textOnly,

  /// Icon Material di kiri judul.
  /// Butuh [titleIcon] diisi.
  withIcon,

  /// Widget image/svg kustom di kiri judul.
  /// Butuh [titleImage] diisi.
  withImage,
}

/// AppBar standar aplikasi.
///
/// ### Penggunaan dasar (tidak berubah dari versi lama)
/// ```dart
/// AppPageBar(title: 'Detail')
/// AppPageBar(showBackButton: false)
/// AppPageBar(title: 'Verifikasi', onBack: () => context.pop())
/// ```
///
/// ### Dengan icon Material di kiri judul
/// ```dart
/// AppPageBar(
///   title: 'Ikut Lelang',
///   titleVariant: AppPageBarTitleVariant.withIcon,
///   titleIcon: Icons.gavel_rounded,
///   showBackButton: false,
/// )
/// ```
///
/// ### Dengan widget gambar kustom di kiri judul
/// ```dart
/// AppPageBar(
///   title: 'Beranda',
///   titleVariant: AppPageBarTitleVariant.withImage,
///   titleImage: SvgPicture.asset('assets/logo.svg', width: 24, height: 24),
///   showBackButton: false,
/// )
/// ```
///
/// ### Dengan action button di kanan
/// ```dart
/// AppPageBar(
///   title: 'Profil',
///   actions: [
///     IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
///   ],
/// )
/// ```
class AppPageBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color backgroundColor;
  final bool showBackButton;
  final VoidCallback? onBack;
  final double? elevation;
  final double? titleSpacing;

  /// Varian tampilan judul. Default [AppPageBarTitleVariant.textOnly].
  final AppPageBarTitleVariant titleVariant;

  /// Icon Material yang muncul di kiri teks judul.
  /// Hanya aktif saat [titleVariant] == [AppPageBarTitleVariant.withIcon].
  final IconData? titleIcon;

  /// Warna icon judul. Default [AppColors.primary500].
  final Color? titleIconColor;

  /// Ukuran icon judul. Default 22.
  final double titleIconSize;

  /// Widget gambar/svg kustom di kiri teks judul.
  /// Hanya aktif saat [titleVariant] == [AppPageBarTitleVariant.withImage].
  final Widget? titleImage;

  /// Jarak antara icon/image dan teks judul. Default 8.
  final double titleGap;

  /// Action widget di sisi kanan AppBar (sama seperti [AppBar.actions]).
  final List<Widget>? actions;

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}