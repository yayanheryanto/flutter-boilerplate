import 'package:emas/core/constants/images.dart';
import 'package:emas/core/firebase/notification_handler.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacings.md,
        left: AppSpacings.md,
        right: AppSpacings.md,
        bottom: AppSpacings.md,
      ),
      child: Row(
        children: [
          AppImage(
            src: Images.emasTextIcon,
          ),
          const Spacer(),
          NotificationBadge(
            onTap: () {},
            child: AppImage(src: Images.notificationIcon),
          ),
        ],
      ),
      // ── Notification bell ─────────────────────────────────────────
    );
  }
}
