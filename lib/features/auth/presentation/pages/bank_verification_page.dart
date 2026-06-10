import 'dart:io';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';

class BankVerificationPage extends StatelessWidget {
  const BankVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BankVerificationContent();
  }
}

class _BankVerificationContent extends StatefulWidget {
  const _BankVerificationContent();

  @override
  State<_BankVerificationContent> createState() => _BankVerificationContentState();
}

class _BankVerificationContentState extends State<_BankVerificationContent> with AppFormMixin<_BankVerificationContent> {
  // ── Controllers ──────────────────────────────────────────────────────────────
  final _accountNameController = TextEditingController();
  final _accountNoController = TextEditingController();

  // ── State ─────────────────────────────────────────────────────────────────────
  File? _ktpPhoto;
  DateTime? _selectedDob;
  String? _bank;

  static const _bankOptions = ['BCA', 'BNI'];

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNoController.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────────

  void _onSubmit() {
    if (!validateForm()) return;
    if (_ktpPhoto == null) {
      AppSnackbar.error(context, 'Foto KTP wajib dilampirkan');
      return;
    }
    if (_selectedDob == null) {
      AppSnackbar.error(context, 'Tanggal lahir wajib diisi');
      return;
    }
    // TODO: dispatch KTP verification event
    context.go(AppRoutes.dashboard);
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageBar(
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
        elevation: 1,
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppSpacer.md(),
                const VerificationStepper(currentStep: 3),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.md,
                    vertical: SpacingTokens.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        'Informasi Data Bank',
                        variant: AppTextVariant.titleMedium,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),

                      const AppSpacer.md(),

                      // Jenis Kelamin
                      AppDropdownField(
                        label: 'Bank',
                        hint: 'Pilih nama bank',
                        value: _bank,
                        items: _bankOptions,
                        onChanged: (v) => setState(() => _bank = v),
                        validator: (v) => v == null ? 'Bank wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),
                      // NIK
                      AppTextField(
                        controller: _accountNoController,
                        label: 'Nomor Rekening',
                        hint: 'Masukkan nomor rekening',
                        keyboardType: TextInputType.number,
                        inputFormatters: AppInputFormatters.digitsOnly(),
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.compose([
                          AppValidators.required(message: 'Nomor rekening wajib diisi'),
                        ]),
                      ),
                      const AppSpacer.md(),
                      AppTextField(
                        controller: _accountNameController,
                        label: 'Atas Nama',
                        hint: 'Masukkan atas nama',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.compose([
                          AppValidators.required(message: 'Nama wajib diisi'),
                        ]),
                      ),

                      const AppSpacer.lg(),

                      AppButton(
                        label: 'Lanjut',
                        onPressed: () async {
                          await context.push(AppRoutes.accountProcessed);
                          // _onSubmit
                        },
                        borderRadius: 25,
                      ),
                      const AppSpacer.md(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
