import 'package:flutter/material.dart';

import 'package:emas/core/responsive/responsive_context_extension.dart';

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class AppScaffoldWrapper extends StatelessWidget {
  final Widget body;
  final List<NavigationItem>? navigationItems;
  final int currentIndex;
  final void Function(int)? onNavigationTap;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  const AppScaffoldWrapper({
    super.key,
    required this.body,
    this.navigationItems,
    this.currentIndex = 0,
    this.onNavigationTap,
    this.appBar,
    this.floatingActionButton,
    this.bottomSheet,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasNavigation =
        navigationItems != null && navigationItems!.isNotEmpty;

    if (!hasNavigation) {
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomSheet: bottomSheet,
        backgroundColor: backgroundColor,
      );
    }

    if (context.isMobile) {
      return _MobileScaffold(
        appBar: appBar,
        body: body,
        navigationItems: navigationItems!,
        currentIndex: currentIndex,
        onNavigationTap: onNavigationTap,
        floatingActionButton: floatingActionButton,
        bottomSheet: bottomSheet,
        backgroundColor: backgroundColor,
      );
    }

    return _TabletScaffold(
      appBar: appBar,
      body: body,
      navigationItems: navigationItems!,
      currentIndex: currentIndex,
      onNavigationTap: onNavigationTap,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor,
    );
  }
}

class _MobileScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<NavigationItem> navigationItems;
  final int currentIndex;
  final void Function(int)? onNavigationTap;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  const _MobileScaffold({
    this.appBar,
    required this.body,
    required this.navigationItems,
    required this.currentIndex,
    this.onNavigationTap,
    this.floatingActionButton,
    this.bottomSheet,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onNavigationTap,
        destinations: navigationItems.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class _TabletScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<NavigationItem> navigationItems;
  final int currentIndex;
  final void Function(int)? onNavigationTap;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const _TabletScaffold({
    this.appBar,
    required this.body,
    required this.navigationItems,
    required this.currentIndex,
    this.onNavigationTap,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onNavigationTap,
            labelType: NavigationRailLabelType.all,
            destinations: navigationItems.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
