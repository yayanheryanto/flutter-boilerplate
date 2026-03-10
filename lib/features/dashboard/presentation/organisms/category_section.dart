import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/section_header.dart';
import 'package:flutter/material.dart';

const _categories = [
  (emoji: '🏍️', label: 'Motor'),
  (emoji: '🚗', label: 'Mobil'),
  (emoji: '📱', label: 'Elektronik'),
];

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(title: 'Kategori', onSeeAll: () {}),
        const AppSpacer.sm(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
          child: Row(
            children: _categories
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.xs,
                      ),
                      child: _CategoryItem(
                        emoji: c.emoji,
                        label: c.label,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String emoji;
  final String label;

  const _CategoryItem({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 34)),
            ),
          ),
          const AppSpacer.xs(),
          AppText(
            label,
            variant: AppTextVariant.labelMedium,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
