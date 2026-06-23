import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── Dummy data lokal ─────────────────────────────────────────────────────────

class _LelangItem {
  final String kategori;
  final String namaLembaga;
  final String tanggal;
  final String jam;
  final AuctionCategory category;
  final bool isLive;

  const _LelangItem({
    required this.kategori,
    required this.namaLembaga,
    required this.tanggal,
    required this.jam,
    required this.category,
    this.isLive = false,
  });
}

const _dummySedangBerlangsung = [
  _LelangItem(
    kategori: 'Mobil',
    namaLembaga: 'Mega Finance Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
    isLive: true,
  ),
  _LelangItem(
    kategori: 'Mobil',
    namaLembaga: 'Mega Finance Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
    isLive: true,
  ),
];

const _dummyAkanDatang = [
  _LelangItem(
    kategori: 'Mobil',
    namaLembaga: 'Mega Finance Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
  ),
  _LelangItem(
    kategori: 'Mobil',
    namaLembaga: 'Mega Finance Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
    category: AuctionCategory.mobil,
  ),
];

// ─── Icons & warna per kategori ───────────────────────────────────────────────

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

const _categoryIconBg = {
  AuctionCategory.mobil: Color(0xFFFFF8DC),
  AuctionCategory.motor: Color(0xFFFFF0E6),
  AuctionCategory.elektronik: Color(0xFFEEF2FB),
};

const _auctionCategories = [
  AuctionCategory.mobil,
  AuctionCategory.motor,
  AuctionCategory.elektronik,
];

// ─── Page ─────────────────────────────────────────────────────────────────────

class IkutLelangPage extends StatefulWidget {
  const IkutLelangPage({super.key});

  @override
  State<IkutLelangPage> createState() => _IkutLelangPageState();
}

class _IkutLelangPageState extends State<IkutLelangPage> {
  AuctionCategory _selectedCategory = AuctionCategory.mobil;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: const AppPageBar(
        title: 'Ikut Lelang',
        showBackButton: false,
        titleSpacing: AppSpacings.md,
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
              AppSpacings.md,
              AppSpacings.md,
              AppSpacings.md,
              AppSpacings.lg,
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
                  selected: _selectedCategory,
                  onSelected: (cat) => setState(() => _selectedCategory = cat),
                ),
              ],
            ),
          ),

          const AppSpacer.sm(),

          // ── Sedang Berlangsung ────────────────────────────────────────
          _SectionContainer(
            color: AppColors.white,
            padding: const EdgeInsets.all(AppSpacings.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async => context.push(AppRoutes.lelangList),
                  child: const AppText(
                    'Sedang Berlangsung',
                    variant: AppTextVariant.titleSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const AppSpacer.md(),
                ..._dummySedangBerlangsung.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacings.sm),
                    child: _LelangListCard(item: item),
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
              AppSpacings.md,
              AppSpacings.md,
              AppSpacings.md,
              AppSpacings.lg,
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
                        padding: const EdgeInsets.only(bottom: AppSpacings.sm),
                        child: _LelangListCard(item: item),
                      ),
                    ),
              ],
            ),
          ),

          const AppSpacer.lg(),
        ],
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
              padding: const EdgeInsets.only(right: AppSpacings.sm),
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
    final bgColor = _categoryIconBg[category] ?? AppColors.neutral100;

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
                color: bgColor,
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

class _LelangListCard extends StatelessWidget {
  final _LelangItem item;

  const _LelangListCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final icon = _categoryIcons[item.category] ?? Icons.category_rounded;
    final iconColor = _categoryIconColors[item.category] ?? AppColors.primary500;
    final iconBg = _categoryIconBg[item.category] ?? AppColors.neutral100;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Row: ikon + info ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacings.md),
            child: Row(
              children: [
                // Thumbnail ikon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 32),
                  ),
                ),
                const SizedBox(width: AppSpacings.md),

                // Info teks
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        item.kategori,
                        variant: AppTextVariant.labelSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 2),
                      AppText(
                        item.namaLembaga,
                        variant: AppTextVariant.labelMedium,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AppText(
                            item.tanggal,
                            variant: AppTextVariant.labelSmall,
                            color: AppColors.textSecondary,
                          ),
                          const AppText(
                            '  |  ',
                            variant: AppTextVariant.labelSmall,
                            color: AppColors.neutral300,
                          ),
                          AppText(
                            item.jam,
                            variant: AppTextVariant.labelSmall,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── CTA button ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacings.md,
              0,
              AppSpacings.md,
              AppSpacings.md,
            ),
            child: AppButton(
              label: 'Live Auction',
              size: AppButtonSize.small,
              onPressed: () async {
                await context.push(AppRoutes.liveAuction);
              },
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
