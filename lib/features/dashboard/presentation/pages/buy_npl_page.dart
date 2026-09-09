import 'package:emas/core/constants/elevations.dart';
import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/images.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/domain/entities/buy_npl_result.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuyNplPage extends StatefulWidget {
  const BuyNplPage({super.key});

  @override
  State<BuyNplPage> createState() => _BuyNplPageState();
}

class _BuyNplPageState extends State<BuyNplPage> {
  AuctionCategory _selectedCategory = AuctionCategory.mobil;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(
        elevation: Elevations.xs,
        title: 'Beli NPL',
      ),
      body: _SectionContainer(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(
          Spacings.md,
          Spacings.md,
          Spacings.md,
          Spacings.lg,
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

final _categoryIcons = {
  AuctionCategory.mobil: Images.carIcon,
  AuctionCategory.motor: Images.motorcycleIcon,
};

const _auctionCategories = [
  AuctionCategory.mobil,
  AuctionCategory.motor,
  // AuctionCategory.elektronik,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: _auctionCategories.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final cat = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index != _auctionCategories.length - 1 ? 16.0 : 0.0,
            ),
            child: _CategoryChip(
              category: cat,
              isSelected: cat == selected,
              onTap: () async {
                onSelected(cat);
                final result = await BuyNplBottomSheet.show(
                  context,
                  category: cat,
                );

                if (result != null && context.mounted) {
                  await context.push(Routes.buyNplDetail, extra: result);
                }
              },
            ),
          );
        },
      ).toList(),
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
    final icon = _categoryIcons[category];

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 156,
        height: 156,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Rounded.lg),
          border: Border.all(
            color: AppColors.neutral300,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),

            // Area icon dibuat memiliki tinggi yang sama
            SizedBox(
              height: 56,
              child: Center(
                child: AppImage(
                  src: icon,
                  width: 56,
                ),
              ),
            ),

            const AppSpacer.md(),

            // Text selalu berada di posisi yang sama
            SizedBox(
              height: 20,
              child: Center(
                child: AppText(
                  category.label,
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            const Spacer(),
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
/// Dummy daftar location lelang — ganti dengan data dari API begitu tersedia.
const _dummyAuctionLocations = [
  'Mega Finance Fatmawati',
  'Mega Finance Bogor',
  'Mega Finance Bandung',
  'Mega Finance Surabaya',
];

/// Bottom sheet "Beli NPL" — dipanggil sebelum masuk ke halaman detail NPL,
/// supaya user set location, date lelang, dan quantity NPL yang mau dibeli.
class BuyNplBottomSheet {
  static Future<BuyNplResult?> show(
    BuildContext context, {
    required AuctionCategory category,
    int pricePerNpl = 1000000,
    int initialQuantity = 1,
  }) {
    return AppCustomBottomSheet.show<BuyNplResult>(
      context,
      title: 'Beli NPL',
      content: _BuyNplForm(
        category: category,
        pricePerNpl: pricePerNpl,
        initialQuantity: initialQuantity,
      ),
    );
  }
}

class _BuyNplForm extends StatefulWidget {
  final AuctionCategory category;
  final int pricePerNpl;
  final int initialQuantity;

  const _BuyNplForm({
    required this.category,
    required this.pricePerNpl,
    required this.initialQuantity,
  });

  @override
  State<_BuyNplForm> createState() => _BuyNplFormState();
}

class _BuyNplFormState extends State<_BuyNplForm> {
  String? _location;
  DateTime? _date;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  int get _subtotal => widget.pricePerNpl * _quantity;

  void _incrementQuantity() => setState(() => _quantity++);

  void _decrementQuantity() {
    if (_quantity <= 1) return;
    setState(() => _quantity--);
  }

  void _submit() async {
    // Uncomment validasi ini jika location dan date diwajibkan:
    // if (_location == null || _date == null) {
    //   AppToast.show(
    //     'Lengkapi location dan date lelang terlebih dahulu',
    //     type: AppToastType.warning,
    //   );
    //   return;
    // }
    // Navigator.of(context).pop(
    //   BuyNplResult(
    //     category: widget.category,
    //     location: _location!,
    //     date: _date!,
    //     quantity: _quantity,
    //     pricePerNpl: widget.pricePerNpl,
    //     subtotal: _subtotal,
    //   ),
    // );
    context.pop();
    await context.push(Routes.buyNplDetail);
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
          value: _location,
          items: _dummyAuctionLocations,
          onChanged: (v) => setState(() => _location = v),
        ),
        const SizedBox(height: Spacings.md),
        AppDateField(
          label: 'Tanggal Lelang',
          hint: 'Pilih date lelang',
          initialValue: _date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
          onChanged: (d) => setState(() => _date = d),
        ),
        const SizedBox(height: Spacings.lg),

        // ── Jumlah NPL ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const AppText(
              'Jumlah NPL',
              fontWeight: FontWeight.w500,
            ),
            _QuantityStepper(
              value: _quantity,
              onDecrement: _decrementQuantity,
              onIncrement: _incrementQuantity,
            ),
          ],
        ),
        const SizedBox(height: Spacings.md),
        const Divider(height: 1, color: AppColors.neutral200),
        const SizedBox(height: Spacings.md),

        // ── Harga & subtotal ──────────────────────────────────────
        _PriceRow(label: 'Harga per NPL', value: widget.pricePerNpl),
        const SizedBox(height: Spacings.sm),
        _PriceRow(label: 'Subtotal', value: _subtotal, emphasize: true),
        const SizedBox(height: Spacings.lg),
        AppButton(
          label: 'Tambah',
          borderRadius: Rounded.full,
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
      borderRadius: BorderRadius.circular(Rounded.full),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.neutral100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.textPrimary,
        ),
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
    final formatted = CurrencyFormatter.rupiah(value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
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
