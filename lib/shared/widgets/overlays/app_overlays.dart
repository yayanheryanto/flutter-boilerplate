import 'dart:async';

import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:flutter/material.dart';

// ─── 1. AppBanner ─────────────────────────────────────────────────────────────

/// A non-blocking top banner backed by [MaterialBanner].
///
/// ```dart
/// AppBanner.show(context, 'New version available!', action: 'Update', onAction: update);
/// AppBanner.hide(context);
/// ```
enum AppBannerType { info, success, warning, error }

class AppBanner {
  AppBanner._();

  static Timer? _autoDismissTimer;

  static void show(
      BuildContext context,
      String message, {
        AppBannerType type = AppBannerType.info,
        String? action,
        VoidCallback? onAction,
        bool autoDismiss = false,
        Duration autoDismissDuration = const Duration(seconds: 5),
      }) {
    // Cancel any previous auto-dismiss timer
    _autoDismissTimer?.cancel();

    final (bgColor, iconData) = _style(context, type);
    final messenger = ScaffoldMessenger.of(context);

    // Always hide current before showing a new one
    messenger.hideCurrentMaterialBanner();

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacings.md,
          vertical: Spacings.sm,
        ),
        content: Row(
          children: [
            Icon(iconData, color: Colors.white, size: 20),
            const SizedBox(width: Spacings.sm),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (action != null)
            TextButton(
              onPressed: () {
                hide(context);
                onAction?.call();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: Text(action),
            ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
            onPressed: () => hide(context),
            padding: const EdgeInsets.only(right: Spacings.sm),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );

    if (autoDismiss) {
      _autoDismissTimer = Timer(autoDismissDuration, () {
        // Use a try-catch because context may no longer be mounted
        try {
          hide(context);
        } catch (_) {}
      });
    }
  }

  static void hide(BuildContext context) {
    _autoDismissTimer?.cancel();
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }

  static (Color, IconData) _style(BuildContext context, AppBannerType type) {
    final scheme = Theme.of(context).colorScheme;
    switch (type) {
      case AppBannerType.success:
        return (Colors.green.shade700, Icons.check_circle_outline_rounded);
      case AppBannerType.error:
        return (scheme.error, Icons.error_outline_rounded);
      case AppBannerType.warning:
        return (Colors.orange.shade700, Icons.warning_amber_rounded);
      case AppBannerType.info:
        return (scheme.primary, Icons.info_outline_rounded);
    }
  }
}

// ─── 2. AppProgressOverlay ────────────────────────────────────────────────────

/// Full-screen loading overlay with optional determinate progress bar.
/// Uses [AppNavigator.navigatorKey] internally — no BuildContext needed for
/// [update] and [hide] calls.
///
/// ```dart
/// AppProgressOverlay.show(context, message: 'Uploading...');
/// AppProgressOverlay.update(progress: 0.6, message: '60%');
/// AppProgressOverlay.hide();
/// ```
class AppProgressOverlay {
  AppProgressOverlay._();

  static OverlayEntry? _entry;
  static final _notifier = ValueNotifier<({double? progress, String? message})>(
    (progress: null, message: null),
  );

  static void show(
      BuildContext context, {
        String? message,
        double? progress,
      }) {
    // Remove any existing overlay first
    _entry?.remove();
    _entry = null;

    _notifier.value = (progress: progress, message: message);

    _entry = OverlayEntry(
      builder: (_) => ValueListenableBuilder(
        valueListenable: _notifier,
        builder: (ctx, value, __) => _ProgressOverlayWidget(
          progress: value.progress,
          message: value.message,
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  /// Update progress/message without needing [BuildContext].
  static void update({double? progress, String? message}) {
    _notifier.value = (progress: progress, message: message);
  }

  /// Hide the overlay. No [BuildContext] required.
  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}

class _ProgressOverlayWidget extends StatelessWidget {
  final double? progress;
  final String? message;

  const _ProgressOverlayWidget({this.progress, this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacings.xl,
            vertical: Spacings.lg,
          ),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(Rounded.xl),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (progress != null) ...[
                Text(
                  '${(progress! * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: Spacings.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                  ),
                ),
              ] else ...[
                SizedBox.square(
                  dimension: 40,
                  child: CircularProgressIndicator(strokeWidth: 3, color: scheme.primary),
                ),
              ],
              if (message != null) ...[
                const SizedBox(height: Spacings.md),
                AppText(message!, textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 3. AppTooltipWrapper ─────────────────────────────────────────────────────

/// Wraps any widget with a styled tooltip.
///
/// ```dart
/// AppTooltipWrapper(
///   message: 'This field is required',
///   child: Icon(Icons.info_outline),
/// )
/// ```
enum AppTooltipPosition { above, below }

class AppTooltipWrapper extends StatelessWidget {
  final String message;
  final Widget child;
  final AppTooltipPosition position;
  final Color? backgroundColor;

  const AppTooltipWrapper({
    super.key,
    required this.message,
    required this.child,
    this.position = AppTooltipPosition.above,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: message,
      preferBelow: position == AppTooltipPosition.below,
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.inverseSurface,
        borderRadius: BorderRadius.circular(Rounded.sm),
      ),
      textStyle: TextStyle(color: scheme.onInverseSurface, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: Spacings.sm, vertical: 6),
      child: child,
    );
  }
}

// ─── 4. AppPopover ────────────────────────────────────────────────────────────

/// A rich popover card anchored to any widget via [GlobalKey].
/// Uses [AppNavigator.navigatorKey] internally.
///
/// ```dart
/// final _key = GlobalKey();
///
/// // Somewhere in your widget tree
/// ElevatedButton(key: _key, onPressed: () => AppPopover.show(
///   context,
///   anchorKey: _key,
///   content: Text('Hello from popover!'),
/// ), child: Text('Open'))
/// ```
enum AppPopoverAnchor {
  bottomLeft,
  bottomRight,
  bottomCenter,
  topLeft,
  topRight,
  topCenter,
}

class AppPopover {
  AppPopover._();

  static OverlayEntry? _entry;

  static void show(
      BuildContext context, {
        required GlobalKey anchorKey,
        required Widget content,
        AppPopoverAnchor anchor = AppPopoverAnchor.bottomLeft,
        double maxWidth = 260,
        VoidCallback? onDismiss,
      }) {
    dismiss();

    final renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final widgetSize = renderBox.size;
    final widgetOffset = renderBox.localToGlobal(Offset.zero);
    final scheme = Theme.of(context).colorScheme;

    _entry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
          onDismiss?.call();
        },
        child: Stack(
          children: [
            Positioned(
              left: _calcLeft(anchor, widgetOffset, widgetSize, maxWidth),
              top: _calcTop(anchor, widgetOffset, widgetSize),
              child: GestureDetector(
                onTap: () {}, // absorb taps inside popover
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(Rounded.lg),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
                      ],
                      border: Border.all(color: scheme.outline.withOpacity(0.2)),
                    ),
                    padding: const EdgeInsets.all(Spacings.md),
                    child: content,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void dismiss() {
    try {
      _entry?.remove();
    } catch (_) {}
    _entry = null;
  }

  static double _calcLeft(AppPopoverAnchor a, Offset o, Size s, double max) {
    switch (a) {
      case AppPopoverAnchor.bottomLeft:
      case AppPopoverAnchor.topLeft:
        return o.dx;
      case AppPopoverAnchor.bottomRight:
      case AppPopoverAnchor.topRight:
        return (o.dx + s.width - max).clamp(0, double.infinity);
      case AppPopoverAnchor.bottomCenter:
      case AppPopoverAnchor.topCenter:
        return (o.dx + s.width / 2 - max / 2).clamp(0, double.infinity);
    }
  }

  static double _calcTop(AppPopoverAnchor a, Offset o, Size s) {
    switch (a) {
      case AppPopoverAnchor.bottomLeft:
      case AppPopoverAnchor.bottomRight:
      case AppPopoverAnchor.bottomCenter:
        return o.dy + s.height + 8;
      case AppPopoverAnchor.topLeft:
      case AppPopoverAnchor.topRight:
      case AppPopoverAnchor.topCenter:
        return o.dy - 8;
    }
  }
}

// ─── 5. AppStepperOverlay ─────────────────────────────────────────────────────

/// Onboarding coach marks / feature tour.
/// Membutuhkan [BuildContext] saat [[show]] — context di-capture dan digunakan
/// untuk semua langkah berikutnya.
///
/// ```dart
/// AppStepperOverlay.show(context, steps: [
///   AppStep(key: _menuKey, title: 'Menu', description: 'Navigate sections here'),
///   AppStep(key: _fabKey,  title: 'Create', description: 'Tap to add a new item'),
/// ]);
/// ```
class AppStep {
  final GlobalKey key;
  final String title;
  final String description;
  final AppPopoverAnchor anchor;

  const AppStep({
    required this.key,
    required this.title,
    required this.description,
    this.anchor = AppPopoverAnchor.bottomCenter,
  });
}

class AppStepperOverlay {
  AppStepperOverlay._();

  static void show(
      BuildContext context, {
        required List<AppStep> steps,
      }) {
    if (steps.isEmpty) return;
    _showStep(context, steps, 0);
  }

  static void _showStep(BuildContext context, List<AppStep> steps, int index) {
    if (index >= steps.length) return;
    final step = steps[index];
    final isLast = index == steps.length - 1;

    AppPopover.show(
      context,
      anchorKey: step.key,
      anchor: step.anchor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  step.title,
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppText(
                '${index + 1}/${steps.length}',
                variant: AppTextVariant.labelSmall,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
          const SizedBox(height: 4),
          AppText(step.description, variant: AppTextVariant.bodySmall),
          const SizedBox(height: Spacings.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!isLast)
                TextButton(
                  onPressed: AppPopover.dismiss,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Skip'),
                ),
              const SizedBox(width: 4),
              ElevatedButton(
                onPressed: () {
                  AppPopover.dismiss();
                  if (!isLast) {
                    // Re-use the same context passed in — it stays valid
                    // as long as the page is mounted.
                    Future.microtask(() => _showStep(context, steps, index + 1));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 13),
                ),
                child: Text(isLast ? 'Done' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
