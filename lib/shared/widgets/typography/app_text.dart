import 'package:flutter/material.dart';

enum AppTextVariant {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextVariant variant;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final double? height;

  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = _getTextStyle(context);
    final style = baseStyle?.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize ?? baseStyle.fontSize,
      height: height,
    );

    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    switch (variant) {
      case AppTextVariant.displayLarge:
        return theme.displayLarge;
      case AppTextVariant.displayMedium:
        return theme.displayMedium;
      case AppTextVariant.displaySmall:
        return theme.displaySmall;
      case AppTextVariant.headlineLarge:
        return theme.headlineLarge;
      case AppTextVariant.headlineMedium:
        return theme.headlineMedium;
      case AppTextVariant.headlineSmall:
        return theme.headlineSmall;
      case AppTextVariant.titleLarge:
        return theme.titleLarge;
      case AppTextVariant.titleMedium:
        return theme.titleMedium;
      case AppTextVariant.titleSmall:
        return theme.titleSmall;
      case AppTextVariant.bodyLarge:
        return theme.bodyLarge;
      case AppTextVariant.bodyMedium:
        return theme.bodyMedium;
      case AppTextVariant.bodySmall:
        return theme.bodySmall;
      case AppTextVariant.labelLarge:
        return theme.labelLarge;
      case AppTextVariant.labelMedium:
        return theme.labelMedium;
      case AppTextVariant.labelSmall:
        return theme.labelSmall;
    }
  }
}

class AppRichText extends StatelessWidget {
  final List<InlineSpan> children;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const AppRichText({
    super.key,
    required this.children,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: children),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}

class AppLinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final AppTextVariant variant;
  final Color? color;

  const AppLinkText(
    this.text, {
    super.key,
    required this.onTap,
    this.variant = AppTextVariant.bodyMedium,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppText(
        text,
        variant: variant,
        color: color ?? Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
