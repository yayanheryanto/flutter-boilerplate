import 'package:boilerplate/core/constants/tokens/radius_tokens.dart';
import 'package:boilerplate/core/constants/tokens/spacing_tokens.dart';
import 'package:boilerplate/shared/widgets/display/app_display.dart';
import 'package:boilerplate/shared/widgets/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';
import 'package:boilerplate/features/dashboard/presentation/widgets/home/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _categories = [
  (cat: AuctionCategory.motor),
  (cat: AuctionCategory.mobil),
  (cat: AuctionCategory.elektronik),
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
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: SpacingTokens.sm,
              crossAxisSpacing: SpacingTokens.sm,
              childAspectRatio: 1.1,
            ),
            itemCount: _categories.length,
            itemBuilder: (_, i) => _CategoryCard(category: _categories[i].cat),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final AuctionCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = category.color;

    return AppCard(
      onTap: () async => context.pushNamed(
        'category-detail',
        pathParameters: {'slug': category.slug},
      ),
      padding: const EdgeInsets.all(SpacingTokens.sm),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                ),
                child: Center(
                  // Emoji requires raw Text with explicit fontSize — AppText
                  // maps to TextTheme variants which don't expose raw fontSize.
                  child: Text(category.emoji, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const AppSpacer.xs(),
              AppText(
                category.label,
                variant: AppTextVariant.labelMedium,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
