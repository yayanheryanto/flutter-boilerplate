import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/domain/entities/npl_order_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/dashboard/presentation/bloc/buy_npl_detail/buy_npl_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _dummyOrders = [
  NplOrderItem(
    category: AuctionCategory.mobil,
    location: 'Fatmawati',
    date: '29 Juni 2026',
    time: '10.00 WIB',
    nplQuantity: 1,
    pricePerNpl: 5000000,
  ),
  NplOrderItem(
    category: AuctionCategory.motor,
    location: 'Fatmawati',
    date: '29 Juni 2026',
    time: '10.00 WIB',
    nplQuantity: 3,
    pricePerNpl: 1000000,
  ),
];

const _categoryIcons = {
  AuctionCategory.mobil: Icons.directions_car_rounded,
  AuctionCategory.motor: Icons.two_wheeler_rounded,
  AuctionCategory.elektronik: Icons.laptop_rounded,
  AuctionCategory.properti: Icons.home_rounded,
  AuctionCategory.mewah: Icons.diamond_rounded,
  AuctionCategory.lainnya: Icons.category_rounded,
};

const _categoryIconColors = {
  AuctionCategory.mobil: Color(0xFFF5C842),
  AuctionCategory.motor: Color(0xFFE8834A),
  AuctionCategory.elektronik: Color(0xFF7B9FD4),
  AuctionCategory.properti: Color(0xFF6DB56D),
  AuctionCategory.mewah: Color(0xFF9C7FD4),
  AuctionCategory.lainnya: Color(0xFF94A3B8),
};

const _categoryIconBg = {
  AuctionCategory.mobil: Color(0xFFFFF8DC),
  AuctionCategory.motor: Color(0xFFFFF0E6),
  AuctionCategory.elektronik: Color(0xFFEEF2FB),
  AuctionCategory.properti: Color(0xFFEEF7EE),
  AuctionCategory.mewah: Color(0xFFF3EEFB),
  AuctionCategory.lainnya: Color(0xFFF1F5F9),
};

class BuyNplDetailPage extends StatelessWidget {
  final List<NplOrderItem> orders;

  const BuyNplDetailPage({
    super.key,
    this.orders = _dummyOrders,
  });

  int get _totalAmount => orders.fold(0, (sum, o) => sum + o.subtotal);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BuyNplDetailBloc>()..add(const BuyNplDetailStarted()),
      child: BlocBuilder<BuyNplDetailBloc, BuyNplDetailState>(
        builder: (context, state) => AppScaffoldWrapper(
          backgroundColor: AppColors.neutral50,
          appBar: const AppPageBar(title: 'Beli NPL'),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Scrollable content ─────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Spacings.md),
                  children: [
                    // Header teks
                    const AppText(
                      'Konfirmasi Pembelian NPL',
                      variant: AppTextVariant.titleLarge,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: Spacings.xs),
                    const AppText(
                      'Silakan cek kembali yang sudah Anda pilih sebelum lanjut ke pembayaran',
                      color: AppColors.textPrimary,
                    ),

                    const SizedBox(height: Spacings.lg),

                    // Order cards
                    ...orders.map(
                      (order) => Padding(
                        padding: const EdgeInsets.only(bottom: Spacings.md),
                        child: _NplOrderCard(order: order),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Fixed bottom CTA ───────────────────────────────────────
              _BottomCTA(total: _totalAmount),
            ],
          ),
        ),
      ),
    );
  }
}

class _NplOrderCard extends StatelessWidget {
  final NplOrderItem order;

  const _NplOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final icon = _categoryIcons[order.category] ?? Icons.category_rounded;
    final iconColor = _categoryIconColors[order.category] ?? AppColors.neutral400;
    final iconBg = _categoryIconBg[order.category] ?? AppColors.neutral100;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Rounded.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Header: icon + label categoryLabel ─────────────────────────
          Padding(
            padding: const EdgeInsets.all(Spacings.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(Rounded.md),
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                ),
                const SizedBox(width: Spacings.sm),
                AppText(
                  order.category.label,
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.neutral200),

          Padding(
            padding: const EdgeInsets.all(Spacings.md),
            child: Column(
              children: [
                _DetailRow(
                  left: _DetailCell(
                    label: 'Lokasi Lelang',
                    value: order.location,
                  ),
                  right: _DetailCell(
                    label: 'Lokasi Lelang',
                    value: order.location,
                  ),
                ),
                const SizedBox(height: Spacings.md),
                _DetailRow(
                  left: _DetailCell(
                    label: 'Tanggal Lelang',
                    value: order.date,
                  ),
                  right: _DetailCell(
                    label: 'Waktu Lelang',
                    value: order.time,
                  ),
                ),
                const SizedBox(height: Spacings.md),
                _DetailRow(
                  left: _DetailCell(
                    label: 'Jumlah NPL',
                    value: order.nplQuantity.toString(),
                  ),
                  right: _DetailCell(
                    label: 'Harga per NPL',
                    value: CurrencyFormatter.rupiah(order.pricePerNpl),
                  ),
                ),
              ],
            ),
          ),

          _SubtotalBar(amount: order.subtotal),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final _DetailCell left;
  final _DetailCell right;

  const _DetailRow({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        Expanded(child: right),
      ],
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;

  const _DetailCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          variant: AppTextVariant.labelSmall,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 2),
        AppText(
          value,
          variant: AppTextVariant.labelMedium,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}

class _SubtotalBar extends StatelessWidget {
  final int amount;

  const _SubtotalBar({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary500,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.md,
        vertical: Spacings.sm + 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText(
            'Subtotal',
            variant: AppTextVariant.labelLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          AppText(
            CurrencyFormatter.rupiah(amount),
            variant: AppTextVariant.labelLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  final int total;

  const _BottomCTA({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        Spacings.md,
        Spacings.sm,
        Spacings.md,
        Spacings.lg,
      ),
      child: AppButton(
        label: 'Lanjut Pembayaran ${CurrencyFormatter.rupiah(total)}',
        borderRadius: Rounded.full,
        onPressed: () async {
          await context.push(Routes.buyNplConfirmation);
        },
      ),
    );
  }
}
