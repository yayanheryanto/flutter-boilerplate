import 'dart:async';

import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/data/models/transaction_item.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const _shortMonths = [
  '',
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Formats "4 Nov 2026, 09:33 WIB" without depending on `intl`'s locale
/// initialization for `DateFormat`.
String _formatDateTime(DateTime dt) {
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${_shortMonths[dt.month]} ${dt.year}, $hour:$minute WIB';
}

class TransactionLayout extends StatefulWidget {
  const TransactionLayout({super.key});

  @override
  State<TransactionLayout> createState() => _TransactionLayoutState();
}

class _TransactionLayoutState extends State<TransactionLayout> {
  TransactionStatus _selectedStatus = TransactionStatus.unpaid;

  List<TransactionItem> get _filteredItems => dummyTransactionItems.where((item) => item.status == _selectedStatus).toList();

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
                    padding: const EdgeInsets.all(Spacings.md),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: Spacings.md),
                    itemBuilder: (context, i) => _TransactionCard(item: _filteredItems[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTabBar extends StatelessWidget {
  final TransactionStatus selected;
  final ValueChanged<TransactionStatus> onChanged;

  const _TransactionTabBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral200,
          ),
        ),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Belum Dibayar',
            isSelected: selected == TransactionStatus.unpaid,
            onTap: () => onChanged(TransactionStatus.unpaid),
          ),
          const SizedBox(width: Spacings.lg),
          _TabItem(
            label: 'Menunggu Pembayaran',
            isSelected: selected == TransactionStatus.pendingPayment,
            onTap: () => onChanged(TransactionStatus.pendingPayment),
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
    final color = isSelected ? AppColors.textPrimary : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacings.md),
              child: AppText(
                label,
                textAlign: TextAlign.center,
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 4,
              color: isSelected ? AppColors.blue100 : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionItem item;

  const _TransactionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPendingPayment = item.status == TransactionStatus.pendingPayment;

    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(Rounded.lg),
      padding: const EdgeInsets.all(Spacings.md),
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
                  borderRadius: BorderRadius.circular(Rounded.md),
                ),
                child: const Icon(
                  Icons.directions_car_rounded,
                  color: AppColors.neutral400,
                  size: 32,
                ),
              ),
              const SizedBox(width: Spacings.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item.vehicleName,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      '${item.licensePlate} | ${item.year} | LOT ${item.lot}',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: Spacings.sm),
                    const AppText(
                      'Harga Terbentuk',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
                    AppText(
                      CurrencyFormatter.rupiah(item.formedPrice),
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacings.md),
          if (isPendingPayment)
            _PendingPaymentSection(item: item)
          else
            _UnpaidActions(
              item: item,
            ),
        ],
      ),
    );
  }
}

// ─── Actions for "unpaid" status ───────────────────────────────────────────────

class _UnpaidActions extends StatelessWidget {
  final TransactionItem item;

  const _UnpaidActions({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Lihat Detail',
            variant: AppButtonVariant.outlined,
            borderRadius: Rounded.full,
            borderColor: AppColors.blue100,
            size: AppButtonSize.small,
            borderWidth: 2,
            foregroundColor: AppColors.textPrimary,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: Spacings.md),
        Expanded(
          child: AppButton(
            label: 'Bayar',
            size: AppButtonSize.small,
            borderRadius: Rounded.full,
            onPressed: () async {
              await context.push(Routes.payment);
            },
          ),
        ),
      ],
    );
  }
}

// ─── Section for "pending payment" status ──────────────────────────────────────

class _PendingPaymentSection extends StatelessWidget {
  final TransactionItem item;

  const _PendingPaymentSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final dueDate = item.payBeforeDate;
    final total = item.totalBill;
    final methodName = item.paymentMethodName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Top Information (Bayar sebelum & Total Tagihan) ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Bayar sebelum',
                    variant: AppTextVariant.labelSmall,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    dueDate != null ? _formatDateTime(dueDate) : '-',
                    variant: AppTextVariant.labelMedium,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const AppText(
                  'Total Tagihan',
                  variant: AppTextVariant.labelSmall,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 4),
                AppText(
                  total != null ? CurrencyFormatter.rupiah(total) : '-',
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: Spacings.md),

        // ── Divider Line ──
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.neutral200,
        ),

        const SizedBox(height: Spacings.md),

        // ── Bottom Section (Countdown & Action Button) ──
        Row(
          children: [
            Expanded(
              child: dueDate != null
                  ? _CountdownLabel(
                      dueDate: dueDate,
                      paymentMethodName: methodName ?? '-',
                    )
                  : const AppText(
                      'Selesaikan pembayaran segera',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
            ),
            const SizedBox(width: Spacings.sm),
            SizedBox(
              width: 80,
              child: AppButton(
                label: 'Bayar',
                size: AppButtonSize.small,
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.textPrimary,
                borderRadius: Rounded.full,
                onPressed: () async {
                  await context.push(Routes.paymentGuide);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// "Bayar dalam **HH:MM:SS** dengan <method>" — the countdown digits tick
/// down every second until [dueDate].
class _CountdownLabel extends StatefulWidget {
  final DateTime dueDate;
  final String paymentMethodName;

  const _CountdownLabel({
    required this.dueDate,
    required this.paymentMethodName,
  });

  @override
  State<_CountdownLabel> createState() => _CountdownLabelState();
}

class _CountdownLabelState extends State<_CountdownLabel> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _computeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = _computeRemaining());
    });
  }

  Duration _computeRemaining() {
    final diff = widget.dueDate.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String get _formatted {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(_remaining.inHours)}:${two(_remaining.inMinutes.remainder(60))}:${two(_remaining.inSeconds.remainder(60))}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 12,
      color: AppColors.textPrimary,
    );

    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'Bayar dalam '),
          TextSpan(
            text: _formatted,
            style: const TextStyle(
              color: AppColors.info500, // Warna biru cerah/cyan sesuai desain
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: ' dengan ${widget.paymentMethodName}'),
        ],
      ),
    );
  }
}

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
          SizedBox(height: Spacings.md),
          AppText(
            'Belum ada transaksi',
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}
