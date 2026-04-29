import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:boilerplate/core/constants/tokens/radius_tokens.dart';

// AppImage
class AppImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(RadiusTokens.md);

    if (url == null || url!.isEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: errorWidget ?? _buildPlaceholder(context),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => placeholder ?? _buildShimmer(context),
        errorWidget: (_, __, ___) =>
        errorWidget ?? _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) => Container(
    width: width,
    height: height,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
  );

  Widget _buildPlaceholder(BuildContext context) => Container(
    width: width,
    height: height,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: const Icon(Icons.image_outlined),
  );
}
