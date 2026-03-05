import 'package:flutter/material.dart';

import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isExpanded;
  final double? width;

  /// When true, overrides button color to error/danger regardless of [variant].
  /// Used internally by AppConfirmDialog.
  final bool dangerOverride;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isExpanded = true,
    this.width,
    this.dangerOverride = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonChild = _buildChild(context);

    if (isExpanded) {
      buttonChild = SizedBox(width: double.infinity, child: buttonChild);
    } else if (width != null) {
      buttonChild = SizedBox(width: width, child: buttonChild);
    } else {
      // isExpanded: false tanpa explicit width → biarkan button
      // mengikuti ukuran kontennya (intrinsic width).
      buttonChild = IntrinsicWidth(child: buttonChild);
    }

    return buttonChild;
  }

  Widget _buildChild(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = _getHeight();
    final style = _buildStyle(context, colorScheme);
    final content = _buildContent(context);

    switch (variant) {
      case AppButtonVariant.outlined:
        return SizedBox(
          height: height,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: content,
          ),
        );
      case AppButtonVariant.text:
        return SizedBox(
          height: height,
          child: TextButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: content,
          ),
        );
      default:
        return SizedBox(
          height: height,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: content,
          ),
        );
    }
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  ButtonStyle _buildStyle(BuildContext context, ColorScheme colorScheme) {
    final radius = BorderRadius.circular(RadiusTokens.md);

    // dangerOverride wins over variant
    if (dangerOverride || variant == AppButtonVariant.danger) {
      return ElevatedButton.styleFrom(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
        shape: RoundedRectangleBorder(borderRadius: radius),
      );
    }

    switch (variant) {
      case AppButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.onSurface,
          shape: RoundedRectangleBorder(borderRadius: radius),
          elevation: 0,
        );
      case AppButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: radius),
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: radius),
        );
      default:
        return ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: radius),
        );
    }
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final children = <Widget>[];

    if (prefixIcon != null) {
      children.add(Icon(prefixIcon, size: 18));
      children.add(const SizedBox(width: SpacingTokens.xs));
    }

    children.add(Text(label));

    if (suffixIcon != null) {
      children.add(const SizedBox(width: SpacingTokens.xs));
      children.add(Icon(suffixIcon, size: 18));
    }

    if (children.length == 1) return children.first;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      onPressed: onPressed,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      tooltip: tooltip,
    );
  }
}

class AppFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final bool mini;

  const AppFAB({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label!),
      );
    }
    if (mini) {
      return FloatingActionButton.small(
        onPressed: onPressed,
        child: Icon(icon),
      );
    }
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
