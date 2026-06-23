import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/input/app_text_field.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ─── Tipe halaman ──────────────────────────────────────────────────────────────

enum LelangListType {
  sedangBerlangsung,
  akanDatang;

  String get label {
    switch (this) {
      case LelangListType.sedangBerlangsung:
        return 'Sedang Berlangsung';
      case LelangListType.akanDatang:
        return 'Akan Datang';
    }
  }
}

// ─── Model lokal ───────────────────────────────────────────────────────────────

class _LelangCardData {
  final String nama;
  final int harga;
  final String lokasi;
  final String tanggal;
  final String jam;

  const _LelangCardData({
    required this.nama,
    required this.harga,
    required this.lokasi,
    required this.tanggal,
    required this.jam,
  });
}

// ─── Dummy data ─────────────────────────────────────────────────────────────────

const _dummyItems = [
  _LelangCardData(
    nama: 'DAIHATSU GRAND MAX BV - 1.3',
    harga: 125000000,
    lokasi: 'Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
  ),
  _LelangCardData(
    nama: 'DAIHATSU GRAND MAX BV - 1.3',
    harga: 125000000,
    lokasi: 'Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
  ),
  _LelangCardData(
    nama: 'DAIHATSU GRAND MAX BV - 1.3',
    harga: 125000000,
    lokasi: 'Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
  ),
  _LelangCardData(
    nama: 'DAIHATSU GRAND MAX BV - 1.3',
    harga: 125000000,
    lokasi: 'Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
  ),
  _LelangCardData(
    nama: 'DAIHATSU GRAND MAX BV - 1.3',
    harga: 125000000,
    lokasi: 'Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
  ),
  _LelangCardData(
    nama: 'DAIHATSU GRAND MAX BV - 1.3',
    harga: 125000000,
    lokasi: 'Fatmawati',
    tanggal: '12 Jun 2026',
    jam: '10.00',
  ),
];

// ─── Sort options ───────────────────────────────────────────────────────────────

enum _SortOption {
  terbaru('Terbaru'),
  hargaTerendah('Harga Terendah'),
  hargaTertinggi('Harga Tertinggi');

  final String label;

  const _SortOption(this.label);
}

// ─── Currency formatter ─────────────────────────────────────────────────────────

String _formatRupiah(int amount) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(amount);
}

// ─── Page ───────────────────────────────────────────────────────────────────────

class LelangListPage extends StatefulWidget {
  const LelangListPage({super.key});

  @override
  State<LelangListPage> createState() => _LelangListPageState();
}

class _LelangListPageState extends State<LelangListPage> {
  final _searchController = TextEditingController();
  _SortOption _sortOption = _SortOption.terbaru;
  bool _filterActive = false;

  List<_LelangCardData> get _filteredItems {
    final query = _searchController.text.toLowerCase();
    final result = _dummyItems.where((item) {
      if (query.isEmpty) return true;
      return item.nama.toLowerCase().contains(query) || item.lokasi.toLowerCase().contains(query);
    }).toList();

    switch (_sortOption) {
      case _SortOption.hargaTerendah:
        result.sort((a, b) => a.harga.compareTo(b.harga));
      case _SortOption.hargaTertinggi:
        result.sort((a, b) => b.harga.compareTo(a.harga));
      case _SortOption.terbaru:
        break;
    }
    return result;
  }

  Future<void> _showSortSheet() async {
    await AppCustomBottomSheet.show<void>(
      context,
      title: 'Urutkan',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _SortOption.values.map((opt) {
          final selected = _sortOption == opt;
          return ListTile(
            onTap: () {
              setState(() => _sortOption = opt);
              Navigator.pop(context);
            },
            title: AppText(
              opt.label,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.primary500 : AppColors.textPrimary,
            ),
            trailing: selected ? const Icon(Icons.check_rounded, color: AppColors.primary500) : null,
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showFilterSheet() async {
    await AppCustomBottomSheet.show<void>(
      context,
      title: 'Filter',
      content: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacings.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Harga',
              variant: AppTextVariant.labelMedium,
              fontWeight: FontWeight.w600,
            ),
            const AppSpacer.sm(),
            const Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hint: 'Min',
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.sm),
                  child: AppText('–'),
                ),
                Expanded(
                  child: AppTextField(
                    hint: 'Maks',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const AppSpacer.lg(),
            AppButton(
              label: 'Terapkan Filter',
              onPressed: () {
                setState(() => _filterActive = true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;

    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: _SearchAppBar(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        onBack: () => context.pop(),
        topMargin: MediaQuery.of(context).padding.top,
      ),
      body: Column(
        children: [
          // ── Toolbar: urutkan + filter ───────────────────────────────
          _FilterToolbar(
            sortLabel: _sortOption.label,
            filterActive: _filterActive,
            onSortTap: _showSortSheet,
            onFilterTap: _showFilterSheet,
          ),

          // ── Grid list ───────────────────────────────────────────────
          Expanded(
            child: items.isEmpty
                ? const _EmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(AppSpacings.md),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacings.sm,
                      mainAxisSpacing: AppSpacings.sm,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) => _LelangGridCard(
                      data: items[index],
                      onTap: () async => context.push(AppRoutes.liveAuction),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Custom AppBar dengan search field ────────────────────────────────────────

class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onBack;
  final double topMargin;

  const _SearchAppBar({
    required this.controller,
    required this.onChanged,
    required this.onBack,
    this.topMargin = 0,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + topMargin);

  @override
  Widget build(BuildContext context) {
    final bar = AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: AppColors.primary500,
            ),
            onPressed: onBack,
          ),

          // Search field
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacings.md),
              child: AppSearchField(
                controller: controller,
                hint: 'Cari',
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );

    if (topMargin == 0) return bar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: topMargin, color: AppColors.white),
        bar,
      ],
    );
  }
}

// ─── Filter toolbar ─────────────────────────────────────────────────────────────

class _FilterToolbar extends StatelessWidget {
  final String sortLabel;
  final bool filterActive;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const _FilterToolbar({
    required this.sortLabel,
    required this.filterActive,
    required this.onSortTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm,
      ),
      child: Row(
        children: [
          // Urutkan
          _ToolbarChip(
            label: sortLabel,
            active: false,
            onTap: onSortTap,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
          ),
          const SizedBox(width: AppSpacings.sm),

          // Filter
          _ToolbarChip(
            label: 'Filter',
            active: filterActive,
            onTap: onFilterTap,
            suffixIcon: Icons.keyboard_arrow_down_rounded,
          ),
        ],
      ),
    );
  }
}

class _ToolbarChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData suffixIcon;

  const _ToolbarChip({
    required this.label,
    required this.active,
    required this.onTap,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.sm + 4,
          vertical: AppSpacings.xs + 2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary100 : AppColors.white,
          borderRadius: BorderRadius.circular(RadiusTokens.full),
          border: Border.all(
            color: active ? AppColors.primary500 : AppColors.neutral300,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              variant: AppTextVariant.labelSmall,
              fontWeight: FontWeight.w500,
              color: active ? AppColors.primary500 : AppColors.textPrimary,
            ),
            const SizedBox(width: 2),
            Icon(
              suffixIcon,
              size: 16,
              color: active ? AppColors.primary500 : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grid card ──────────────────────────────────────────────────────────────────

class _LelangGridCard extends StatelessWidget {
  final _LelangCardData data;
  final VoidCallback onTap;

  const _LelangGridCard({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          border: Border.all(color: AppColors.neutral200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail placeholder
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.neutral200,
                child: const Center(
                  child: Icon(
                    Icons.directions_car_outlined,
                    size: 40,
                    color: AppColors.neutral400,
                  ),
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppSpacings.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    data.nama,
                    variant: AppTextVariant.labelSmall,
                    fontWeight: FontWeight.w500,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    _formatRupiah(data.harga),
                    variant: AppTextVariant.labelMedium,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    data.lokasi,
                    variant: AppTextVariant.labelSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      AppText(
                        data.tanggal,
                        variant: AppTextVariant.labelSmall,
                        color: AppColors.textSecondary,
                      ),
                      const AppText(
                        ' | ',
                        variant: AppTextVariant.labelSmall,
                        color: AppColors.neutral300,
                      ),
                      AppText(
                        data.jam,
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
    );
  }
}

// ─── Empty state ─────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.neutral300,
          ),
          AppSpacer.sm(),
          AppText(
            'Tidak ada lelang ditemukan',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
