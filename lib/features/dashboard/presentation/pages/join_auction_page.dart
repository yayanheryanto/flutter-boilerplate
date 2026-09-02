import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/dashboard/presentation/bloc/join_auction/join_auction_bloc.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// ─── Dummy data lokal ─────────────────────────────────────────────────────────

class _AuctionItem {
  final String categoryLabel;
  final String institutionName;
  final String date;
  final String jam;
  final AuctionCategory category;
  final bool isLive;

  const _AuctionItem({
    required this.categoryLabel,
    required this.institutionName,
    required this.date,
    required this.jam,
    required this.category,
    this.isLive = false,
  });
}

const _dummySedangBerlangsung = [
  _AuctionItem(
    categoryLabel: 'Mobil',
    institutionName: 'Mega Finance Fatmawati',
    date: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
    isLive: true,
  ),
  _AuctionItem(
    categoryLabel: 'Mobil',
    institutionName: 'Mega Finance Fatmawati',
    date: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
    isLive: true,
  ),
];

const _dummyAkanDatang = [
  _AuctionItem(
    categoryLabel: 'Mobil',
    institutionName: 'Mega Finance Fatmawati',
    date: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
  ),
  _AuctionItem(
    categoryLabel: 'Mobil',
    institutionName: 'Mega Finance Fatmawati',
    date: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
  ),
];

// ─── Icons & warna per categoryLabel ───────────────────────────────────────────────

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

// const _categoryIconBg = {
//   AuctionCategory.mobil: Color(0xFFFFF8DC),
//   AuctionCategory.motor: Color(0xFFFFF0E6),
//   AuctionCategory.elektronik: Color(0xFFEEF2FB),
// };

const _auctionCategories = [
  AuctionCategory.mobil,
  AuctionCategory.motor,
  AuctionCategory.elektronik,
];

// ─── Page ─────────────────────────────────────────────────────────────────────

class JoinAuctionPage extends StatefulWidget {
  const JoinAuctionPage({super.key});

  @override
  State<JoinAuctionPage> createState() => _JoinAuctionPageState();
}

class _JoinAuctionPageState extends State<JoinAuctionPage> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<JoinAuctionBloc>(),
      child: BlocBuilder<JoinAuctionBloc, JoinAuctionState>(
        builder: (context, state) {
          final selectedCategory = state.selectedCategory;
          return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: const AppPageBar(
        title: 'Ikut Lelang',
        showBackButton: false,
        titleSpacing: Spacings.md,
        titleVariant: AppPageBarTitleVariant.withIcon,
        titleIcon: Icons.gavel_rounded,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Objek Lelang ──────────────────────────────────────────────
          _SectionContainer(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
              Spacings.md,
              Spacings.md,
              Spacings.md,
              Spacings.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Objek Lelang',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
                const AppSpacer.md(),
                _CategorySelector(
                  selected: selectedCategory,
                  onSelected: (cat) => context.read<JoinAuctionBloc>().add(JoinAuctionCategoryChanged(cat)),
                ),
              ],
            ),
          ),

          const AppSpacer.sm(),

          // ── Sedang Berlangsung ────────────────────────────────────────
          _SectionContainer(
            color: AppColors.white,
            padding: const EdgeInsets.all(Spacings.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Sedang Berlangsung',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
                const AppSpacer.md(),
                ..._dummySedangBerlangsung.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: Spacings.sm),
                    child: _AuctionListCard(item: item),
                  ),
                ),
              ],
            ),
          ),

          const AppSpacer.sm(),

          // ── Akan Datang ───────────────────────────────────────────────
          _SectionContainer(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(
              Spacings.md,
              Spacings.md,
              Spacings.md,
              Spacings.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Akan Datang',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
                const AppSpacer.md(),
                ..._dummyAkanDatang
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: Spacings.sm),
                        child: _AuctionListCard(item: item),
                      ),
                    ),
              ],
            ),
          ),

          const AppSpacer.lg(),
        ],
      ),
          );
        },
      ),
    );
  }
}

// ─── Category Selector ────────────────────────────────────────────────────────

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
      children: _auctionCategories
          .map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: Spacings.sm),
              child: _CategoryChip(
                category: cat,
                isSelected: cat == selected,
                onTap: () => onSelected(cat),
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
    // final bgColor = _categoryIconBg[category] ?? AppColors.neutral100;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 88,
        padding: const EdgeInsets.symmetric(vertical: Spacings.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500.withOpacity(0.08) : AppColors.white,
          borderRadius: BorderRadius.circular(RadiusTokens.md),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : AppColors.neutral200,
            width: isSelected ? 2 : 1,
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

// ─── Lelang List Card ─────────────────────────────────────────────────────────
class _AuctionListCard extends StatelessWidget {
  final _AuctionItem item;

  const _AuctionListCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final icon =
        _categoryIcons[item.category] ?? Icons.category_rounded;

    final iconColor =
        _categoryIconColors[item.category] ?? AppColors.primary500;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(
          color: AppColors.neutral200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===============================================================
          // CARD CONTENT
          // ===============================================================
          Padding(
            padding: const EdgeInsets.all(Spacings.md),
            child: Row(
              children: [
                // =========================================================
                // THUMBNAIL
                // =========================================================
                SizedBox(
                  width: 56,
                  height: 56,
                  child: Center(
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 38,
                    ),
                  ),
                ),

                const SizedBox(
                  width: Spacings.md,
                ),

                // =========================================================
                // INFORMATION
                // =========================================================
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        item.categoryLabel,
                        variant: AppTextVariant.labelMedium,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 2),

                      AppText(
                        item.institutionName,
                        variant: AppTextVariant.labelMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Flexible(
                            child: AppText(
                              item.date,
                              variant: AppTextVariant.labelMedium,
                              color: AppColors.textPrimary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const AppText(
                            '  |  ',
                            variant: AppTextVariant.labelMedium,
                            color: AppColors.textPrimary,
                          ),

                          AppText(
                            item.jam,
                            variant: AppTextVariant.labelMedium,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===============================================================
          // LIVE AUCTION
          // ===============================================================
          Material(
            color: AppColors.primary500,
            child: InkWell(
              onTap: () async {
                await context.push(
                  Routes.liveAuction,
                );
              },
              child: const SizedBox(
                width: double.infinity,
                height: 34,
                child: Center(
                  child: AppText(
                    'Live Auction',
                    variant: AppTextVariant.labelMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

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
