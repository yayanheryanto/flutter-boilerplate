import 'package:boilerplate/core/firebase/notification_handler.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + SpacingTokens.md,
        left: SpacingTokens.md,
        right: SpacingTokens.md,
        bottom: SpacingTokens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppAvatar(initials: 'B'),
              const AppSpacer(SpacingTokens.sm, horizontal: true),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Selamat pagi 👋',
                      variant: AppTextVariant.labelSmall,
                      color: scheme.onSurface.withOpacity(0.45),
                    ),
                    const AppText(
                      'Taro Misaki',
                      variant: AppTextVariant.titleSmall,
                      fontWeight: FontWeight.w700,
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
          // const AppSpacer.md(),
          // AppSearchField(
          //   hint: 'Cari barang lelang...',
          //   onChanged: (_) {},
          // ),
        ],
      ),
    );
  }
}
