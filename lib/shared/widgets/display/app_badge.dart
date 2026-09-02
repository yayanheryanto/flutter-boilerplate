import 'package:flutter/material.dart';

import 'package:emas/core/constants/radius_tokens.dart';

class AppBadge extends StatelessWidget {
  final String? label;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const AppBadge({
    super.key,
    this.label,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Theme.of(context).colorScheme.primary;
    final fg = textColor ?? Theme.of(context).colorScheme.onPrimary;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(RadiusTokens.full),
      ),
      child: label != null
          ? Text(
              label!,
              style: TextStyle(
                color: fg,
                fontSize: fontSize ?? 12,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
    );
  }
}
