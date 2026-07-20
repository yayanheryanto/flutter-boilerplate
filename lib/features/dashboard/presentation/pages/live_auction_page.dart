import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─── Model ────────────────────────────────────────────────────────────────────

enum BidderType { floorBidder, onlineBidder, yourBid }

class BidEntry {
  final int amount;
  final BidderType type;

  const BidEntry({required this.amount, required this.type});
}

// ─── Dummy data ───────────────────────────────────────────────────────────────

const _dummyBids = [
  BidEntry(amount: 106000000, type: BidderType.onlineBidder),
  BidEntry(amount: 105500000, type: BidderType.yourBid),
  BidEntry(amount: 105000000, type: BidderType.onlineBidder),
  BidEntry(amount: 104500000, type: BidderType.yourBid),
  BidEntry(amount: 105000000, type: BidderType.onlineBidder),
];

// ─── Formatter ────────────────────────────────────────────────────────────────

String _rp(int v) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(v);

// ─── Page ─────────────────────────────────────────────────────────────────────

class LiveAuctionPage extends StatelessWidget {
  const LiveAuctionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: const AppPageBar(title: 'Live Auction'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ── Lokasi ──────────────────────────────────
                const _LokasiBar(lokasi: 'Mega Finance Fatmawati'),

                // ── Lot + nama ──────────────────────────────
                const _LotHeader(
                  lot: 15,
                  nama: 'DAIHATSU GRAND MAX BV - 1.3',
                  tahun: 'Tahun 2021',
                ),

                const SizedBox(height: AppSpacings.xs),

                // ── Main card ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md),
                  child: _MainInfoCard(),
                ),

                const SizedBox(height: AppSpacings.lg),

                // ── Penawaran Saat Ini ───────────────────────
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacings.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'Penawaran Saat Ini',
                        variant: AppTextVariant.titleSmall,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: AppSpacings.sm),
                      _BidTable(bids: _dummyBids),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacings.xl),
              ],
            ),
          ),
          const _BottomCTA(lot: 15),
        ],
      ),
    );
  }
}

// ─── Lokasi bar ───────────────────────────────────────────────────────────────

class _LokasiBar extends StatelessWidget {
  final String lokasi;

  const _LokasiBar({required this.lokasi});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacings.md, AppSpacings.md, AppSpacings.md, AppSpacings.xs),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          AppText(lokasi, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

// ─── Lot header ───────────────────────────────────────────────────────────────

class _LotHeader extends StatelessWidget {
  final int lot;
  final String nama;
  final String tahun;

  const _LotHeader({required this.lot, required this.nama, required this.tahun});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md, vertical: AppSpacings.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md, vertical: AppSpacings.sm),
            decoration: BoxDecoration(
              color: AppColors.primary500,
              borderRadius: BorderRadius.circular(RadiusTokens.full),
            ),
            child: AppText('Lot $lot', variant: AppTextVariant.labelLarge, fontWeight: FontWeight.w700, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacings.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(nama, variant: AppTextVariant.titleSmall, fontWeight: FontWeight.w700),
                AppText(tahun, variant: AppTextVariant.bodySmall, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Main info card ───────────────────────────────────────────────────────────

class _MainInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Baris atas
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(RadiusTokens.lg),
                ),
                child: const Center(
                  child: Icon(Icons.directions_car_rounded, size: 56, color: AppColors.neutral400),
                ),
              ),
            ),
            const SizedBox(width: AppSpacings.sm),
            Expanded(child: _specCard()),
          ],
        ),

        const SizedBox(height: AppSpacings.sm),

        // Baris bawah
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _priceCard()),
            const SizedBox(width: AppSpacings.sm),
            Expanded(child: _gradeCard()),
          ],
        ),
      ],
    );
  }

  Widget _specCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Spesifikasi Kendaraan', variant: AppTextVariant.labelMedium, fontWeight: FontWeight.w700),
          SizedBox(height: AppSpacings.sm),
          _SpecItem(label: 'No. Polisi', value: 'BK8769ET'),
          _SpecItem(label: 'Kilometer', value: '142.524 KM'),
          _SpecItem(label: 'Masa Berlaku STNK', value: '27 Mei 2026'),
        ],
      ),
    );
  }

  Widget _priceCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Harga Dasar', variant: AppTextVariant.labelSmall, color: AppColors.textSecondary),
          AppText(_rp(106000000), variant: AppTextVariant.titleSmall, fontWeight: FontWeight.w800),
          const SizedBox(height: AppSpacings.sm),
          const AppText('Harga Penawaran Sekarang', variant: AppTextVariant.labelSmall, color: AppColors.textSecondary),
          AppText(_rp(106000000), variant: AppTextVariant.titleSmall, fontWeight: FontWeight.w800),
        ],
      ),
    );
  }

  Widget _gradeCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(child: _GradeItem(label: 'Interior', value: 'A')),
              Expanded(child: _GradeItem(label: 'Rangka', value: 'B')),
            ],
          ),
          SizedBox(height: AppSpacings.sm),
          Row(
            children: [
              Expanded(child: _GradeItem(label: 'Eksterior', value: 'D')),
              Expanded(child: _GradeItem(label: 'Mesin', value: 'C')),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Spec item ────────────────────────────────────────────────────────────────

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;

  const _SpecItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacings.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, variant: AppTextVariant.labelSmall, color: AppColors.textSecondary),
          AppText(value, variant: AppTextVariant.labelLarge, fontWeight: FontWeight.w700),
        ],
      ),
    );
  }
}

// ─── Grade item ───────────────────────────────────────────────────────────────

class _GradeItem extends StatelessWidget {
  final String label;
  final String value;

  const _GradeItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(label, variant: AppTextVariant.labelSmall, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        AppText(value, variant: AppTextVariant.titleSmall, fontWeight: FontWeight.w800),
      ],
    );
  }
}

// ─── Bid table ────────────────────────────────────────────────────────────────
//
// Struktur kolom (3 kolom dengan TableColumnWidth):
//
//  ┌─────────────┬──────────────────────┬───────────────┐
//  │  COUNT      │  Rp106.000.000       │  Online Bidder│  ← header
//  │  Floor Bidd │                      │               │
//  │  Online Bid │                      │               │
//  ├─────────────┼──────────────────────┼───────────────┤
//  │             │  Rp105.500.000       │  Your Bid     │  ← yourBid row (bg kuning)
//  ├─────────────┼──────────────────────┼───────────────┤
//  │             │  Rp105.000.000       │  Online Bidder│
//  └─────────────┴──────────────────────┴───────────────┘
//
// Kolom 0 (lebar tetap 80): COUNT/legend
// Kolom 1 (flex): nominal
// Kolom 2 (lebar tetap 90): tipe bidder

class _BidTable extends StatelessWidget {
  final List<BidEntry> bids;

  const _BidTable({required this.bids});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacings.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.xl),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('COUNT', variant: AppTextVariant.labelMedium, fontWeight: FontWeight.w700),
                    SizedBox(height: 4),
                    AppText('Floor Bidder', variant: AppTextVariant.bodySmall),
                    AppText('Online Bidder', variant: AppTextVariant.bodySmall),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: AppText(_rp(bids.first.amount), variant: AppTextVariant.titleSmall, fontWeight: FontWeight.w800),
              ),
              const Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppText('Online Bidder', variant: AppTextVariant.bodySmall),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacings.sm),

          // List bid
          ...bids.skip(1).map((bid) {
            final isYourBid = bid.type == BidderType.yourBid;

            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacings.sm),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacings.sm,
                vertical: AppSpacings.sm,
              ),
              decoration: BoxDecoration(
                color: isYourBid ? const Color(0xFFF7F0E7) : AppColors.white,
                borderRadius: BorderRadius.circular(RadiusTokens.md),
              ),
              child: Row(
                children: [
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 3,
                    child: AppText(_rp(bid.amount), variant: AppTextVariant.labelLarge, fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AppText(
                        isYourBid ? 'Your Bid' : 'Online Bidder',
                        variant: AppTextVariant.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCTA extends StatelessWidget {
  final int lot;

  const _BottomCTA({required this.lot});

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
        label: 'Tawar Lot $lot',
        size: AppButtonSize.large,
        borderRadius: RadiusTokens.full,
        onPressed: () {},
      ),
    );
  }
}
