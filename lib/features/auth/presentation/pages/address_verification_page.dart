import 'dart:io';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';

class AddressVerificationPage extends StatelessWidget {
  const AddressVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddressVerificationContent();
  }
}

class _AddressVerificationContent extends StatefulWidget {
  const _AddressVerificationContent();

  @override
  State<_AddressVerificationContent> createState() => _AddressVerificationContentState();
}

class _AddressVerificationContentState extends State<_AddressVerificationContent> with AppFormMixin<_AddressVerificationContent> {
  // ── Controllers ──────────────────────────────────────────────────────────────
  final _addressController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();
  final _distirctController = TextEditingController();
  final _villageController = TextEditingController();

  // ── State ─────────────────────────────────────────────────────────────────────
  File? _ktpPhoto;
  DateTime? _selectedDob;
  String? _province;
  String? _city;
  String? _district;
  String? _village;

  static const _provinceOptions = ['DKI Jakarta', 'Jawa Barat'];
  static const _cityOptions = ['Jakarta', 'Bandung'];
  static const _districtOptions = ['Kebon Jeruk', 'Dipatiukur'];
  static const _villageOptions = ['Kedoya', 'Sekeloa'];

  @override
  void dispose() {
    _addressController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _distirctController.dispose();
    _villageController.dispose();
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
                const VerificationStepper(currentStep: 2),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacings.md,
                    vertical: AppSpacings.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const AppText(
                        'Tempat Tinggal Domisili',
                        variant: AppTextVariant.titleMedium,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),

                      const AppSpacer.md(),
                      // NIK
                      AppTextField(
                        controller: _addressController,
                        label: 'Alamat',
                        hint: 'Masukkan alamat domisili',
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.compose([
                          AppValidators.required(message: 'Alamat wajib diisi'),
                        ]),
                      ),
                      const AppSpacer.md(),

                      // Nama

                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _rtController,
                              label: 'RT',
                              hint: 'Masukkan RT',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: AppInputFormatters.digitsOnly(),
                              validator: AppValidators.compose([
                                AppValidators.required(message: 'RT wajib diisi'),
                                AppValidators.maxLength(3, message: 'Maksimal 3 karakter'),
                              ]),
                            ),
                          ),

                          const AppSpacer.md(horizontal: true,),


                          Expanded(
                            child: AppTextField(
                              controller: _rwController,
                              label: 'RW',
                              hint: 'Masukkan RW',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: AppInputFormatters.digitsOnly(),
                              validator: AppValidators.compose([
                                AppValidators.required(message: 'RT wajib diisi'),
                                AppValidators.maxLength(3, message: 'Maksimal 3 karakter'),
                              ]),
                            ),
                          ),
                        ],
                      ),

                      const AppSpacer.md(),

                      // Jenis Kelamin
                      AppDropdownField(
                        label: 'Provinsi',
                        hint: 'Pilih provinsi domisili',
                        value: _province,
                        items: _provinceOptions,
                        onChanged: (v) => setState(() => _province = v),
                        validator: (v) => v == null ? 'Provinsi wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Tempat Lahir
                      AppDropdownField(
                        label: 'Kota',
                        hint: 'Pilih kota domisili',
                        value: _city,
                        items: _cityOptions,
                        onChanged: (v) => setState(() => _city = v),
                        validator: (v) => v == null ? 'Kota wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Tanggal Lahir
                      AppDropdownField(
                        label: 'Kecamatan',
                        hint: 'Pilih kecamatan domisili',
                        value: _district,
                        items: _districtOptions,
                        onChanged: (v) => setState(() => _district = v),
                        validator: (v) => v == null ? 'Kecamatan wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Pekerjaan
                      AppDropdownField(
                        label: 'Kelurahan',
                        hint: 'Pilih kelurahan domisili',
                        value: _village,
                        items: _villageOptions,
                        onChanged: (v) => setState(() => _village = v),
                        validator: (v) => v == null ? 'Kelurahan wajib dipilih' : null,
                      ),
                      const AppSpacer.lg(),

                      AppButton(
                        label: 'Lanjut',
                        onPressed: () async {
                          await context.push(AppRoutes.bankVerification);
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
