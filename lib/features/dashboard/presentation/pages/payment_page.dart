import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/data/models/payment_option.dart';
import 'package:emas/features/dashboard/domain/entities/payment_method.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatefulWidget {
  final int priceAmount;
  final int adminFee;
  final int nplFee;

  const PaymentPage({
    super.key,
    this.priceAmount = 150000000,
    this.adminFee = 1000000,
    this.nplFee = 5000000,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedMethodId;

  int get _totalPayment => widget.priceAmount + widget.adminFee - widget.nplFee;

  bool get _hasSelectedMethod => _selectedMethodId != null;

  void _activateMethod(String methodId) {
    setState(() => _selectedMethodId = methodId);
  }

  Future<void> _submitPayment() async {
    await context.push(AppRoutes.paymentGuide);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: AppPageBar(
        title: 'Detail Pembayaran',
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColors.info500),
            // TODO: navigasi ke riwayat pembayaran
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacings.md),
              children: [
                const AppText(
                  'Metode Pembayaran',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: AppSpacings.sm),
                ...dummyPaymentOptions.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacings.sm),
                    child: _PaymentOptionTile(
                      option: option,
                      isActive: _selectedMethodId == option.id,
                      onActivate: () => _activateMethod(option.id),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacings.xs),
                const _MorePaymentMethodsRow(),
                const SizedBox(height: AppSpacings.lg),
                const AppText(
                  'Ringkasan Pembayaran',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: AppSpacings.sm),
                _PaymentSummaryCard(
                  priceAmount: widget.priceAmount,
                  adminFee: widget.adminFee,
                  nplFee: widget.nplFee,
                ),
              ],
            ),
          ),
          _PaymentBottomBar(
            totalPayment: _totalPayment,
            showMethodWarning: !_hasSelectedMethod,
            onPay: _submitPayment,
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final PaymentOption option;
  final bool isActive;
  final VoidCallback onActivate;

  const _PaymentOptionTile({
    required this.option,
    required this.isActive,
    required this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      padding: const EdgeInsets.all(AppSpacings.md),
      borderColor: AppColors.neutral300,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: option.iconBackgroundColor,
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
            ),
            child: Icon(option.icon, color: AppColors.white, size: 20),
          ),
          const SizedBox(width: AppSpacings.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  option.name,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  isActive ? 'Metode pembayaran aktif' : option.activationHint,
                  variant: AppTextVariant.labelSmall,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacings.sm),
          if (!isActive)
            AppButton(
              label: 'Aktifkan',
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.small,
              isExpanded: false,
              borderWidth: 2,
              borderRadius: RadiusTokens.full,
              borderColor: AppColors.blue100,
              foregroundColor: AppColors.textPrimary,
              onPressed: onActivate,
            ),
        ],
      ),
    );
  }
}

class _MorePaymentMethodsRow extends StatelessWidget {
  const _MorePaymentMethodsRow();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      onTap: () async {
        await _showPaymentMethodSheet(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.md,
          vertical: AppSpacings.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.blue100,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              'Lihat Metode Pembayaran Lainnya',
              fontWeight: FontWeight.w600,
            ),
            Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

class _PaymentSummaryCard extends StatelessWidget {
  final int priceAmount;
  final int adminFee;
  final int nplFee;

  const _PaymentSummaryCard({
    required this.priceAmount,
    required this.adminFee,
    required this.nplFee,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      padding: const EdgeInsets.all(AppSpacings.md),
      borderColor: AppColors.neutral300,
      child: Column(
        children: [
          _SummaryRow(label: 'Harga Terbentuk', value: priceAmount),
          const SizedBox(height: AppSpacings.sm),
          _SummaryRow(label: 'Biaya Admin', value: adminFee),
          const SizedBox(height: AppSpacings.sm),
          _SummaryRow(label: 'Biaya NPL', value: nplFee),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final int value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, color: AppColors.textPrimary),
        AppText(
          label.contains('NPL') ? '- ${CurrencyFormatter.rupiah(value)}' : CurrencyFormatter.rupiah(value),
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _PaymentBottomBar extends StatelessWidget {
  final int totalPayment;
  final bool showMethodWarning;
  final VoidCallback? onPay;

  const _PaymentBottomBar({
    required this.totalPayment,
    required this.showMethodWarning,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.neutral200,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showMethodWarning) const _MethodWarningBanner(),
          Padding(
            padding: const EdgeInsets.all(
              AppSpacings.md,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'Total Pembayaran',
                        variant: AppTextVariant.labelSmall,
                        color: AppColors.textSecondary,
                      ),
                      AppText(
                        CurrencyFormatter.rupiah(totalPayment),
                        variant: AppTextVariant.titleSmall,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacings.md),
                AppButton(
                  label: 'Bayar',
                  isExpanded: false,
                  width: 140,
                  borderRadius: RadiusTokens.full,
                  onPressed: onPay,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodWarningBanner extends StatelessWidget {
  const _MethodWarningBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // color: AppColors.blue100,
      decoration: const BoxDecoration(
        color: AppColors.blue100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            AppSpacings.md,
          ),
          topRight: Radius.circular(
            AppSpacings.md,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.md,
        vertical: AppSpacings.sm,
      ),
      child: const Row(
        children: [
          Icon(Icons.info_rounded, size: 20, color: AppColors.warning500),
          SizedBox(width: AppSpacings.sm),
          Expanded(
            child: AppText(
              'Pilih metode pembayaran sebelum lanjut bayar',
              variant: AppTextVariant.labelSmall,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

const _paymentMethods = [
  PaymentMethod(
    id: 'mega_va',
    name: 'Bank Mega Virtual Account',
    logoAsset: 'assets/images/png/bank_mega.png',
  ),
  PaymentMethod(
    id: 'bca_va',
    name: 'BCA Virtual Account',
    logoAsset: 'assets/images/png/bank_bca.png',
  ),
  PaymentMethod(
    id: 'bri_va',
    name: 'BRI Virtual Account',
    logoAsset: 'assets/images/png/bank_bri.png',
  ),
  PaymentMethod(
    id: 'mandiri_va',
    name: 'Mandiri Virtual Account',
    logoAsset: 'assets/images/png/bank_mandiri.png',
  ),
  PaymentMethod(
    id: 'cimb_va',
    name: 'CIMB Niaga Virtual Account',
    logoAsset: 'assets/images/png/bank_cimb.png',
  ),
  PaymentMethod(
    id: 'dki_va',
    name: 'Bank DKI Virtual Account',
    logoAsset: 'assets/images/png/bank_dki.png',
  ),
];

Future<void> _showPaymentMethodSheet(BuildContext blocContext) async {
  await AppCustomBottomSheet.show<void>(
    blocContext,
    title: 'Metode Pembayaran',
    contentPadding: const EdgeInsets.only(
      top: AppSpacings.sm,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: _paymentMethods
          .map(
            (method) => _PaymentMethodTile(
              method: method,
              selected: false,
              onTap: () {
                blocContext.pop();
              },
            ),
          )
          .toList(),
    ),
  );
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.lg,
              vertical: AppSpacings.md,
            ),
            child: Row(
              children: [
                // ───────────────────────────────────────────────────────────
                // Bank Logo
                // ───────────────────────────────────────────────────────────

                _BankLogo(
                  logoAsset: method.logoAsset,
                ),

                const SizedBox(
                  width: AppSpacings.md,
                ),

                // ───────────────────────────────────────────────────────────
                // Bank Name
                // ───────────────────────────────────────────────────────────

                Expanded(
                  child: AppText(
                    method.name,
                    variant: AppTextVariant.labelMedium,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.primary500 : AppColors.textPrimary,
                  ),
                ),

                // ───────────────────────────────────────────────────────────
                // Selected Indicator
                // ───────────────────────────────────────────────────────────

                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary500,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
        const AppDivider(
          height: 1,
        ),
      ],
    );
  }
}

class _BankLogo extends StatelessWidget {
  final String logoAsset;
  final double size;

  const _BankLogo({
    required this.logoAsset,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        logoAsset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.circular(
                RadiusTokens.xs,
              ),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              size: 20,
              color: AppColors.neutral400,
            ),
          );
        },
      ),
    );
  }
}
