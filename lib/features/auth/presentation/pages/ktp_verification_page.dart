import 'dart:io';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/services/camera_service.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/core/utils/images/app_images.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/shared/widgets/pickers/wheel_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:sizer/sizer.dart';

class KtpVerificationPage extends StatelessWidget {
  const KtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _KtpVerificationContent();
  }
}

class _KtpVerificationContent extends StatefulWidget {
  const _KtpVerificationContent();

  @override
  State<_KtpVerificationContent> createState() => _KtpVerificationContentState();
}

class _KtpVerificationContentState extends State<_KtpVerificationContent> with AppFormMixin<_KtpVerificationContent> {
  // ── Controllers ──────────────────────────────────────────────────────────────
  final _nikController = TextEditingController();
  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _dobController = TextEditingController();
  final _pekerjaanController = TextEditingController();

  // ── State ─────────────────────────────────────────────────────────────────────
  File? _ktpPhoto;
  DateTime? _selectedDob;
  String? _jenisKelamin;
  String? _kewarganegaraan;
  bool _isLoadingPhoto = false;

  final _dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

  static const _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  static const _kewarganegaraanOptions = ['WNI', 'WNA'];

  @override
  void dispose() {
    _nikController.dispose();
    _namaController.dispose();
    _tempatLahirController.dispose();
    _dobController.dispose();
    _pekerjaanController.dispose();
    super.dispose();
  }

  // ── Photo picker ──────────────────────────────────────────────────────────────

  Future<void> _showPhotoPicker() async {
    await AppCustomBottomSheet.show<void>(
      context,
      showCloseButton: false,
      contentPadding: const EdgeInsets.fromLTRB(
        SpacingTokens.lg,
        SpacingTokens.sm,
        SpacingTokens.lg,
        SpacingTokens.lg,
      ),
      content: _PhotoPickerContent(
        onCamera: () async {
          context.pop();
          await _capturePhoto(fromCamera: true);
        },
        onGallery: () async {
          context.pop();
          await _capturePhoto(fromCamera: false);
        },
      ),
    );
  }

  Future<void> _capturePhoto({required bool fromCamera}) async {
    setState(() => _isLoadingPhoto = true);
    try {
      final service = getIt<CameraService>();
      final file =
          fromCamera ? await service.takePhoto(imageQuality: 85, maxWidth: 1600) : await service.pickFromGallery(imageQuality: 85, maxWidth: 1600);

      if (file != null && mounted) setState(() => _ktpPhoto = file);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Gagal membuka ${fromCamera ? 'kamera' : 'galeri'}. Pastikan izin sudah diberikan.');
    } finally {
      if (mounted) setState(() => _isLoadingPhoto = false);
    }
  }

  // ── Date picker ───────────────────────────────────────────────────────────────

  Future<void> _pickDob() async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WheelDatePicker(
        initialDate: _selectedDob ?? DateTime(1990),
        firstDate: DateTime(1900),
        lastDate: DateTime.now().subtract(
          const Duration(days: 365 * 15), //minimal 17 tahun
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = _dateFormat.format(picked);
      });
    }
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
                const VerificationStepper(currentStep: 0),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.md,
                    vertical: SpacingTokens.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacer.sm(),
                      // Card with photo
                      _KtpPhotoCard(
                        photo: _ktpPhoto,
                        isLoading: _isLoadingPhoto,
                        onTap: _showPhotoPicker,
                      ),
                      const AppSpacer.lg(),

                      // NIK
                      AppTextField(
                        controller: _nikController,
                        label: 'NIK KTP',
                        hint: 'Masukkan NIK KTP Anda',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: AppInputFormatters.digitsOnly(),
                        validator: AppValidators.compose([
                          AppValidators.required(message: 'NIK KTP wajib diisi'),
                          AppValidators.exactLength(16, message: 'NIK harus 16 digit'),
                        ]),
                      ),
                      const AppSpacer.md(),

                      // Nama
                      AppTextField(
                        controller: _namaController,
                        label: 'Nama Lengkap Sesuai KTP',
                        hint: 'Masukkan nama lengkap Anda',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        inputFormatters: AppInputFormatters.lettersOnly(),
                        validator: AppValidators.compose([
                          AppValidators.required(message: 'Nama lengkap wajib diisi'),
                          AppValidators.minLength(3, message: 'Nama minimal 3 karakter'),
                        ]),
                      ),
                      const AppSpacer.md(),

                      // Jenis Kelamin
                      AppDropdownField(
                        label: 'Jenis Kelamin',
                        hint: 'Pilih jenis kelamin',
                        value: _jenisKelamin,
                        items: _jenisKelaminOptions,
                        onChanged: (v) => setState(() => _jenisKelamin = v),
                        validator: (v) => v == null ? 'Jenis kelamin wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Tempat Lahir
                      AppTextField(
                        controller: _tempatLahirController,
                        label: 'Tempat Lahir',
                        hint: 'Masukkan tempat lahir Anda',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.required(message: 'Tempat lahir wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Tanggal Lahir
                      AppTextField(
                        controller: _dobController,
                        label: 'Tanggal Lahir',
                        hint: 'Pilih tanggal lahir',
                        readOnly: true,
                        onTap: _pickDob,
                        suffix: const Icon(Icons.calendar_today_outlined, size: 18),
                        validator: (_) => _selectedDob == null ? 'Tanggal lahir wajib diisi' : null,
                      ),
                      const AppSpacer.md(),

                      // Pekerjaan
                      AppTextField(
                        controller: _pekerjaanController,
                        label: 'Pekerjaan',
                        hint: 'Masukkan pekerjaan Anda',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        validator: AppValidators.required(message: 'Pekerjaan wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Kewarganegaraan
                      AppDropdownField(
                        label: 'Kewarganegaraan',
                        hint: 'Pilih kewarganegaraan',
                        value: _kewarganegaraan,
                        items: _kewarganegaraanOptions,
                        onChanged: (v) => setState(() => _kewarganegaraan = v),
                        validator: (v) => v == null ? 'Kewarganegaraan wajib dipilih' : null,
                      ),
                      const AppSpacer.xl(),
                      AppButton(
                        label: 'Lanjut',
                        onPressed: () async {
                          await context.push(AppRoutes.faceGuide);
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

// ─── KTP Photo Card ───────────────────────────────────────────────────────────

class _KtpPhotoCard extends StatelessWidget {
  final File? photo;
  final bool isLoading;
  final VoidCallback onTap;

  const _KtpPhotoCard({
    required this.photo,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6EE),
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        border: const Border(
          left: BorderSide(
            color: AppColors.neutral200,
            width: 0.8,
          ),
          right: BorderSide(
            color: AppColors.neutral200,
            width: 0.8,
          ),
          bottom: BorderSide(
            color: AppColors.neutral200,
            width: 0.8,
          ),
          top: BorderSide(
            color: AppColors.neutral200,
            width: 0.8,
          ),
        ),
      ),
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText('Verifikasi KTP', variant: AppTextVariant.titleMedium, fontWeight: FontWeight.bold),
          const AppSpacer.md(),

          // Photo area
          ClipRRect(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            child: photo != null
                ? Center(
                    child: Image.file(
                      photo!,
                      height: 18.h,
                      width: 58.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: SizedBox(
                      height: 18.h,
                      width: 58.w,
                      child: Image.asset(
                        AppImages.sampleCorrectIdCard,
                      ),
                    ),
                  ),
          ),
          const AppSpacer.md(),

          // Foto Ulang button
          AppButton(
            label: isLoading ? 'Memproses...' : 'Foto Ulang',
            variant: AppButtonVariant.outlined,
            backgroundColor: AppColors.bgCard,
            onPressed: isLoading ? null : onTap,
            isLoading: isLoading,
            foregroundColor: AppColors.primary500,
            colorSide: AppColors.bgCard,
            borderWidth: 0,
            borderRadius: 25,
          ),
        ],
      ),
    );
  }
}

// ─── Photo Picker Bottom Sheet Content ───────────────────────────────────────

class _PhotoPickerContent extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _PhotoPickerContent({
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Close button
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 24,
              color: Colors.grey,
            ),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        const AppSpacer.md(),

        const AppText(
          'Media Pengambilan Foto',
          variant: AppTextVariant.headlineSmall,
          fontWeight: FontWeight.bold,
        ),
        const AppSpacer.xl(),

        // Options row
        Row(
          children: [
            Expanded(
              child: _PhotoOption(
                icon: Icons.camera_alt_outlined,
                label: 'Foto dari kamera',
                onTap: onCamera,
                image: 'assets/images/svg/camera.svg',
              ),
            ),
            Expanded(
              child: _PhotoOption(
                icon: Icons.photo_library_outlined,
                label: 'Pilih dari gallery',
                image: 'assets/images/svg/gallery.svg',
                onTap: onGallery,
              ),
            ),
          ],
        ),
        const AppSpacer.lg(),
      ],
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String image;

  const _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            image,
            width: 42,
          ),
          const AppSpacer.md(),
          AppText(
            label,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
