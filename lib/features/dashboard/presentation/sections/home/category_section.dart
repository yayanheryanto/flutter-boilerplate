import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Maps each category to a Material icon that resembles the illustration style
const _categoryIcons = {
  AuctionCategory.mobil: Icons.directions_car_rounded,
  AuctionCategory.motor: Icons.two_wheeler_rounded,
  AuctionCategory.elektronik: Icons.laptop_rounded,
};

const _categoryIconColors = {
  AuctionCategory.mobil: Color(0xFFF5C842),
  AuctionCategory.motor: Color(0xFFE8834A),
  AuctionCategory.elektronik: Color(0xFF7B9FD4),
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
      children: _categories.map((cat) => _CategoryItem(category: cat)).toList(),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final AuctionCategory category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final iconColor = _categoryIconColors[category] ?? AppColors.primary500;
    final icon = _categoryIcons[category] ?? Icons.category_rounded;

    return GestureDetector(
      onTap: () => context.pushNamed(
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
              child: Icon(icon, color: iconColor, size: 36),
            ),
          ),
          const SizedBox(height: 6),
          AppText(
            category.label,
            variant: AppTextVariant.bodySmall,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
          ),
        ],
      ),
    );
  }
}