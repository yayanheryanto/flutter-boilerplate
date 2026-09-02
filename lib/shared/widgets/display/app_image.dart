import 'package:cached_network_image/cached_network_image.dart';
import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

// ─── Source type (auto-detected dari path/url) ────────────────────────────────

enum _ImageSourceType { network, localAsset, localSvg, networkSvg, unknown }

_ImageSourceType _detectSource(String? src) {
  if (src == null || src.isEmpty) return _ImageSourceType.unknown;
  final lower = src.toLowerCase();
  final isSvg = lower.endsWith('.svg');
  final isNetwork = lower.startsWith('http://') || lower.startsWith('https://');
  if (isNetwork && isSvg) return _ImageSourceType.networkSvg;
  if (isNetwork) return _ImageSourceType.network;
  if (isSvg) return _ImageSourceType.localSvg;
  return _ImageSourceType.localAsset;
}

// ─── AppImage ─────────────────────────────────────────────────────────────────

/// Widget gambar serbaguna yang mendukung:
/// - **Network image** (http/https) dengan cache via `cached_network_image`
/// - **Network SVG** (http/https + .svg) via `flutter_svg`
/// - **Local asset image** (png/jpg/webp/gif)
/// - **Local asset SVG** (.svg)
///
/// Semua tipe menampilkan **shimmer skeleton** saat loading dan
/// **error placeholder** saat gagal.
///
/// ### Contoh penggunaan
/// ```dart
/// // Network image
/// AppImage(src: 'https://example.com/photo.jpg', height: 200)
///
/// // Network SVG
/// AppImage(src: 'https://example.com/icon.svg', width: 48, height: 48)
///
/// // Local asset image
/// AppImage(src: 'assets/images/png/banner.png', width: double.infinity)
///
/// // Local SVG dengan tint
/// AppImage(
///   src: 'assets/images/svg/home.svg',
///   width: 24, height: 24,
///   svgColorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
/// )
///
/// // Dengan border radius kustom
/// AppImage(
///   src: 'https://example.com/photo.jpg',
///   height: 160,
///   borderRadius: BorderRadius.circular(RadiusTokens.xl),
/// )
///
/// // Circular (avatar)
/// AppImage(src: 'https://example.com/avatar.jpg', width: 56, height: 56, circle: true)
/// ```
class AppImage extends StatelessWidget {
  /// URL (http/https) atau path asset lokal.
  /// Tipe sumber dideteksi otomatis dari nilai ini.
  final String? src;

  final double? width;
  final double? height;
  final BoxFit fit;

  /// Border radius kustom. Diabaikan jika [circle] = true.
  final BorderRadius? borderRadius;

  /// Radius default saat [borderRadius] null. Default [RadiusTokens.md].
  final double defaultRadius;

  /// Jika true, gambar ditampilkan dalam bentuk lingkaran penuh.
  final bool circle;

  /// Widget kustom saat loading. Default: shimmer skeleton.
  final Widget? loadingWidget;

  /// Widget kustom saat error / src kosong. Default: icon broken image.
  final Widget? errorWidget;

  // ── SVG-specific ────────────────────────────────────────────────────────────

  /// Tint warna untuk SVG (local & network).
  /// Contoh: `ColorFilter.mode(AppColors.primary500, BlendMode.srcIn)`
  final ColorFilter? svgColorFilter;

  /// Warna placeholder SVG saat loading (network SVG).
  final Color? svgPlaceholderColor;

  // ── Network-specific ────────────────────────────────────────────────────────

  /// Header HTTP tambahan untuk network image.
  final Map<String, String>? httpHeaders;

  /// Maksimum lebar cache (px). Default 800 untuk menghemat memori.
  final int? maxWidthDiskCache;

  const AppImage({
    super.key,
    this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.defaultRadius = 0,
    this.circle = false,
    this.loadingWidget,
    this.errorWidget,
    this.svgColorFilter,
    this.svgPlaceholderColor,
    this.httpHeaders,
    this.maxWidthDiskCache = 800,
  });

  // ── Named constructors ──────────────────────────────────────────────────────

  /// Shorthand untuk avatar lingkaran.
  const AppImage.circle({
    super.key,
    this.src,
    required double size,
    this.fit = BoxFit.cover,
    this.loadingWidget,
    this.errorWidget,
    this.svgColorFilter,
    this.svgPlaceholderColor,
    this.httpHeaders,
    this.maxWidthDiskCache = 400,
  })  : width = size,
        height = size,
        circle = true,
        borderRadius = null,
        defaultRadius = RadiusTokens.full;

  /// Shorthand untuk icon SVG kecil dengan tint.
  const AppImage.svgIcon({
    super.key,
    required this.src,
    required double size,
    this.svgColorFilter,
    this.loadingWidget,
    this.errorWidget,
    this.svgPlaceholderColor,
    this.httpHeaders,
    this.maxWidthDiskCache,
  })  : width = size,
        height = size,
        fit = BoxFit.contain,
        circle = false,
        borderRadius = BorderRadius.zero,
        defaultRadius = 0;

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final clip = _resolveClip();
    final type = _detectSource(src);

    Widget child;

    switch (type) {
      case _ImageSourceType.network:
        child = _buildNetworkImage(context);
      case _ImageSourceType.networkSvg:
        child = _buildNetworkSvg(context);
      case _ImageSourceType.localSvg:
        child = _buildLocalSvg(context);
      case _ImageSourceType.localAsset:
        child = _buildLocalAsset(context);
      case _ImageSourceType.unknown:
        child = _buildError(context);
    }

    return ClipRRect(borderRadius: clip, child: child);
  }

  // ── Network raster ──────────────────────────────────────────────────────────

  Widget _buildNetworkImage(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: src!,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: httpHeaders,
      maxWidthDiskCache: maxWidthDiskCache,
      placeholder: (_, __) => loadingWidget ?? _buildShimmer(context),
      errorWidget: (_, __, ___) => errorWidget ?? _buildError(context),
    );
  }

  // ── Network SVG ─────────────────────────────────────────────────────────────

  Widget _buildNetworkSvg(BuildContext context) {
    return SvgPicture.network(
      src!,
      width: width,
      height: height,
      fit: fit,
      headers: httpHeaders,
      colorFilter: svgColorFilter,
      placeholderBuilder: (_) => loadingWidget ?? _buildShimmer(context),
    );
  }

  // ── Local SVG ───────────────────────────────────────────────────────────────

  Widget _buildLocalSvg(BuildContext context) {
    return SvgPicture.asset(
      src!,
      width: width,
      height: height,
      fit: fit,
      colorFilter: svgColorFilter,
      placeholderBuilder: (_) => loadingWidget ?? _buildShimmer(context),
    );
  }

  // ── Local asset raster ──────────────────────────────────────────────────────

  Widget _buildLocalAsset(BuildContext context) {
    return Image.asset(
      src!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => errorWidget ?? _buildError(context),
      frameBuilder: (_, child, frame, wasSynced) {
        if (wasSynced || frame != null) return child;
        return loadingWidget ?? _buildShimmer(context);
      },
    );
  }

  // ── Skeleton shimmer ────────────────────────────────────────────────────────

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlight = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: width,
        height: height,
        color: base,
      ),
    );
  }

  // ── Error placeholder ───────────────────────────────────────────────────────

  Widget _buildError(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppColors.neutral100,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: _iconSize(),
          color: AppColors.neutral400,
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  BorderRadius _resolveClip() {
    if (circle) {
      final size = width ?? height ?? 40;
      return BorderRadius.circular(size / 2);
    }
    return borderRadius ?? BorderRadius.circular(defaultRadius);
  }

  double _iconSize() {
    final dim = (width ?? 0).clamp(0, height ?? 0);
    if (dim == 0) return 24;
    return (dim * 0.35).clamp(16, 48).toDouble();
  }
}
