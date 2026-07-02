import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ─── Model lokal ──────────────────────────────────────────────────────────────

class _GradeData {
  final String label;
  final String value;

  const _GradeData({required this.label, required this.value});
}

class _SpesifikasiData {
  final String key;
  final String value;

  const _SpesifikasiData({required this.key, required this.value});
}

// ─── Dummy data ───────────────────────────────────────────────────────────────

const _dummyGrades = [
  _GradeData(label: 'Interior', value: 'A'),
  _GradeData(label: 'Eksterior', value: 'D'),
  _GradeData(label: 'Rangka', value: 'B'),
  _GradeData(label: 'Mesin', value: 'C'),
];

const _dummySpesifikasi = [
  _SpesifikasiData(key: 'Nomor Polisi', value: 'BK8769ET'),
  _SpesifikasiData(key: 'Kilometer', value: '142.524 KM'),
  _SpesifikasiData(key: 'STNK', value: '27 Mei 2026'),
  _SpesifikasiData(key: 'BPKB', value: '14 Hari Kerja'),
];

final _dummyPenawaran = [106000000, 105500000, 105000000];

// ─── Currency formatter (full, no abbreviation) ───────────────────────────────

String _formatRupiahFull(int amount) {
  final fmt = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return fmt.format(amount);
}

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
          // Scrollable content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // ── Thumbnail / Media placeholder ──────────────────────
                _MediaPlaceholder(),

                // ── Info utama kendaraan ───────────────────────────────
                WhiteSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'DAIHATSU GRAND MAX BV - 1.3',
                        variant: AppTextVariant.titleMedium,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 2),
                      const AppText(
                        'Tahun 2021',
                        fontWeight: FontWeight.w500,
                      ),
                      const AppSpacer.md(),
                      const AppText(
                        'Harga Dasar',
                        variant: AppTextVariant.bodySmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AppText(
                            _formatRupiahFull(106000000),
                            variant: AppTextVariant.titleLarge,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(width: AppSpacings.xs),
                          const AppText(
                            '*Terdapat biaya PPN 10%',
                            variant: AppTextVariant.labelSmall,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const AppSpacer.sm(),

                // ── Grade ──────────────────────────────────────────────
                WhiteSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'Grade',
                        variant: AppTextVariant.titleSmall,
                        fontWeight: FontWeight.w600,
                      ),
                      const AppSpacer.md(),
                      Row(
                        children: _dummyGrades
                            .map(
                              (g) => Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacings.md,
                                ),
                                child: _GradeChip(data: g),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),

                const AppSpacer.sm(),

                // ── Spesifikasi ────────────────────────────────────────
                WhiteSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'Spesifikasi',
                        variant: AppTextVariant.titleSmall,
                        fontWeight: FontWeight.w600,
                      ),
                      const AppSpacer.md(),
                      ..._dummySpesifikasi.map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacings.sm),
                          child: _SpecRow(data: s),
                        ),
                      ),
                    ],
                  ),
                ),

                const AppSpacer.sm(),

                // ── Penawaran Saat Ini ─────────────────────────────────
                WhiteSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'Penawaran Saat Ini',
                        variant: AppTextVariant.titleSmall,
                        fontWeight: FontWeight.w600,
                      ),
                      const AppSpacer.md(),

                      // Penawaran tertinggi + count badge
                      _TopBidRow(amount: _dummyPenawaran.first),

                      const AppSpacer.sm(),

                      // Daftar penawaran lain
                      ..._dummyPenawaran.map(
                        (amount) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacings.sm),
                          child: _BidRow(amount: amount),
                        ),
                      ),
                    ],
                  ),
                ),

                const AppSpacer.lg(),
              ],
            ),
          ),

          // ── CTA fixed di bawah ─────────────────────────────────────
          _BottomCTA(),
        ],
      ),
    );
  }
}

// ─── Media Placeholder ────────────────────────────────────────────────────────

const List<String> dummyBannerUrls = [
  'https://oss.megafinance.co.id/development/mitra-megapromotion/2024/04/05/promo1.jpeg',
  'https://oss.megafinance.co.id/development/mitra-megapromotion/2024/04/05/promo2.jpeg',
  'https://oss.megafinance.co.id/development/mitra-megapromotion/2024/04/05/promo3.jpeg',
];

class _MediaPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      color: AppColors.neutral200,
      child: Center(
        child: AppImage(
          src: dummyBannerUrls[0],
          width: double.infinity,
        ),
      ),
    );
  }
}

// ─── Grade chip ───────────────────────────────────────────────────────────────

class _GradeChip extends StatelessWidget {
  final _GradeData data;

  const _GradeChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText(
          data.label,
          variant: AppTextVariant.labelSmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 6),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            border: Border.all(color: AppColors.primary500, width: 1.5),
          ),
          child: Center(
            child: AppText(
              data.value,
              variant: AppTextVariant.titleLarge,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Spec row ─────────────────────────────────────────────────────────────────

class _SpecRow extends StatelessWidget {
  final _SpesifikasiData data;

  const _SpecRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          data.key,
          color: AppColors.textSecondary,
        ),
        AppText(
          data.value,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }
}

// ─── Top bid row (penawaran tertinggi + count badge) ──────────────────────────
class _TopBidRow extends StatelessWidget {
  final int amount;

  const _TopBidRow({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacings.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Penawaran Tertinggi',
                  variant: AppTextVariant.labelSmall,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 4),
                AppText(
                  _formatRupiahFull(amount),
                  variant: AppTextVariant.titleMedium,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacings.md),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            border: Border.all(
              color: AppColors.primary500,
              width: 1.5,
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                'COUNT',
                variant: AppTextVariant.labelSmall,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2),
              AppText(
                '1',
                variant: AppTextVariant.titleLarge,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Bid row (daftar penawaran) ───────────────────────────────────────────────

class _BidRow extends StatelessWidget {
  final int amount;

  const _BidRow({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm + 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.md),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: AppText(
        _formatRupiahFull(amount),
        variant: AppTextVariant.titleSmall,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCTA extends StatelessWidget {
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
        label: 'Beli NPL',
        size: AppButtonSize.large,
        onPressed: () {
          // TODO: navigate to beli NPL flow
        },
      ),
    );
  }
}

// ─── Section wrapper putih ────────────────────────────────────────────────────

class WhiteSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const WhiteSection({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSpacings.md,
            vertical: AppSpacings.lg,
          ),
      child: child,
    );
  }
}
