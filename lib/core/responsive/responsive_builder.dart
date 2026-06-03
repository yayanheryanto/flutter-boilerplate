import 'package:flutter/material.dart';

import 'package:emas/core/responsive/responsive_breakpoints.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';

/// Builds different layouts based on device type
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, context.deviceType);
  }
}

/// Provides mobile/tablet/desktop layout options
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop && desktop != null) return desktop!;
    if (context.isTablet && tablet != null) return tablet!;
    return mobile;
  }
}

/// Wraps content with responsive max-width and centering
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool center;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    final maxW = maxWidth ?? context.contentMaxWidth;

    if (maxW != double.infinity) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: content,
        ),
      );
    }

    return content;
  }
}
