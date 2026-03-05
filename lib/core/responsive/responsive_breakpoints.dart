class ResponsiveBreakpoints {
  ResponsiveBreakpoints._();

  /// Compact: Small phones - < 600dp
  static const double compact = 600;

  /// Medium: Large phones & Tablet portrait - 600dp - 1024dp
  static const double medium = 1024;

  /// Expanded: Tablet landscape & Desktop - > 1024dp
  // static const double expanded = 1024; // everything above medium
}

enum DeviceType {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == DeviceType.mobile;
  bool get isTablet => this == DeviceType.tablet;
  bool get isDesktop => this == DeviceType.desktop;
}

enum ScreenSize {
  compact,
  medium,
  expanded;

  bool get isCompact => this == ScreenSize.compact;
  bool get isMedium => this == ScreenSize.medium;
  bool get isExpanded => this == ScreenSize.expanded;
}
