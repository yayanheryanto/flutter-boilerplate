import 'package:boilerplate/core/responsive/responsive_builder.dart';
import 'package:boilerplate/features/dashboard/presentation/layouts/profile_layout.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const ProfileTab({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      mobile: MobileProfileTemplate(onRefresh: onRefresh),
      tablet: TabletProfileTemplate(onRefresh: onRefresh),
      desktop: TabletProfileTemplate(onRefresh: onRefresh),
    );
  }
}
