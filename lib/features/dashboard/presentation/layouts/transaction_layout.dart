import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/data/models/transaction_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionLayout extends StatefulWidget {
  const TransactionLayout({super.key});

  @override
  State<TransactionLayout> createState() => _TransactionLayoutState();
}

class _TransactionLayoutState extends State<TransactionLayout> {
  TransaksiStatus _selectedStatus = TransaksiStatus.belumDibayar;

  List<TransactionItem> get _filteredItems =>
      dummyTransactionItems.where((item) => item.status == _selectedStatus).toList();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: AppPageBar(
        title: 'Transaksi',
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.info500),
            // TODO: navigasi ke riwayat transaksi
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _TransactionTabBar(
            selected: _selectedStatus,
            onChanged: (status) => setState(() => _selectedStatus = status),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const _EmptyState()
                : ListView.separated(
              padding: const EdgeInsets.all(AppSpacings.md),
              itemCount: _filteredItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacings.md),
              itemBuilder: (context, i) => _TransaksiCard(item: _filteredItems[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab bar ──────────────────────────────────────────────────────────────────

class _TransactionTabBar extends StatelessWidget {
  final TransaksiStatus selected;
  final ValueChanged<TransaksiStatus> onChanged;

  const _TransactionTabBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacings.md),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.neutral200)),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Belum Dibayar',
            isSelected: selected == TransaksiStatus.belumDibayar,
            onTap: () => onChanged(TransaksiStatus.belumDibayar),
          ),
          const SizedBox(width: AppSpacings.lg),
          _TabItem(
            label: 'Menunggu Pembayaran',
            isSelected: selected == TransaksiStatus.menungguPembayaran,
            onTap: () => onChanged(TransaksiStatus.menungguPembayaran),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.textPrimary : AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacings.md),
              child: AppText(
                label,
                textAlign: TextAlign.center,
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 2,
              color: isSelected ? AppColors.info500 : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Transaksi card ───────────────────────────────────────────────────────────

class _TransaksiCard extends StatelessWidget {
  final TransactionItem item;

  const _TransaksiCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      padding: const EdgeInsets.all(AppSpacings.md),
      borderColor: AppColors.neutral300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.neutral400,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacings.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item.namaKendaraan,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      '${item.noPolisi} | ${item.tahun} | LOT ${item.lot}',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSpacings.sm),
                    const AppText(
                      'Harga Terbentuk',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textSecondary,
                    ),
                    AppText(
                      CurrencyFormatter.rupiah(item.hargaTerbentuk),
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.md),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Lihat Detail',
                  variant: AppButtonVariant.outlined,
                  borderRadius: RadiusTokens.full,
                  borderColor: AppColors.info500,
                  foregroundColor: AppColors.textPrimary,
                  // TODO: navigasi ke halaman detail transaksi
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: AppSpacings.sm),
              Expanded(
                child: AppButton(
                  label: 'Bayar',
                  borderRadius: RadiusTokens.full,
                  onPressed: () async {
                    await context.push(AppRoutes.payment);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppColors.neutral300,
          ),
          SizedBox(height: AppSpacings.md),
          AppText(
            'Belum ada transaksi',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
