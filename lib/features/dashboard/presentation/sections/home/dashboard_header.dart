import 'package:emas/core/firebase/notification_handler.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + SpacingTokens.md,
        left: SpacingTokens.md,
        right: SpacingTokens.md,
        bottom: SpacingTokens.md,
      ),
      child: Row(
        children: [
          // ── EMAS logo ─────────────────────────────────────────────────
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'EMAS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary500,
                  letterSpacing: 1.5,
                  height: 1.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Powered by ',
                    style: TextStyle(fontSize: 9, color: Colors.grey),
                  ),
                  // Mega Finance logo text
                  Text(
                    'M',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    ' MEGAFINANCE',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // ── Notification bell ─────────────────────────────────────────
          NotificationBadge(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary500,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
