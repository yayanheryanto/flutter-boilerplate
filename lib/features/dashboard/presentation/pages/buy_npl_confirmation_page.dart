import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/domain/entities/payment_method.dart';
import 'package:emas/features/dashboard/presentation/bloc/buy_npl_confirmation/buy_npl_confirmation_bloc.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_divider.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

class BuyNplConfirmationPage extends StatefulWidget {
  final int totalAmount;

  const BuyNplConfirmationPage({
    super.key,
    this.totalAmount = 8000000,
  });

  @override
  State<BuyNplConfirmationPage> createState() => _BuyNplConfirmationPageState();
}

class _BuyNplConfirmationPageState extends State<BuyNplConfirmationPage> {
  Future<void> _showPaymentMethodSheet(BuildContext blocContext) async {
    await AppCustomBottomSheet.show<void>(
      blocContext,
      title: 'Metode Pembayaran',
      contentPadding: const EdgeInsets.only(
        top: Spacings.sm,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _paymentMethods
            .map(
              (method) => _PaymentMethodTile(
                method: method,
                selected: blocContext.read<BuyNplConfirmationBloc>().state.selectedMethod?.id == method.id,
                onTap: () {
                  blocContext.read<BuyNplConfirmationBloc>().add(
                        PaymentMethodSelected(method),
                      );

                  blocContext.pop();
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BuyNplConfirmationBloc>(
      create: (_) => getIt<BuyNplConfirmationBloc>(),
      child: BlocBuilder<BuyNplConfirmationBloc, BuyNplConfirmationState>(
        builder: (context, state) {
          return AppScaffoldWrapper(
            backgroundColor: AppColors.white,
            appBar: const AppPageBar(
              title: 'Beli NPL',
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(
                      Spacings.md,
                    ),
                    children: [
                      const _SectionTitle(
                        'Ringkasan Pembelian',
                      ),
                      const SizedBox(
                        height: Spacings.sm,
                      ),
                      _InfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              'Total Tagihan',
                              variant: AppTextVariant.labelSmall,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            AppText(
                              CurrencyFormatter.rupiah(widget.totalAmount),
                              variant: AppTextVariant.titleMedium,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Spacings.lg,
                      ),
                      const _SectionTitle(
                        'Metode Pembayaran',
                      ),
                      const SizedBox(
                        height: Spacings.sm,
                      ),
                      _PaymentMethodSelector(
                        selected: state.selectedMethod,
                        onTap: () async {
                          await _showPaymentMethodSheet(context);
                        },
                      ),
                    ],
                  ),
                ),
                _BottomSection(
                  agreeToTerms: state.agreeToTerms,
                  canPay: state.canPay,
                  onAgreeChanged: (value) {
                    context.read<BuyNplConfirmationBloc>().add(
                          PaymentTermsChanged(
                            value ?? false,
                          ),
                        );
                  },
                  onPay: state.canPay
                      ? () {
                          // TODO:
                          // Navigate to payment result page.
                        }
                      : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return AppText(
      text,
      variant: AppTextVariant.titleMedium,
      fontWeight: FontWeight.w700,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        Spacings.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          RadiusTokens.lg,
        ),
        border: Border.all(
          color: AppColors.neutral200,
        ),
      ),
      child: child,
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod? selected;
  final VoidCallback onTap;

  const _PaymentMethodSelector({
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacings.md,
          vertical: Spacings.sm + 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            RadiusTokens.lg,
          ),
          border: Border.all(
            color: selected != null ? AppColors.primary500 : AppColors.neutral300,
          ),
        ),
        child: Row(
          children: [
            if (selected != null) ...[
              _BankLogo(
                logoAsset: selected!.logoAsset,
              ),
              const SizedBox(
                width: Spacings.sm,
              ),
            ],
            Expanded(
              child: AppText(
                selected?.name ?? 'Pilih metode pembayaran',
                color: selected != null ? AppColors.textPrimary : AppColors.neutral400,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.neutral400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
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
              horizontal: Spacings.lg,
              vertical: Spacings.md,
            ),
            child: Row(
              children: [
                _BankLogo(
                  logoAsset: method.logoAsset,
                ),
                const SizedBox(
                  width: Spacings.md,
                ),
                Expanded(
                  child: AppText(
                    method.name,
                    variant: AppTextVariant.labelMedium,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.primary500 : AppColors.textPrimary,
                  ),
                ),
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

  const _BankLogo({
    required this.logoAsset,
  });

  final double size = 36;

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

class _BottomSection extends StatelessWidget {
  final bool agreeToTerms;
  final bool canPay;
  final ValueChanged<bool?> onAgreeChanged;
  final VoidCallback? onPay;

  const _BottomSection({
    required this.agreeToTerms,
    required this.canPay,
    required this.onAgreeChanged,
    required this.onPay,
  });

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: agreeToTerms,
                  onChanged: onAgreeChanged,
                  activeColor: AppColors.primary500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: const BorderSide(
                    color: AppColors.neutral300,
                  ),
                ),
              ),
              const SizedBox(
                width: Spacings.sm,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Saya menyetujui ',
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {
                            // TODO:
                            // Buka halaman syarat & ketentuan.
                          },
                          child: const Text(
                            'Syarat dan Ketentuan EMAS',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.turquoise400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: Spacings.md,
          ),

          // ─────────────────────────────────────────────────────────────────
          // Bayar Button
          // ─────────────────────────────────────────────────────────────────

          AppButton(
            label: 'Bayar',
            borderRadius: RadiusTokens.full,
            onPressed: onPay,
          ),
        ],
      ),
    );
  }
}
