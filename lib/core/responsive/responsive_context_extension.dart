import 'package:flutter/material.dart';

import 'package:emas/core/responsive/responsive_breakpoints.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < ResponsiveBreakpoints.compact;
  bool get isTablet =>
      screenWidth >= ResponsiveBreakpoints.compact &&
      screenWidth < ResponsiveBreakpoints.medium;
  bool get isDesktop => screenWidth >= ResponsiveBreakpoints.medium;

  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  ScreenSize get screenSize {
    if (screenWidth < ResponsiveBreakpoints.compact) return ScreenSize.compact;
    if (screenWidth < ResponsiveBreakpoints.medium) return ScreenSize.medium;
    return ScreenSize.expanded;
  }

  /// Returns value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Responsive padding
  EdgeInsets get responsivePadding => EdgeInsets.symmetric(
        horizontal: responsive(mobile: 16, tablet: 24, desktop: 32),
        vertical: responsive(mobile: 16, tablet: 20, desktop: 24),
      );

  /// Responsive max-width container
  double get contentMaxWidth => responsive(
        mobile: double.infinity,
        tablet: 720.0,
        desktop: 1200.0,
      );

  /// Responsive grid columns
  int get gridColumns => responsive(mobile: 1, tablet: 2, desktop: 4);

  /// Responsive font scale
  double get fontScale => responsive(mobile: 1.0, tablet: 1.05, desktop: 1.1);
}
