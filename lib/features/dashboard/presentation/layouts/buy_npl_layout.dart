import 'dart:async';

import 'package:emas/core/constants/app_elevations.dart';
import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/data/models/npl_item.dart';
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

String _formatDateTime(DateTime dt) {
  final hour = dt.hour.toString().padLeft(2, '0');
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${_shortMonths[dt.month]} ${dt.year}, $hour:$minute WIB';
}

class BuyNPLLayout extends StatefulWidget {
  const BuyNPLLayout({super.key});

  @override
  State<BuyNPLLayout> createState() => _BuyNPLLayoutState();
}

class _BuyNPLLayoutState extends State<BuyNPLLayout> {
  NPLStatus _selectedStatus = NPLStatus.unpaid;

  List<NPLItem> get _filteredItems => dummyNPLItems.where((item) => item.status == _selectedStatus).toList();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: AppPageBar(
        title: 'NPL',
        elevation: AppElevations.xs,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.info500),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const _BuyNPLRow(),
          _NPLTabBar(
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
                    itemBuilder: (context, i) => _NPLCard(item: _filteredItems[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NPLTabBar extends StatelessWidget {
  final NPLStatus selected;
  final ValueChanged<NPLStatus> onChanged;

  const _NPLTabBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
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
            label: 'Tagihan',
            isSelected: selected == NPLStatus.unpaid,
            onTap: () => onChanged(NPLStatus.unpaid),
          ),
          const SizedBox(width: AppSpacings.lg),
          _TabItem(
            label: 'NPL Aktif',
            isSelected: selected == NPLStatus.active,
            onTap: () => onChanged(NPLStatus.active),
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
              height: 4,
              color: isSelected ? AppColors.blue100 : AppColors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _NPLCard extends StatelessWidget {
  final NPLItem item;

  const _NPLCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPendingPayment = item.status == NPLStatus.unpaid;

    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacings.md),
      borderColor: AppColors.neutral300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_car_filled_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: AppSpacings.xs),
              AppText(
                item.categoryTitle,
                fontWeight: FontWeight.w600,
                variant: AppTextVariant.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.md),

          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Nomor NPL',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      item.nplNumber,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Jadwal',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      item.schedule,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.sm),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                'Lokasi',
                variant: AppTextVariant.labelSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 2),
              AppText(
                item.location,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const SizedBox(height: AppSpacings.sm),

          if (isPendingPayment)
            _NPLUnpaidSection(item: item)
          else
            // _NPLActiveSection(
            //   item: item,
            // ),
            const AppSpacer.xs(),
        ],
      ),
    );
  }
}

class _NPLUnpaidSection extends StatelessWidget {
  final NPLItem item;

  const _NPLUnpaidSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final dueDate = item.payBeforeDate;
    final total = item.totalBill;
    final methodName = item.paymentMethodName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Bayar sebelum',
                    variant: AppTextVariant.labelSmall,
                    color: AppColors.textPrimary,
                  ),
                  const AppSpacer.xxs(),
                  AppText(
                    dueDate != null ? _formatDateTime(dueDate) : '-',
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Total Tagihan',
                    variant: AppTextVariant.labelSmall,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    total != null ? CurrencyFormatter.rupiah(total) : '-',
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ],
        ),
        const AppSpacer.md(),
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.neutral200,
        ),
        const AppSpacer.md(),
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
            const SizedBox(width: AppSpacings.sm),
            SizedBox(
              width: 72,
              height: 32,
              child: AppButton(
                label: 'Bayar',
                size: AppButtonSize.small,
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.textPrimary,
                borderRadius: AppRadius.full,
                onPressed: () async {
                  await context.push(AppRoutes.paymentGuide);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}


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
              color: AppColors.info500,
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
          SizedBox(height: AppSpacings.md),
          AppText(
            'Belum ada transaksi',
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _BuyNPLRow extends StatelessWidget {
  const _BuyNPLRow();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () async {
        await context.push(AppRoutes.buyNpl);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          top: AppSpacings.lg,
          left: AppSpacings.md,
          right: AppSpacings.md,
          bottom: AppSpacings.xs,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.md,
          vertical: AppSpacings.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary500,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              'Beli NPL di sini',
              fontWeight: FontWeight.w600,
            ),
            Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
