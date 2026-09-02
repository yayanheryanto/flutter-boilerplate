import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/features/dashboard/data/models/payment_guide_channel.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String _formatCurrency(int value) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(value);

/// "Cara Pembayaran" page — shown after the user taps "Bayar", explaining
/// the virtual account number to pay and step-by-step instructions per
/// payment channel (Allo Wallet, Internet Banking, teller).
///
/// Guide content is still dummy ([paymentGuideChannels]) — replace with API
/// results once the endpoint is available.
class PaymentGuidePage extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final int totalPayment;

  const PaymentGuidePage({
    super.key,
    this.bankName = 'Allo Bank',
    this.accountNumber = '83573687539',
    this.totalPayment = 23971000,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: const AppPageBar(title: 'Cara Pembayaran'),
      body: ListView(
        padding: const EdgeInsets.all(Spacings.md),
        children: [
          _BankAccountCard(
            bankName: bankName,
            accountNumber: accountNumber,
            totalPayment: totalPayment,
          ),
          const SizedBox(height: Spacings.md),
          for (var i = 0; i < paymentGuideChannels.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: Spacings.sm),
              child: _AccordionSection(
                title: paymentGuideChannels[i].title,
                steps: paymentGuideChannels[i].steps,
                initiallyExpanded: i == 0,
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Bank account card ──────────────────────────────────────────────────────────

class _BankAccountCard extends StatelessWidget {
  final String bankName;
  final String accountNumber;
  final int totalPayment;

  const _BankAccountCard({
    required this.bankName,
    required this.accountNumber,
    required this.totalPayment,
  });

  Future<void> _copy(BuildContext context, String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    AppToast.show('$label disalin', type: AppToastType.success);
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(Rounded.lg),
      padding: const EdgeInsets.all(Spacings.md),
      borderColor: AppColors.neutral300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.warning500,
                  borderRadius: BorderRadius.circular(Rounded.xs),
                ),
                child: const Icon(Icons.account_balance_rounded, size: 14, color: AppColors.white),
              ),
              const SizedBox(width: Spacings.sm),
              AppText(bankName, fontWeight: FontWeight.w700),
            ],
          ),
          const SizedBox(height: Spacings.md),
          _copyRow(context, label: 'Nomor Rekening', value: accountNumber),
          const SizedBox(height: Spacings.md),
          _copyRow(context, label: 'Total Pembayaran', value: _formatCurrency(totalPayment)),
        ],
      ),
    );
  }

  Widget _copyRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                label,
                variant: AppTextVariant.labelSmall,
                color: AppColors.textPrimary,
              ),
              const SizedBox(height: 2),
              AppText(value, fontWeight: FontWeight.w700),
            ],
          ),
        ),
        SizedBox(
          width: 76,
          child: AppButton(
            label: 'Salin',
            variant: AppButtonVariant.outlined,
            size: AppButtonSize.small,
            isExpanded: false,
            borderRadius: Rounded.full,
            borderColor: AppColors.blue100,
            borderWidth: 2,
            foregroundColor: AppColors.textPrimary,
            onPressed: () async => _copy(context, value, label),
          ),
        ),
      ],
    );
  }
}

// ─── Accordion section ────────────────────────────────────────────────────────

class _AccordionSection extends StatefulWidget {
  final String title;
  final List<String> steps;
  final bool initiallyExpanded;

  const _AccordionSection({
    required this.title,
    required this.steps,
    this.initiallyExpanded = false,
  });

  @override
  State<_AccordionSection> createState() => _AccordionSectionState();
}

class _AccordionSectionState extends State<_AccordionSection> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(Rounded.lg),
      padding: EdgeInsets.zero,
      borderColor: AppColors.neutral300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(Rounded.lg),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(Spacings.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(widget.title, fontWeight: FontWeight.w700),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(Spacings.md, 0, Spacings.md, Spacings.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < widget.steps.length; i++)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i == widget.steps.length - 1 ? 0 : Spacings.sm,
                      ),
                      child: _StepText(
                        number: i + 1,
                        raw: widget.steps[i],
                        onLinkTap: () {
                          // TODO: buka aplikasi/tautan Allo Bank
                        },
                      ),
                    ),
                ],
              ),
            ),
            crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

// ─── Step text (bold `**..**` & link `[[..]]` mini-markup) ────────────────────

class _StepText extends StatefulWidget {
  final int number;
  final String raw;
  final VoidCallback? onLinkTap;

  const _StepText({required this.number, required this.raw, this.onLinkTap});

  @override
  State<_StepText> createState() => _StepTextState();
}

class _StepTextState extends State<_StepText> {
  TapGestureRecognizer? _linkRecognizer;

  @override
  void dispose() {
    _linkRecognizer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _linkRecognizer?.dispose();
    _linkRecognizer = TapGestureRecognizer()..onTap = widget.onLinkTap;

    const baseStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      height: 1.4,
      color: AppColors.textPrimary,
    );

    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*|\[\[(.+?)\]\]');
    var start = 0;

    for (final match in pattern.allMatches(widget.raw)) {
      if (match.start > start) {
        spans.add(TextSpan(text: widget.raw.substring(start, match.start)));
      }
      final bold = match.group(1);
      final link = match.group(2);
      if (bold != null) {
        spans.add(TextSpan(text: bold, style: const TextStyle(fontWeight: FontWeight.w700)));
      } else if (link != null) {
        spans.add(
          TextSpan(
            text: link,
            style: const TextStyle(color: AppColors.info500, fontWeight: FontWeight.w600),
            recognizer: _linkRecognizer,
          ),
        );
      }
      start = match.end;
    }
    if (start < widget.raw.length) {
      spans.add(TextSpan(text: widget.raw.substring(start)));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: AppText(
            '${widget.number}.',
            variant: AppTextVariant.bodySmall,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: RichText(text: TextSpan(style: baseStyle, children: spans)),
        ),
      ],
    );
  }
}
