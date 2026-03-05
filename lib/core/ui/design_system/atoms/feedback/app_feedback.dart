import 'package:flutter/material.dart';

// AppLoader
class AppLoader extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const AppLoader({
    super.key,
    this.size = 36,
    this.color,
    this.message,
  });

  const AppLoader.small({super.key, this.color, this.message}) : size = 20;
  const AppLoader.large({super.key, this.color, this.message}) : size = 56;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: size,
          child: CircularProgressIndicator(
            color: color ?? Theme.of(context).colorScheme.primary,
            strokeWidth: size < 30 ? 2 : 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

// AppProgressIndicator
class AppProgressIndicator extends StatelessWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;

  const AppProgressIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.height = 4,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? Theme.of(context).colorScheme.primary;
    final bgColor = backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: value,
        color: progressColor,
        backgroundColor: bgColor,
        minHeight: height,
      ),
    );
  }
}

// AppSnackBar helper
class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    Color bgColor;
    switch (type) {
      case AppSnackBarType.success:
        bgColor = Colors.green.shade700;
      case AppSnackBarType.error:
        bgColor = colorScheme.error;
      case AppSnackBarType.warning:
        bgColor = Colors.orange.shade700;
      case AppSnackBarType.info:
        bgColor = colorScheme.primary;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: bgColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}

enum AppSnackBarType { success, error, warning, info }
