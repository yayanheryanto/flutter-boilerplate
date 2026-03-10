import 'package:boilerplate/core/firebase/notification_handler.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/input/app_text_field.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + SpacingTokens.sm,
        left: SpacingTokens.md,
        right: SpacingTokens.md,
        bottom: SpacingTokens.md,
      ),
      color: scheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              AppAvatar(initials: 'B', size: 44),
              const AppSpacer(SpacingTokens.sm, horizontal: true),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Halo, Budi! 👋',
                      variant: AppTextVariant.titleMedium,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      'Temukan penawaran terbaik hari ini',
                      variant: AppTextVariant.bodySmall,
                      color: scheme.onSurface.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              NotificationBadge(
                onTap: () {},
                child: const Icon(Icons.notifications_outlined),
              ),
            ],
          ),
          const AppSpacer.md(),
          // AppSearchField(
          //   hint: 'Cari motor, mobil, elektronik...',
          //   onChanged: (_) {},
          // ),
        ],
      ),
    );
  }
}
