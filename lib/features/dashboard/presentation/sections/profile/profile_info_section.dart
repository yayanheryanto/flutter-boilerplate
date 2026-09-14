import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const _StatItem(value: '24', label: 'Total Lelang'),
          _VerticalDivider(),
          const _StatItem(value: '8', label: 'Dimenangkan'),
          _VerticalDivider(),
          const _StatItem(value: '12', label: 'Wishlist'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          AppText(
            value,
            variant: AppTextVariant.titleLarge,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFF6B00),
          ),
          const AppSpacer.xxs(),
          AppText(
            label,
            variant: AppTextVariant.labelSmall,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.black.withOpacity(0.08),
    );
  }
}
