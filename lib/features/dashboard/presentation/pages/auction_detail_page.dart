import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/dashboard/presentation/bloc/auction_detail/auction_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── Page ─────────────────────────────────────────────────────────────────────

class AuctionDetailPage extends StatelessWidget {
  const AuctionDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuctionDetailBloc>()..add(const AuctionDetailStarted()),
      child: BlocBuilder<AuctionDetailBloc, AuctionDetailState>(
        builder: (context, state) => AppScaffoldWrapper(
          backgroundColor: AppColors.neutral50,
          appBar: const AppPageBar(title: 'Live Auction'),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // ── Preview Video/Gambar ─────────────────────
                    Container(
                      height: 220,
                      width: double.infinity,
                      color: AppColors.neutral300,
                      child: const Center(
                        child: Icon(
                          Icons.directions_car_rounded,
                          size: 64,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),

                    const SizedBox(height: Spacings.md),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacings.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Judul & Tahun ────────────────────────
                          const AppText(
                            'DAIHATSU GRAND MAX BV - 1.3',
                            variant: AppTextVariant.titleMedium,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 2),
                          const AppText(
                            'Tahun 2021',
                            variant: AppTextVariant.bodySmall,
                            color: AppColors.textPrimary,
                          ),

                          const SizedBox(height: Spacings.md),

                          // ── Harga Dasar + Info PPN ───────────────
                          const AppText(
                            'Harga Dasar',
                            variant: AppTextVariant.labelSmall,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              AppText(
                                CurrencyFormatter.rupiah(106000000),
                                variant: AppTextVariant.titleMedium,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(width: 8),
                              const AppText(
                                '*Terdapat biaya PPN 10%',
                                variant: AppTextVariant.labelSmall,
                                color: AppColors.textPrimary,
                              ),
                            ],
                          ),

                          const SizedBox(height: Spacings.lg),

                          // ── Card Grade & Spesifikasi ────────────
                          const _GradeAndSpecCard(),

                          const SizedBox(height: Spacings.lg),

                          // ── Section Penawaran Saat Ini ──────────
                          const AppText(
                            'Penawaran Saat Ini',
                            variant: AppTextVariant.titleSmall,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: Spacings.sm),

                          // Ringkasan Tertinggi & COUNT
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(Spacings.sm),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(Rounded.md),
                                    border: Border.all(color: AppColors.neutral200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const AppText(
                                        'Penawaran Tertinggi',
                                        variant: AppTextVariant.labelSmall,
                                        color: AppColors.textPrimary,
                                      ),
                                      const SizedBox(height: 2),
                                      AppText(
                                        CurrencyFormatter.rupiah(106000000),
                                        variant: AppTextVariant.titleSmall,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: Spacings.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacings.md,
                                  vertical: Spacings.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF9E6),
                                  borderRadius: BorderRadius.circular(Rounded.md),
                                  border: Border.all(color: AppColors.primary500),
                                ),
                                child: const Column(
                                  children: [
                                    AppText(
                                      'COUNT',
                                      variant: AppTextVariant.labelSmall,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    AppText(
                                      '1',
                                      variant: AppTextVariant.titleMedium,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: Spacings.sm),

                          // Daftar Riwayat Nominal Penawaran
                          const _BidsHistoryList(
                            bids: [106000000, 105500000, 105000000],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacings.xl),
                  ],
                ),
              ),

              // ── Bottom CTA ──────────────────────────────────────
              Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(
                  Spacings.md,
                  Spacings.sm,
                  Spacings.md,
                  Spacings.lg,
                ),
                child: AppButton(
                  label: 'Beli NPL',
                  borderRadius: Rounded.full,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Card Grade & Spesifikasi ─────────────────────────────────────────────────

class _GradeAndSpecCard extends StatelessWidget {
  const _GradeAndSpecCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacings.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Rounded.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sub-Section Grade ──
          AppText(
            'Grade',
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: Spacings.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _GradeItem(label: 'Interior', value: 'A'),
              _GradeItem(label: 'Eksterior', value: 'D'),
              _GradeItem(label: 'Rangka', value: 'B'),
              _GradeItem(label: 'Mesin', value: 'C'),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: Spacings.sm),
            child: Divider(color: AppColors.neutral200),
          ),

          // ── Sub-Section Spesifikasi ──
          AppText(
            'Spesifikasi',
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: Spacings.xs),
          _SpecRow(label: 'Nomor Polisi', value: 'BK8769ET'),
          _SpecRow(label: 'Kilometer', value: '142.524 KM'),
          _SpecRow(label: 'STNK', value: '27 Mei 2026'),
          _SpecRow(label: 'BPKB', value: '14 Hari Kerja'),
        ],
      ),
    );
  }
}

// ─── Component Grade Badge ────────────────────────────────────────────────────

class _GradeItem extends StatelessWidget {
  final String label;
  final String value;

  const _GradeItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          label,
          variant: AppTextVariant.labelSmall,
          color: AppColors.textPrimary,
        ),
        const SizedBox(height: 4),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9E6),
            borderRadius: BorderRadius.circular(Rounded.md),
            border: Border.all(color: AppColors.primary500.withOpacity(0.6)),
          ),
          child: Center(
            child: AppText(
              value,
              variant: AppTextVariant.titleMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Component Spesifikasi Row ────────────────────────────────────────────────

class _SpecRow extends StatelessWidget {
  final String label;
  final String value;

  const _SpecRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            variant: AppTextVariant.bodySmall,
            color: AppColors.textPrimary,
          ),
          AppText(
            value,
            variant: AppTextVariant.bodySmall,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

// ─── Component List Riwayat Penawaran ─────────────────────────────────────────

class _BidsHistoryList extends StatelessWidget {
  final List<int> bids;

  const _BidsHistoryList({required this.bids});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(Rounded.md),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: List.generate(bids.length, (index) {
          final isLast = index == bids.length - 1;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacings.md,
                  vertical: Spacings.sm + 2,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    CurrencyFormatter.rupiah(bids[index]),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isLast) const Divider(height: 1, color: AppColors.neutral200),
            ],
          );
        }),
      ),
    );
  }
}
