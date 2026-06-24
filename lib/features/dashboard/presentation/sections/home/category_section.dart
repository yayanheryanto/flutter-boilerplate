import 'package:emas/core/constants/images.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

var _categoryIcons = {
  AuctionCategory.mobil: Images.carIcon,
  AuctionCategory.motor: Images.motorcycleIcon,
  AuctionCategory.elektronik: Images.electronicIcon,
};

const _categories = [
  AuctionCategory.mobil,
  AuctionCategory.motor,
  AuctionCategory.elektronik,
];

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _categories
          .map(
            (cat) => _CategoryItem(
              category: cat,
            ),
          )
          .toList(),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final AuctionCategory category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final String icon = _categoryIcons[category]!;

    return GestureDetector(
      onTap: () async => context.pushNamed(
        'category-detail',
        pathParameters: {'slug': category.slug},
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: AppImage(src: icon),
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            category.label,
            variant: AppTextVariant.bodySmall,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(
                  0.75,
                ),
          ),
        ],
      ),
    );
  }
}
