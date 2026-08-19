import 'dart:async';

import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:flutter/material.dart';

// ─── Toast Type ───────────────────────────────────────────────────────────────

enum AppToastType { info, success, warning, error }

enum AppToastPosition { top, center, bottom }

// ─── Toast Entry Model ────────────────────────────────────────────────────────

class _ToastEntry {
  final String message;
  final AppToastType type;
  final AppToastPosition position;
  final Duration duration;
  final OverlayEntry entry;

  _ToastEntry({
    required this.message,
    required this.type,
    required this.position,
    required this.duration,
    required this.entry,
  });
}

// ─── AppToast ─────────────────────────────────────────────────────────────────

/// Pure overlay toast — no Scaffold/BuildContext needed after app init.
///
/// ## Setup (already done via AppNavigator in AppRouter — nothing extra needed)
/// AppToast uses [AppNavigator.navigatorKey] which is the same key registered
/// in GoRouter. No separate key setup required.
///
/// ## Usage (anywhere — widgets, blocs, services)
/// ```dart
/// AppToast.success('Saved!');
/// AppToast.error('Network error', position: AppToastPosition.top);
/// AppToast.warning('Unsaved changes');
/// AppToast.info('Session expires soon');
/// AppToast.show('Custom', type: AppToastType.info, duration: Duration(seconds: 4));
/// ```
class AppToast {
  AppToast._();

  // Uses AppNavigator.navigatorKey — no separate key needed.
  static OverlayState? get _overlay => AppNavigator.navigatorKey.currentState?.overlay;

  static final List<_ToastEntry> _queue = [];
  static bool _isShowing = false;

  // ── Named shortcuts ─────────────────────────────────────────────────────────

  static void success(
    String message, {
    AppToastPosition position = AppToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(
        message,
        type: AppToastType.success,
        position: position,
        duration: duration,
      );

  static void error(
    String message, {
    AppToastPosition position = AppToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(
        message,
        type: AppToastType.error,
        position: position,
        duration: duration,
      );

  static void warning(
    String message, {
    AppToastPosition position = AppToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
  }) =>
      show(
        message,
        type: AppToastType.warning,
        position: position,
        duration: duration,
      );

  static void info(
    String message, {
    AppToastPosition position = AppToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
  }) =>
      show(message, position: position, duration: duration);

  // ── Core show ───────────────────────────────────────────────────────────────

  static void show(
    String message, {
    AppToastType type = AppToastType.info,
    AppToastPosition position = AppToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
    IconData? customIcon,
  }) {
    final overlay = _overlay;
    if (overlay == null) {
      // Navigator not ready yet — schedule for next frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        show(
          message,
          type: type,
          position: position,
          duration: duration,
          customIcon: customIcon,
        );
      });
      return;
    }

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        type: type,
        position: position,
      ),
    );

    final toastEntry = _ToastEntry(
      message: message,
      type: type,
      position: position,
      duration: duration,
      entry: entry,
    );

    _queue.add(toastEntry);
    if (!_isShowing) _showNext(overlay);
  }

  static void _showNext(OverlayState overlay) {
    if (_queue.isEmpty) {
      _isShowing = false;
      return;
    }

    _isShowing = true;
    final current = _queue.removeAt(0);
    overlay.insert(current.entry);

    Timer(current.duration, () {
      try {
        current.entry.remove();
      } catch (_) {}
      _showNext(overlay);
    });
  }
}

// ─── Toast Widget ─────────────────────────────────────────────────────────────

class _ToastWidget extends StatefulWidget {
  final String message;
  final AppToastType type;
  final AppToastPosition position;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.position,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    final begin = widget.position == AppToastPosition.top
        ? const Offset(
            0,
            -0.4,
          )
        : const Offset(
            0,
            0.4,
          );

    _slide = Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (Color, IconData) _style() {
    switch (widget.type) {
      case AppToastType.success:
        return (Colors.green.shade700, Icons.check_circle_outline_rounded);
      case AppToastType.error:
        return (Colors.red.shade700, Icons.error_outline_rounded);
      case AppToastType.warning:
        return (Colors.orange.shade700, Icons.warning_amber_rounded);
      case AppToastType.info:
        return (Colors.blueGrey.shade700, Icons.info_outline_rounded);
    }
  }

  AlignmentGeometry get _alignment {
    switch (widget.position) {
      case AppToastPosition.top:
        return Alignment.topCenter;
      case AppToastPosition.center:
        return Alignment.center;
      case AppToastPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  EdgeInsets get _margin {
    switch (widget.position) {
      case AppToastPosition.top:
        return const EdgeInsets.only(top: 60);
      case AppToastPosition.center:
        return EdgeInsets.zero;
      case AppToastPosition.bottom:
        return const EdgeInsets.only(bottom: 80);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bgColor, iconData) = _style();

    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: _alignment,
          child: Padding(
            padding: _margin,
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _opacity,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacings.xl),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacings.md,
                      vertical: AppSpacings.sm + 2,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(RadiusTokens.full),
                      boxShadow: [
                        BoxShadow(
                          color: bgColor.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(iconData, color: Colors.white, size: 18),
                        const SizedBox(width: AppSpacings.sm),
                        Flexible(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
