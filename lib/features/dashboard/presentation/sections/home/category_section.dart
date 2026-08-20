import 'package:emas/core/constants/images.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final Map<AuctionCategory, String> _categoryIcons = {
  AuctionCategory.mobil: Images.carIcon,
  AuctionCategory.motor: Images.motorcycleIcon,
  AuctionCategory.elektronik: Images.electronicIcon,
};

const List<AuctionCategory> _categories = [
  AuctionCategory.mobil,
  AuctionCategory.motor,
  AuctionCategory.elektronik,
];

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _categories
            .map(
              (category) => _CategoryItem(
                category: category,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final AuctionCategory category;

  const _CategoryItem({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final String icon = _categoryIcons[category]!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await context.pushNamed(
          'category-detail',
          pathParameters: {
            'slug': category.slug,
          },
        );
      },
      child: SizedBox(
        width: 82,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ============================================================
            // CATEGORY ICON
            // ============================================================
            SizedBox(
              width: 56,
              height: 46,
              child: FittedBox(
                child: AppImage(
                  src: icon,
                ),
              ),
            ),

            const SizedBox(height: 5),

            // ============================================================
            // CATEGORY LABEL
            // ============================================================
            AppText(
              category.label,
              variant: AppTextVariant.bodySmall,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
