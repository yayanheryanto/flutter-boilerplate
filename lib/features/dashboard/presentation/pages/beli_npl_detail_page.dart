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
import 'package:intl/intl.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

class NplOrderItem {
  final AuctionCategory category;
  final String lokasi;
  final String tanggal;
  final String waktu;
  final int jumlahNpl;
  final int hargaPerNpl;

  const NplOrderItem({
    required this.category,
    required this.lokasi,
    required this.tanggal,
    required this.waktu,
    required this.jumlahNpl,
    required this.hargaPerNpl,
  });

  int get subtotal => jumlahNpl * hargaPerNpl;
}

// ─── Dummy data ───────────────────────────────────────────────────────────────

const _dummyOrders = [
  NplOrderItem(
    category: AuctionCategory.mobil,
    lokasi: 'Fatmawati',
    tanggal: '29 Juni 2026',
    waktu: '10.00 WIB',
    jumlahNpl: 1,
    hargaPerNpl: 5000000,
  ),
  NplOrderItem(
    category: AuctionCategory.motor,
    lokasi: 'Fatmawati',
    tanggal: '29 Juni 2026',
    waktu: '10.00 WIB',
    jumlahNpl: 3,
    hargaPerNpl: 1000000,
  ),
];

// ─── Formatter ────────────────────────────────────────────────────────────────

String _rupiah(int amount) => NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);

// ─── Category icon/color helpers ──────────────────────────────────────────────

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

// ─── Page ─────────────────────────────────────────────────────────────────────

class BeliNplPage extends StatelessWidget {
  final List<NplOrderItem> orders;

  const BeliNplPage({
    super.key,
    this.orders = _dummyOrders,
  });

  int get _totalHarga => orders.fold(0, (sum, o) => sum + o.subtotal);

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: AppPageBar(title: 'Beli NPL'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Scrollable content ─────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacings.md),
              children: [
                // Header teks
                const AppText(
                  'Konfirmasi Pembelian NPL',
                  variant: AppTextVariant.titleLarge,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: AppSpacings.xs),
                const AppText(
                  'Silakan cek kembali yang sudah Anda pilih sebelum lanjut ke pembayaran',
                  variant: AppTextVariant.bodyMedium,
                  color: AppColors.textSecondary,
                ),

                const SizedBox(height: AppSpacings.lg),

                // Order cards
                ...orders.map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacings.md),
                    child: _NplOrderCard(order: order),
                  ),
                ),
              ],
            ),
          ),

          // ── Fixed bottom CTA ───────────────────────────────────────
          _BottomCTA(total: _totalHarga),
        ],
      ),
    );
  }
}

// ─── Order card ───────────────────────────────────────────────────────────────

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
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Header: icon + label kategori ─────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacings.md),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(RadiusTokens.md),
                  ),
                  child: Center(
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                ),
                const SizedBox(width: AppSpacings.sm),
                AppText(
                  order.category.label,
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.neutral200),

          // ── Grid detail ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacings.md),
            child: Column(
              children: [
                _DetailRow(
                  left: _DetailCell(
                    label: 'Lokasi Lelang',
                    value: order.lokasi,
                  ),
                  right: _DetailCell(
                    label: 'Lokasi Lelang',
                    value: order.lokasi,
                  ),
                ),
                const SizedBox(height: AppSpacings.md),
                _DetailRow(
                  left: _DetailCell(
                    label: 'Tanggal Lelang',
                    value: order.tanggal,
                  ),
                  right: _DetailCell(
                    label: 'Waktu Lelang',
                    value: order.waktu,
                  ),
                ),
                const SizedBox(height: AppSpacings.md),
                _DetailRow(
                  left: _DetailCell(
                    label: 'Jumlah NPL',
                    value: order.jumlahNpl.toString(),
                  ),
                  right: _DetailCell(
                    label: 'Harga per NPL',
                    value: _rupiah(order.hargaPerNpl),
                  ),
                ),
              ],
            ),
          ),

          // ── Subtotal bar ──────────────────────────────────────────
          _SubtotalBar(amount: order.subtotal),
        ],
      ),
    );
  }
}

// ─── Detail row + cell ────────────────────────────────────────────────────────

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
          color: AppColors.textSecondary,
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

// ─── Subtotal bar ─────────────────────────────────────────────────────────────

class _SubtotalBar extends StatelessWidget {
  final int amount;

  const _SubtotalBar({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary500,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm + 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const AppText(
            'Subtotal',
            variant: AppTextVariant.labelLarge,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          AppText(
            _rupiah(amount),
            variant: AppTextVariant.labelLarge,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}

// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCTA extends StatelessWidget {
  final int total;

  const _BottomCTA({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.md,
        AppSpacings.sm,
        AppSpacings.md,
        AppSpacings.lg,
      ),
      child: AppButton(
        label: 'Lanjut Pembayaran    ${_rupiah(total)}',
        size: AppButtonSize.large,
        borderRadius: RadiusTokens.full,
        onPressed: () async {
          await context.push(AppRoutes.beliNplConfirmation);
        },
      ),
    );
  }
}
