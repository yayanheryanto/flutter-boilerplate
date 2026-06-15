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
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  /// Custom bottom navigation widget. When provided, this takes full
  /// control of the bottom bar — [navigationItems] is ignored on mobile
  /// and [_MobileScaffold]'s default [NavigationBar] is skipped.
  ///
  /// Use this when the design needs something [NavigationBar] can't do
  /// (e.g. a notch for a center FAB, custom indicators, mixed item styles).
  final Widget? bottomNavigationBar;

  const AppScaffoldWrapper({
    super.key,
    required this.body,
    this.navigationItems,
    this.currentIndex = 0,
    this.onNavigationTap,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final hasCustomBottomNav = bottomNavigationBar != null;
    final hasNavigation =
        navigationItems != null && navigationItems!.isNotEmpty;

    // ── Custom bottom nav: bypass NavigationBar/NavigationRail entirely ──────
    if (hasCustomBottomNav) {
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomSheet: bottomSheet,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
      );
    }

    if (!hasNavigation) {
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
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
        floatingActionButtonLocation: floatingActionButtonLocation,
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
      floatingActionButtonLocation: floatingActionButtonLocation,
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
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomSheet;
  final Color? backgroundColor;

  const _MobileScaffold({
    this.appBar,
    required this.body,
    required this.navigationItems,
    required this.currentIndex,
    this.onNavigationTap,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomSheet,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
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
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  const _TabletScaffold({
    this.appBar,
    required this.body,
    required this.navigationItems,
    required this.currentIndex,
    this.onNavigationTap,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
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
