import 'package:flutter/material.dart';

import 'package:emas/core/responsive/responsive_context_extension.dart';

/// Responsive grid that adapts columns based on screen size
class AppResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const AppResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive(
      mobile: mobileColumns ?? 1,
      tablet: tabletColumns ?? 2,
      desktop: desktopColumns ?? 4,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (_, index) => children[index],
    );
  }
}

/// Responsive row that wraps children based on screen size
class AppResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAlignment;

  const AppResponsiveRow({
    super.key,
    required this.children,
    this.spacing = 16,
    this.alignment = WrapAlignment.start,
    this.crossAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      alignment: alignment,
      crossAxisAlignment: crossAlignment,
      children: children,
    );
  }
}

/// A column that takes a fraction of available width based on responsive config
class AppResponsiveColumn extends StatelessWidget {
  final Widget child;
  final int mobileFlex;
  final int tabletFlex;
  final int desktopFlex;
  final int totalColumns;

  const AppResponsiveColumn({
    super.key,
    required this.child,
    this.mobileFlex = 12,
    this.tabletFlex = 6,
    this.desktopFlex = 3,
    this.totalColumns = 12,
  });

  @override
  Widget build(BuildContext context) {
    final flex = context.responsive(
      mobile: mobileFlex,
      tablet: tabletFlex,
      desktop: desktopFlex,
    );

    final screenWidth = context.screenWidth;
    final width = screenWidth * (flex / totalColumns);

    return SizedBox(width: width, child: child);
  }
}
