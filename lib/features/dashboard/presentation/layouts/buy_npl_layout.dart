import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuyNplLayout extends StatefulWidget {
  const BuyNplLayout({super.key});

  @override
  State<BuyNplLayout> createState() => _BuyNplLayoutState();
}

class _BuyNplLayoutState extends State<BuyNplLayout> {
  AuctionCategory _selectedCategory = AuctionCategory.mobil;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(
        elevation: 1,
        title: 'Beli NPL',
        titleSpacing: AppSpacings.xl,
        showBackButton: false,
      ),
      body: _SectionContainer(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(
          AppSpacings.md,
          AppSpacings.md,
          AppSpacings.md,
          AppSpacings.lg,
        ),
        child: Center(
          child: _CategorySelector(
            selected: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
        ),
      ),
    );
  }
}

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

const _auctionCategories = [
  AuctionCategory.mobil,
  AuctionCategory.motor,
  AuctionCategory.elektronik,
];

class _CategorySelector extends StatelessWidget {
  final AuctionCategory selected;
  final ValueChanged<AuctionCategory> onSelected;

  const _CategorySelector({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _auctionCategories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: AppSpacings.sm),
              child: _CategoryChip(
                category: cat,
                isSelected: cat == selected,
                onTap: () async => {
                  onSelected(cat),
                  await context.push(AppRoutes.beliNplDetail),
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final AuctionCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = _categoryIcons[category] ?? Icons.category_rounded;
    final iconColor = _categoryIconColors[category] ?? AppColors.primary500;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 88,
        padding: const EdgeInsets.symmetric(vertical: AppSpacings.sm),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          border: Border.all(
            // color: isSelected ? AppColors.primary500 : AppColors.neutral200,
            color: AppColors.neutral200,
            // width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                // color: bgColor,
                borderRadius: BorderRadius.circular(RadiusTokens.sm),
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 30),
              ),
            ),
            const SizedBox(height: 6),
            AppText(
              category.label,
              variant: AppTextVariant.labelSmall,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;

  const _SectionContainer({
    required this.child,
    required this.color,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: padding,
      child: child,
    );
  }
}
