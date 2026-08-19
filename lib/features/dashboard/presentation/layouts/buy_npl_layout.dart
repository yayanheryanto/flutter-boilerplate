import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/dropdown/app_dropdown.dart';
import 'package:emas/shared/widgets/pickers/app_date_picker.dart';
import 'package:emas/shared/widgets/toast/app_toast.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
            onTap: () async {
              onSelected(cat);
              final result = await BeliNplBottomSheet.show(
                context,
                category: cat,
              );
              if (result != null && context.mounted) {
                await context.push(AppRoutes.beliNplDetail, extra: result);
              }
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

/// Hasil yang dikembalikan saat user menekan "Tambah".
class BeliNplResult {
  final AuctionCategory category;
  final String lokasi;
  final DateTime tanggal;
  final int jumlah;
  final int hargaPerNpl;
  final int subtotal;

  const BeliNplResult({
    required this.category,
    required this.lokasi,
    required this.tanggal,
    required this.jumlah,
    required this.hargaPerNpl,
    required this.subtotal,
  });
}

/// Dummy daftar lokasi lelang — ganti dengan data dari API begitu tersedia.
const _dummyLokasiLelang = [
  'Mega Finance Fatmawati',
  'Mega Finance Kelapa Gading',
  'Mega Finance Bandung',
  'Mega Finance Surabaya',
];

/// Bottom sheet "Beli NPL" — dipanggil sebelum masuk ke halaman detail NPL,
/// supaya user set lokasi, tanggal lelang, dan jumlah NPL yang mau dibeli.
///
/// ```dart
/// final result = await BeliNplBottomSheet.show(
///   context,
///   category: AuctionCategory.mobil,
/// );
/// if (result != null) {
///   // lanjut ke halaman berikutnya dengan `result`
/// }
/// ```
class BeliNplBottomSheet {
  static Future<BeliNplResult?> show(
      BuildContext context, {
        required AuctionCategory category,
        int hargaPerNpl = 1000000,
        int initialJumlah = 1,
      }) {
    return AppCustomBottomSheet.show<BeliNplResult>(
      context,
      title: 'Beli NPL',
      isDismissible: true,
      content: _BeliNplForm(
        category: category,
        hargaPerNpl: hargaPerNpl,
        initialJumlah: initialJumlah,
      ),
    );
  }
}

class _BeliNplForm extends StatefulWidget {
  final AuctionCategory category;
  final int hargaPerNpl;
  final int initialJumlah;

  const _BeliNplForm({
    required this.category,
    required this.hargaPerNpl,
    required this.initialJumlah,
  });

  @override
  State<_BeliNplForm> createState() => _BeliNplFormState();
}

class _BeliNplFormState extends State<_BeliNplForm> {
  String? _lokasi;
  DateTime? _tanggal;
  late int _jumlah;

  @override
  void initState() {
    super.initState();
    _jumlah = widget.initialJumlah;
  }

  int get _subtotal => widget.hargaPerNpl * _jumlah;

  void _incrementJumlah() => setState(() => _jumlah++);

  void _decrementJumlah() {
    if (_jumlah <= 1) return;
    setState(() => _jumlah--);
  }

  void _submit() async {
    // if (_lokasi == null || _tanggal == null) {
    //   AppToast.show(
    //     'Lengkapi lokasi dan tanggal lelang terlebih dahulu',
    //     type: AppToastType.warning,
    //   );
    //   return;
    // }

    // Navigator.of(context).pop(
    //   BeliNplResult(
    //     category: widget.category,
    //     lokasi: _lokasi!,
    //     tanggal: _tanggal!,
    //     jumlah: _jumlah,
    //     hargaPerNpl: widget.hargaPerNpl,
    //     subtotal: _subtotal,
    //   ),
    // );

    await context.push(AppRoutes.beliNplDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppDropdownField<String>(
          label: 'Lokasi Lelang',
          hint: 'Pilih lokasi lelang',
          value: _lokasi,
          items: _dummyLokasiLelang,
          onChanged: (v) => setState(() => _lokasi = v),
        ),
        const SizedBox(height: AppSpacings.md),
        AppDateField(
          label: 'Tanggal Lelang',
          hint: 'Pilih tanggal lelang',
          initialValue: _tanggal,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
          onChanged: (d) => setState(() => _tanggal = d),
        ),
        const SizedBox(height: AppSpacings.lg),

        // ── Jumlah NPL ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              'Jumlah NPL',
              variant: AppTextVariant.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
            _QuantityStepper(
              value: _jumlah,
              onDecrement: _decrementJumlah,
              onIncrement: _incrementJumlah,
            ),
          ],
        ),

        const SizedBox(height: AppSpacings.md),
        const Divider(height: 1, color: AppColors.neutral200),
        const SizedBox(height: AppSpacings.md),

        // ── Harga & subtotal ──────────────────────────────────────
        _PriceRow(label: 'Harga per NPL', value: widget.hargaPerNpl),
        const SizedBox(height: AppSpacings.sm),
        _PriceRow(label: 'Subtotal', value: _subtotal, emphasize: true),

        const SizedBox(height: AppSpacings.lg),

        AppButton(
          label: 'Tambah',
          size: AppButtonSize.large,
          borderRadius: RadiusTokens.full,
          onPressed: _submit,
        ),
      ],
    );
  }
}

// ─── Quantity stepper ─────────────────────────────────────────────────────────

class _QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(icon: Icons.remove_rounded, onTap: onDecrement),
        SizedBox(
          width: 32,
          child: AppText(
            '$value',
            textAlign: TextAlign.center,
            variant: AppTextVariant.titleSmall,
            fontWeight: FontWeight.w700,
          ),
        ),
        _StepperButton(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(RadiusTokens.full),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.neutral100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }
}

// ─── Price row ────────────────────────────────────────────────────────────────

class _PriceRow extends StatelessWidget {
  final String label;
  final int value;
  final bool emphasize;

  const _PriceRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          variant: AppTextVariant.bodyMedium,
          color: emphasize ? AppColors.textPrimary : AppColors.textSecondary,
          fontWeight: emphasize ? FontWeight.w600 : FontWeight.w400,
        ),
        AppText(
          formatted,
          variant: emphasize ? AppTextVariant.titleSmall : AppTextVariant.bodyMedium,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
