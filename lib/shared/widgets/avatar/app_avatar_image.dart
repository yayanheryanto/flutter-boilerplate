import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppAvatarImageType { png, svg }

class AppAvatarImage extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? backgroundColor;
  final BoxFit fit;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final AppAvatarImageType type;
  final Color? svgColor; // override warna SVG jika perlu

  const AppAvatarImage({
    super.key,
    required this.assetPath,
    this.size = 44,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.type = AppAvatarImageType.png,
    this.svgColor,
  }) : assert(
          shape != BoxShape.rectangle || borderRadius != null,
          'borderRadius required when shape is rectangle',
        );

  /// Auto-detect type dari ekstensi file
  AppAvatarImage.auto({
    super.key,
    required this.assetPath,
    this.size = 44,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.shape = BoxShape.circle,
    this.borderRadius,
    this.svgColor,
  }) : type = assetPath.endsWith('.svg') // ← tidak bisa di const, lihat note
            ? AppAvatarImageType.svg
            : AppAvatarImageType.png;

  bool get _isSvg => type == AppAvatarImageType.svg || assetPath.endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
      ),
      child: ClipRRect(
        borderRadius: shape == BoxShape.circle ? BorderRadius.circular(size / 2) : (borderRadius ?? BorderRadius.zero),
        child: _isSvg ? _buildSvg() : _buildPng(),
      ),
    );
  }

  Widget _buildSvg() {
    return SvgPicture.asset(
      assetPath,
      fit: fit,
      width: size,
      height: size,
      colorFilter: svgColor != null ? ColorFilter.mode(svgColor!, BlendMode.srcIn) : null,
      placeholderBuilder: (_) => _fallback(),
    );
  }

  Widget _buildPng() {
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Icon(
      Icons.person,
      size: size * 0.5,
      color: Colors.grey,
    );
  }
}
