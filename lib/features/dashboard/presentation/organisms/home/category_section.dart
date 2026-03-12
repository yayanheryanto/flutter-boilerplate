import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/home/section_header.dart';
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
        const SizedBox(height: SpacingTokens.sm),
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

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      child: InkWell(
        onTap: () async => context.pushNamed(
          'category-detail',
          pathParameters: {'slug': category.slug},
        ),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        splashColor: color.withOpacity(0.12),
        highlightColor: color.withOpacity(0.06),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
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
                      child: Text(
                        category.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
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
        ),
      ),
    );
  }
}
