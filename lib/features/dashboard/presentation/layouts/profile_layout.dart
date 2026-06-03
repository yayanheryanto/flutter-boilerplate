import 'package:emas/core/responsive/responsive_builder.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/features/dashboard/presentation/sections/profile/profile_header.dart';
import 'package:emas/features/dashboard/presentation/sections/profile/profile_info_section.dart';
import 'package:emas/features/dashboard/presentation/widgets/profile/profile_logout_button.dart';
import 'package:emas/features/dashboard/presentation/sections/profile/profile_menu_section.dart';
import 'package:flutter/material.dart';

/// Responsive profile-tab layout.
///
/// - Mobile  : single-column scroll.
/// - Tablet/Desktop : two-column grid.
class ProfileLayout extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const ProfileLayout({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      mobile: _MobileProfileLayout(onRefresh: onRefresh),
      tablet: _TabletProfileLayout(onRefresh: onRefresh),
      desktop: _TabletProfileLayout(onRefresh: onRefresh),
    );
  }
}

// ── Mobile layout ──────────────────────────────────────────────────────────────

class _MobileProfileLayout extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _MobileProfileLayout({required this.onRefresh});

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

// ── Tablet / Desktop layout ────────────────────────────────────────────────────

class _TabletProfileLayout extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _TabletProfileLayout({required this.onRefresh});

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
