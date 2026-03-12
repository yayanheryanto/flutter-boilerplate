import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/profile/profile_header.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/profile/profile_info_section.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/profile/profile_logout_button.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/profile/profile_menu_section.dart';
import 'package:flutter/material.dart';

/// Profile layout templates for different devices.
///
/// - [MobileProfileTemplate] : single-column scroll layout.
/// - [TabletProfileTemplate]  : two-column layout for wider screens.

class MobileProfileTemplate extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const MobileProfileTemplate({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          const SliverToBoxAdapter(child: ProfileHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: context.responsivePadding,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileInfoSection(),
                  AppSpacer.md(),
                  ProfileMenuSection(),
                  AppSpacer.lg(),
                  ProfileLogoutButton(),
                  AppSpacer.xl(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabletProfileTemplate extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const TabletProfileTemplate({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          const SliverToBoxAdapter(child: ProfileHeader()),
          SliverToBoxAdapter(
            child: Padding(
              padding: context.responsivePadding,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileInfoSection(),
                            AppSpacer.md(),
                            ProfileLogoutButton(),
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        flex: 6,
                        child: ProfileMenuSection(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
