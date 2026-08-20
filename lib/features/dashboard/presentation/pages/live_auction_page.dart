import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/services/socket/app_socket_service.dart';
import 'package:emas/features/dashboard/data/models/live_auction_models.dart';
import 'package:emas/features/dashboard/presentation/bloc/live_auction/live_auction_bloc.dart';
import 'package:emas/features/dashboard/presentation/widgets/home/live_badge.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ─── Formatter ────────────────────────────────────────────────────────────────

String _rp(int v) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(v);

// ─── Page ─────────────────────────────────────────────────────────────────────
//
// Live bidding didukung oleh [LiveAuctionBloc] + dummy WebSocket
// ([DummySocketService]) — lihat lib/core/services/socket/. Tinggal ganti
// binding AppSocketService di DI kalau backend real-time sudah siap, tidak
// ada perubahan lain yang dibutuhkan di halaman ini.

class LiveAuctionPage extends StatelessWidget {
  final int lot;

  const LiveAuctionPage({super.key, this.lot = 15});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LiveAuctionBloc>(
      create: (_) => getIt<LiveAuctionBloc>()..add(LiveAuctionStarted(lot: lot)),
      child: const _LiveAuctionView(),
    );
  }
}

class _LiveAuctionView extends StatefulWidget {
  const _LiveAuctionView();

  @override
  State<_LiveAuctionView> createState() => _LiveAuctionViewState();
}

class _LiveAuctionViewState extends State<_LiveAuctionView> {
  int _lastBidCount = 0;

  @override
  void dispose() {
    // context.read<LiveAuctionBloc>().add(const LiveAuctionStopped());
    super.dispose();
  }

  void _handleSideEffects(BuildContext context, LiveAuctionState state) {
    // Toast ketika ada bid baru yang menyalip tawaran kita.
    if (state.bids.length > _lastBidCount) {
      final newest = state.bids.first;
      final gotOutbid = newest.type != BidderType.yourBid && state.bids.length > 1 && state.bids[1].type == BidderType.yourBid;

      if (gotOutbid) {
        AppToast.show(
          'Tawaran Anda disalip ${newest.bidderName} — ${_rp(newest.amount)}',
          type: AppToastType.error,
        );
      }
    }
    _lastBidCount = state.bids.length;

    if (state.status == LiveAuctionStatus.ended && state.winningBid != null) {
      AppToast.show(
        'Lelang berakhir. Pemenang: ${state.winningBid!.bidderName} — ${_rp(state.winningBid!.amount)}',
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveAuctionBloc, LiveAuctionState>(
      listener: _handleSideEffects,
      builder: (context, state) {
        return AppScaffoldWrapper(
          backgroundColor: AppColors.neutral50,
          appBar: AppPageBar(
            onBack: () => context.pop(),
            title: 'Live Auction',
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacings.md),
                child: Center(child: _ConnectionStatusChip(state: state)),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // ── Lokasi + viewer count ────────────────────
                    _LokasiBar(
                      lokasi: 'Mega Finance Fatmawati',
                      viewerCount: state.viewerCount,
                    ),

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
                      child: _MainInfoCard(state: state),
                    ),

                    const SizedBox(height: AppSpacings.lg),

                    // ── Penawaran Saat Ini ───────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                'Penawaran Saat Ini',
                                variant: AppTextVariant.titleSmall,
                                fontWeight: FontWeight.w700,
                              ),
                              if (state.isLive) const LiveBadge(),
                            ],
                          ),
                          const SizedBox(height: AppSpacings.sm),
                          state.status == LiveAuctionStatus.connecting ? const _BidTableSkeleton() : _BidTable(bids: state.bids),
                          if (state.status == LiveAuctionStatus.endingSoon && state.endingInSeconds != null) ...[
                            const SizedBox(height: AppSpacings.sm),
                            _EndingSoonBanner(secondsLeft: state.endingInSeconds!),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacings.xl),
                  ],
                ),
              ),
              _BottomCTA(lot: state.lot == 0 ? 15 : state.lot, state: state),
            ],
          ),
        );
      },
    );
  }
}

// ─── Connection status chip ─────────────────────────────────────────────────

class _ConnectionStatusChip extends StatelessWidget {
  final LiveAuctionState state;

  const _ConnectionStatusChip({required this.state});

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;

    switch (state.connectionStatus) {
      case SocketConnectionStatus.connecting:
        label = 'Menghubungkan…';
        color = AppColors.neutral400;
      case SocketConnectionStatus.reconnecting:
        label = 'Menghubungkan ulang…';
        color = AppColors.warning500;
      case SocketConnectionStatus.connected:
        label = state.status == LiveAuctionStatus.ended ? 'Berakhir' : 'Terhubung';
        color = state.status == LiveAuctionStatus.ended ? AppColors.neutral400 : AppColors.success500;
      case SocketConnectionStatus.disconnected:
        label = 'Terputus';
        color = AppColors.error500;
    }

    return AppBadge(
      label: label,
      backgroundColor: color.withOpacity(0.12),
      textColor: color,
    );
  }
}

// ─── Ending soon banner ──────────────────────────────────────────────────────

class _EndingSoonBanner extends StatelessWidget {
  final int secondsLeft;

  const _EndingSoonBanner({required this.secondsLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning500.withOpacity(0.12),
        borderRadius: BorderRadius.circular(RadiusTokens.md),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.timer_outlined,
            size: 18,
            color: AppColors.warning500,
          ),
          const SizedBox(width: 6),
          AppText(
            'Lelang akan segera berakhir dalam $secondsLeft detik',
            variant: AppTextVariant.bodySmall,
            color: AppColors.warning500,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

// ─── Lokasi bar ───────────────────────────────────────────────────────────────

class _LokasiBar extends StatelessWidget {
  final String lokasi;
  final int viewerCount;

  const _LokasiBar({required this.lokasi, required this.viewerCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.md,
        AppSpacings.md,
        AppSpacings.md,
        AppSpacings.xs,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Expanded(child: AppText(lokasi, color: AppColors.textSecondary)),
          // const Icon(
          //   Icons.visibility_outlined,
          //   size: 16,
          //   color: AppColors.textSecondary,
          // ),
          // const SizedBox(width: 4),
          // AppText(
          //   '$viewerCount menonton',
          //   variant: AppTextVariant.bodySmall,
          //   color: AppColors.textSecondary,
          // ),
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

  const _LotHeader({
    required this.lot,
    required this.nama,
    required this.tahun,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.md,
        AppSpacings.sm,
        AppSpacings.md,
        AppSpacings.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LOT
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary500,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: AppText(
              'Lot $lot',
              variant: AppTextVariant.labelLarge,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),

          const SizedBox(width: 10),

          // NAMA + TAHUN
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  nama,
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                AppText(
                  tahun,
                  variant: AppTextVariant.bodySmall,
                  fontWeight: FontWeight.w600,
                ),
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
  final LiveAuctionState state;

  const _MainInfoCard({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================================================
        // LEFT COLUMN
        // ============================================================
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _vehicleImage(),

              const SizedBox(height: 8),

              _priceCard(state),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // ============================================================
        // RIGHT COLUMN
        // ============================================================
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _specCard(),

              const SizedBox(height: 10),

              _gradeCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _vehicleImage() {
    return Container(
      height: 115,
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          size: 48,
          color: AppColors.neutral400,
        ),
      ),
    );
  }

  Widget _specCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.neutral200,
                ),
              ),
            ),
            child: const AppText(
              'Spesifikasi Kendaraan',
              variant: AppTextVariant.labelMedium,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          const _SpecItem(
            label: 'No. Polisi',
            value: 'BK8769ET',
          ),

          const _SpecItem(
            label: 'Kilometer',
            value: '142.524 KM',
          ),

          const _SpecItem(
            label: 'Masa Berlaku STNK',
            value: '27 Mei 2026',
          ),
        ],
      ),
    );
  }

  Widget _priceCard(LiveAuctionState state) {
    final isConnecting =
        state.status == LiveAuctionStatus.connecting;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            'Harga Dasar',
            variant: AppTextVariant.labelSmall,
            color: AppColors.textSecondary,
          ),

          const SizedBox(height: 2),

          isConnecting
              ? const SkeletonText(
            width: 120,
            height: 20,
          )
              : AppText(
            _rp(state.basePrice),
            variant: AppTextVariant.titleSmall,
            fontWeight: FontWeight.w800,
          ),

          const SizedBox(height: 6),

          const AppText(
            'Harga Penawaran Sekarang',
            variant: AppTextVariant.labelSmall,
            color: AppColors.textSecondary,
          ),

          const SizedBox(height: 2),

          isConnecting
              ? const SkeletonText(
            width: 120,
            height: 20,
          )
              : AppText(
            _rp(state.currentPrice),
            variant: AppTextVariant.titleSmall,
            fontWeight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget _gradeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.neutral200,
        ),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _GradeItem(
                  label: 'Interior',
                  value: 'A',
                ),
              ),
              Expanded(
                child: _GradeItem(
                  label: 'Rangka',
                  value: 'B',
                ),
              ),
            ],
          ),

          AppSpacer.xs(),

          Row(
            children: [
              Expanded(
                child: _GradeItem(
                  label: 'Eksterior',
                  value: 'D',
                ),
              ),
              Expanded(
                child: _GradeItem(
                  label: 'Mesin',
                  value: 'C',
                ),
              ),
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

  const _SpecItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            variant: AppTextVariant.labelSmall,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 1),
          AppText(
            value,
            variant: AppTextVariant.labelLarge,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

// ─── Grade item ───────────────────────────────────────────────────────────────

class _GradeItem extends StatelessWidget {
  final String label;
  final String value;

  const _GradeItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const AppSpacer.xs(horizontal: true,),
        AppText(
          label,
          variant: AppTextVariant.labelSmall,
          color: AppColors.textSecondary,
        ),

        const Spacer(),

        AppText(
          value,
          variant: AppTextVariant.labelLarge,
          fontWeight: FontWeight.w800,
        ),
        const AppSpacer.xs(horizontal: true,),
      ],
    );
  }
}

// ─── Bid table skeleton (dipakai saat status connecting) ──────────────────────

class _BidTableSkeleton extends StatelessWidget {
  const _BidTableSkeleton();

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
        children: List.generate(
          4,
          (i) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacings.sm),
            child: Row(
              children: [
                Expanded(flex: 2, child: SkeletonText(height: 14)),
                SizedBox(width: AppSpacings.sm),
                Expanded(flex: 3, child: SkeletonText(height: 14)),
                SizedBox(width: AppSpacings.sm),
                Expanded(flex: 2, child: SkeletonText(height: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bid table ────────────────────────────────────────────────────────────────

class _BidTable extends StatelessWidget {
  final List<BidEntry> bids;

  const _BidTable({
    required this.bids,
  });

  @override
  Widget build(BuildContext context) {
    if (bids.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacings.lg),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.neutral200,
          ),
        ),
        child: const Center(
          child: AppText(
            'Belum ada penawaran',
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neutral200,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Semua bid menggunakan row yang sama
            ...bids.take(5).toList().asMap().entries.map(
                  (entry) {
                final index = entry.key;
                final bid = entry.value;

                return _BidRow(
                  bid: bid,
                  isFirst: index == 0,
                  isLast: index == bids.take(5).length - 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BidRow extends StatelessWidget {
  final BidEntry bid;
  final bool isFirst;
  final bool isLast;

  const _BidRow({
    required this.bid,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isYourBid = bid.type == BidderType.yourBid;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: !isLast
            ? const Border(
          bottom: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        )
            : null,
      ),
      child: Row(
        children: [
          // ============================================================
          // COUNT
          // Tetap putih, tidak ikut background Your Bid
          // ============================================================
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              child: AppText(
                isFirst ? 'COUNT' : '',
                variant: AppTextVariant.labelMedium,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // ============================================================
          // BID + BIDDER
          // Background Your Bid hanya di area ini
          // ============================================================
          Expanded(
            flex: 5,
            child: Container(
              color: isYourBid
                  ? const Color(0xFFF8F1E9)
                  : AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Row(
                children: [
                  // NOMINAL
                  Expanded(
                    flex: 3,
                    child: AppText(
                      _rp(bid.amount),
                      variant: AppTextVariant.labelLarge,
                      fontWeight: isFirst
                          ? FontWeight.w800
                          : FontWeight.w700,
                    ),
                  ),

                  // BIDDER
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AppText(
                        isYourBid
                            ? 'Your Bid'
                            : 'Online Bidder',
                        variant: AppTextVariant.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _BidHistoryRow extends StatelessWidget {
  final BidEntry bid;
  final bool isLast;

  const _BidHistoryRow({
    required this.bid,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isYourBid = bid.type == BidderType.yourBid;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isYourBid
            ? const Color(0xFFF8F1E9)
            : AppColors.white,
        border: isLast
            ? null
            : const Border(
          top: BorderSide(
            color: AppColors.neutral200,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // LEFT EMPTY SPACE
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),

          // BID AMOUNT
          Expanded(
            flex: 3,
            child: AppText(
              _rp(bid.amount),
              variant: AppTextVariant.labelLarge,
              fontWeight: FontWeight.w700,
            ),
          ),

          // BIDDER
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppText(
                isYourBid
                    ? 'Your Bid'
                    : 'Online Bidder',
                variant: AppTextVariant.bodySmall,
                color: AppColors.textPrimary,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCTA extends StatelessWidget {
  final int lot;
  final LiveAuctionState state;

  const _BottomCTA({required this.lot, required this.state});

  @override
  Widget build(BuildContext context) {
    final canBid = state.isLive && !state.isPlacingBid;
    final label = state.status == LiveAuctionStatus.ended
        ? 'Lelang Berakhir'
        : state.status == LiveAuctionStatus.connecting
            ? 'Menghubungkan…'
            : 'Tawar ${_rp(state.nextBidAmount)}';

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppSpacings.md,
        AppSpacings.sm,
        AppSpacings.md,
        AppSpacings.lg,
      ),
      child: AppButton(
        label: label,
        size: AppButtonSize.large,
        borderRadius: RadiusTokens.full,
        isLoading: state.isPlacingBid,
        onPressed: canBid
            ? () => context.read<LiveAuctionBloc>().add(
                  LiveAuctionBidPlaced(amount: state.nextBidAmount),
                )
            : null,
      ),
    );
  }
}
