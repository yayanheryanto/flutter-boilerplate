import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_divider.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// ─── Model metode pembayaran ──────────────────────────────────────────────────

class PaymentMethod {
  final String id;
  final String name;
  final String logoAsset;
  final Color logoColor;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.logoAsset,
    this.logoColor = Colors.transparent,
  });
}

// ─── Daftar metode pembayaran dummy ──────────────────────────────────────────

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

// ─── Currency formatter ───────────────────────────────────────────────────────

String _rupiah(int amount) => NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(amount);

// ─── Page ─────────────────────────────────────────────────────────────────────

class BeliNplConfirmationPage extends StatefulWidget {
  final int totalTagihan;

  const BeliNplConfirmationPage({
    super.key,
    this.totalTagihan = 8000000,
  });

  @override
  State<BeliNplConfirmationPage> createState() => _BeliNplConfirmationPageState();
}

class _BeliNplConfirmationPageState extends State<BeliNplConfirmationPage> {
  PaymentMethod? _selectedMethod;
  bool _agreeToTerms = false;

  bool get _canPay => _selectedMethod != null && _agreeToTerms;

  // ── Buka bottom sheet pilih metode ─────────────────────────────────────────
  Future<void> _showPaymentMethodSheet() async {
    await AppCustomBottomSheet.show<void>(
      context,
      title: 'Metode Pembayaran',
      contentPadding: const EdgeInsets.only(top: AppSpacings.sm),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _paymentMethods
            .map(
              (method) => _PaymentMethodTile(
                method: method,
                selected: _selectedMethod?.id == method.id,
                onTap: () {
                  setState(() => _selectedMethod = method);
                  context.pop();
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(title: 'Beli NPL'),
      body: Column(
        children: [
          // ── Scrollable content ───────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacings.md),
              children: [
                // ── Ringkasan Pembelian ─────────────────────────
                const _SectionTitle('Ringkasan Pembelian'),
                const SizedBox(height: AppSpacings.sm),
                _InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'Total Tagihan',
                        variant: AppTextVariant.labelSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        _rupiah(widget.totalTagihan),
                        variant: AppTextVariant.titleMedium,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacings.lg),

                // ── Metode Pembayaran ───────────────────────────
                const _SectionTitle('Metode Pembayaran'),
                const SizedBox(height: AppSpacings.sm),
                _PaymentMethodSelector(
                  selected: _selectedMethod,
                  onTap: _showPaymentMethodSheet,
                ),
              ],
            ),
          ),

          // ── Fixed bottom: checkbox + tombol bayar ────────────
          _BottomSection(
            agreeToTerms: _agreeToTerms,
            canPay: _canPay,
            onAgreeChanged: (v) => setState(() => _agreeToTerms = v ?? false),
            onPay: _canPay
                ? () {
                    // TODO: navigate to payment result page
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

// ─── Section title ────────────────────────────────────────────────────────────

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

// ─── Info card (total tagihan) ────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacings.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: child,
    );
  }
}

// ─── Payment method selector (trigger) ───────────────────────────────────────

class _PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod? selected;
  final VoidCallback onTap;

  const _PaymentMethodSelector({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacings.md,
          vertical: AppSpacings.sm + 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          border: Border.all(
            color: selected != null ? AppColors.primary500 : AppColors.neutral300,
          ),
        ),
        child: Row(
          children: [
            // Logo bank (jika sudah dipilih)
            if (selected != null) ...[
              _BankLogo(logoAsset: selected!.logoAsset),
              const SizedBox(width: AppSpacings.sm),
            ],

            // Label
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

// ─── Payment method tile (dalam bottom sheet) ─────────────────────────────────

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
                _BankLogo(logoAsset: method.logoAsset, size: 48),
                const SizedBox(width: AppSpacings.md),
                Expanded(
                  child: AppText(
                    method.name,
                    variant: AppTextVariant.bodyLarge,
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
        const AppDivider(height: 1),
      ],
    );
  }
}

// ─── Bank logo widget ─────────────────────────────────────────────────────────

class _BankLogo extends StatelessWidget {
  final String logoAsset;
  final double size;

  const _BankLogo({required this.logoAsset, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        logoAsset,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.neutral100,
            borderRadius: BorderRadius.circular(RadiusTokens.xs),
          ),
          child: const Icon(
            Icons.account_balance_rounded,
            size: 20,
            color: AppColors.neutral400,
          ),
        ),
      ),
    );
  }
}

// ─── Bottom section: checkbox syarat + tombol bayar ───────────────────────────

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
        AppSpacings.md,
        AppSpacings.sm,
        AppSpacings.md,
        AppSpacings.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Checkbox syarat & ketentuan
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
                  side: const BorderSide(color: AppColors.neutral300),
                ),
              ),
              const SizedBox(width: AppSpacings.sm),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                    children: [
                      const TextSpan(text: 'Saya menyetujui '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: buka halaman syarat & ketentuan
                          },
                          child: const Text(
                            'syarat dan ketentuan EMAS',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary500,
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

          const SizedBox(height: AppSpacings.md),

          // Tombol bayar
          AppButton(
            label: 'Bayar',
            size: AppButtonSize.large,
            borderRadius: RadiusTokens.full,
            onPressed: onPay,
          ),
        ],
      ),
    );
  }
}
