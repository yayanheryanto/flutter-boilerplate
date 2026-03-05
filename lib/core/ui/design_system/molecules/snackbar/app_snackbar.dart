import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:flutter/material.dart';

// ─── AppSnackbar ──────────────────────────────────────────────────────────────

enum AppSnackbarType { info, success, warning, error }

/// Centralised snackbar helper. Call from anywhere with a [BuildContext].
///
/// ```dart
/// AppSnackbar.show(context, 'Saved successfully', type: AppSnackbarType.success);
/// AppSnackbar.success(context, 'Profile updated');
/// AppSnackbar.error(context, 'Something went wrong');
/// AppSnackbar.warning(context, 'You have unsaved changes');
/// ```
class AppSnackbar {
  AppSnackbar._();

  // ── Named constructors ──────────────────────────────────────────────────────

  static void success(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(
        context,
        message,
        type: AppSnackbarType.success,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void error(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) =>
      show(
        context,
        message,
        type: AppSnackbarType.error,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void warning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(
        context,
        message,
        type: AppSnackbarType.warning,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  static void info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(
        context,
        message,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      );

  // ── Core show method ────────────────────────────────────────────────────────

  static void show(
    BuildContext context,
    String message, {
    AppSnackbarType type = AppSnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    bool showIcon = true,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final (bgColor, iconData) = _style(context, type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        margin: const EdgeInsets.all(SpacingTokens.md),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.sm + 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.md),
        ),
        content: Row(
          children: [
            if (showIcon) ...[
              Icon(iconData, color: Colors.white, size: 20),
              const SizedBox(width: SpacingTokens.sm),
            ],
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
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

  static (Color, IconData) _style(BuildContext context, AppSnackbarType type) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case AppSnackbarType.success:
        return (Colors.green.shade700, Icons.check_circle_outline_rounded);
      case AppSnackbarType.error:
        return (scheme.error, Icons.error_outline_rounded);
      case AppSnackbarType.warning:
        return (Colors.orange.shade700, Icons.warning_amber_rounded);
      case AppSnackbarType.info:
        return (scheme.primary, Icons.info_outline_rounded);
    }
  }
}
