import 'package:emas/core/constants/images.dart';
import 'package:emas/core/firebase/notification_handler.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + Spacings.md,
        left: Spacings.md,
        right: Spacings.md,
        bottom: Spacings.md,
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
