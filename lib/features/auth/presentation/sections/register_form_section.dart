import 'dart:io';

import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/core/services/camera_service.dart';
import 'package:boilerplate/core/constants/tokens/radius_tokens.dart';
import 'package:boilerplate/core/constants/tokens/spacing_tokens.dart';
import 'package:boilerplate/shared/widgets/buttons/app_button.dart';
import 'package:boilerplate/shared/widgets/display/app_display.dart';
import 'package:boilerplate/shared/widgets/feedback/app_feedback.dart';
import 'package:boilerplate/shared/widgets/input/app_text_field.dart';
import 'package:boilerplate/shared/widgets/typography/app_text.dart';
import 'package:boilerplate/shared/widgets/pickers/app_date_picker.dart';
import 'package:boilerplate/shared/widgets/snackbar/app_snackbar.dart';
import 'package:boilerplate/core/utils/app_form_utils.dart';
import 'package:boilerplate/core/utils/navigator_key.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegisterFormSection extends StatefulWidget {
  const RegisterFormSection({super.key});

  @override
  State<RegisterFormSection> createState() => _RegisterFormSectionState();
}

class _RegisterFormSectionState extends State<RegisterFormSection>
    with AppFormMixin<RegisterFormSection> {
  // ── Controllers ─────────────────────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  // ── State ────────────────────────────────────────────────────────────────────
  DateTime? _selectedDob;
  File? _ktpPhoto;
  bool _isCapturingKtp = false;

  // ── Format ───────────────────────────────────────────────────────────────────
  final _dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ── Handlers ─────────────────────────────────────────────────────────────────

  Future<void> _pickDob() async {
    final picked = await AppDatePicker.pickDate(
      context,
      initialDate: _selectedDob ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 17)),
      helpText: 'Pilih Tanggal Lahir',
      confirmText: 'Pilih',
      cancelText: 'Batal',
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _captureKtp() async {
    setState(() => _isCapturingKtp = true);

    try {
      final file = await getIt<CameraService>().takePhoto(
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (file != null && mounted) {
        setState(() => _ktpPhoto = file);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, 'Gagal membuka kamera. Pastikan izin kamera sudah diberikan.');
      }
    } finally {
      if (mounted) setState(() => _isCapturingKtp = false);
    }
  }

  void _retakeKtp() => setState(() => _ktpPhoto = null);

  void _onSubmit() {
    // Validasi form field
    if (!validateForm()) return;

    // Validasi tanggal lahir (tidak bisa dari validator biasa karena readOnly)
    if (_selectedDob == null) {
      AppSnackbar.error(context, 'Tanggal lahir wajib diisi');
      return;
    }

    // Validasi KTP foto
    if (_ktpPhoto == null) {
      AppSnackbar.error(context, 'Foto KTP wajib dilampirkan');
      return;
    }

    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _generateTempPassword(), // TODO: tambah field password jika diperlukan
            name: _nameController.text.trim(),
          ),
        );
  }

  /// Generate password sementara dari nama + tanggal lahir.
  /// Ganti dengan field password jika flow bisnis membutuhkan.
  String _generateTempPassword() {
    final dob = _selectedDob!;
    return '${_nameController.text.trim().replaceAll(' ', '')}${dob.day}${dob.month}${dob.year}!';
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppNavigator.go(AppRoutes.dashboard);
        }
        if (state is AuthError) {
          AppSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(mobile: 24.0, tablet: 48.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ────────────────────────────────────────────────────
                const AppText(
                  'Buat Akun Baru',
                  variant: AppTextVariant.headlineMedium,
                  fontWeight: FontWeight.bold,
                ),
                const AppSpacer.xs(),
                AppText(
                  'Lengkapi data diri kamu untuk mendaftar',
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const AppSpacer(40),

                // ── Nama Lengkap ──────────────────────────────────────────────
                AppTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Sesuai KTP',
                  prefixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  inputFormatters: AppInputFormatters.lettersOnly(),
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Nama lengkap wajib diisi'),
                    AppValidators.minLength(3, message: 'Nama minimal 3 karakter'),
                  ]),
                ),
                const AppSpacer.md(),

                // ── Email ─────────────────────────────────────────────────────
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'contoh@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Email wajib diisi'),
                    AppValidators.email(message: 'Format email tidak valid'),
                  ]),
                ),
                const AppSpacer.md(),

                // ── No. Telepon ───────────────────────────────────────────────
                AppTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hint: '08xxxxxxxxxx',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: AppInputFormatters.phone(),
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Nomor telepon wajib diisi'),
                    AppValidators.phone(message: 'Format nomor telepon tidak valid'),
                  ]),
                ),
                const AppSpacer.md(),

                // ── Tanggal Lahir ─────────────────────────────────────────────
                AppTextField(
                  controller: _dobController,
                  label: 'Tanggal Lahir',
                  hint: 'Pilih tanggal lahir',
                  prefixIcon: Icons.cake_outlined,
                  readOnly: true,
                  onTap: _pickDob,
                  suffix: Icon(
                    Icons.calendar_month_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  validator: (_) =>
                      _selectedDob == null ? 'Tanggal lahir wajib diisi' : null,
                ),
                const AppSpacer(28),

                // ── Foto KTP ──────────────────────────────────────────────────
                _KtpPhotoField(
                  photo: _ktpPhoto,
                  isLoading: _isCapturingKtp,
                  onCapture: _captureKtp,
                  onRetake: _retakeKtp,
                ),
                const AppSpacer(32),

                // ── Submit ────────────────────────────────────────────────────
                AppButton(
                  label: 'Daftar',
                  onPressed: _onSubmit,
                  isLoading: isLoading,
                ),
                const AppSpacer.md(),

                // ── Login link ────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText('Sudah punya akun? '),
                    AppLinkText(
                      'Masuk',
                      onTap: () => AppNavigator.go(AppRoutes.login),
                    ),
                  ],
                ),
                const AppSpacer.lg(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── KTP Photo Field ──────────────────────────────────────────────────────────

class _KtpPhotoField extends StatelessWidget {
  final File? photo;
  final bool isLoading;
  final VoidCallback onCapture;
  final VoidCallback onRetake;

  const _KtpPhotoField({
    required this.photo,
    required this.isLoading,
    required this.onCapture,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Icon(Icons.badge_outlined, size: 16, color: scheme.onSurface.withOpacity(0.7)),
            const AppSpacer(6, horizontal: true),
            AppText(
              'Foto KTP',
              variant: AppTextVariant.labelLarge,
              color: scheme.onSurface.withOpacity(0.7),
            ),
            const AppSpacer(4, horizontal: true),
            AppText(
              '*',
              variant: AppTextVariant.labelLarge,
              color: scheme.error,
            ),
          ],
        ),
        const AppSpacer(10),

        // Preview / placeholder
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: photo != null
              ? _KtpPreview(photo: photo!, onRetake: onRetake)
              : _KtpPlaceholder(isLoading: isLoading, onCapture: onCapture),
        ),

        // Keterangan
        const AppSpacer.sm(),
        AppText(
          'Pastikan foto KTP jelas, tidak buram, dan seluruh teks terbaca.',
          variant: AppTextVariant.bodySmall,
          color: scheme.onSurface.withOpacity(0.5),
        ),
      ],
    );
  }
}

// ── KTP placeholder (sebelum foto diambil) ────────────────────────────────────

class _KtpPlaceholder extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCapture;

  const _KtpPlaceholder({required this.isLoading, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isLoading ? null : onCapture,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 180,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          border: Border.all(
            color: scheme.outline.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoader.small(),
                    const AppSpacer(10),
                    AppText(
                      'Membuka kamera...',
                      variant: AppTextVariant.bodySmall,
                      color: scheme.onSurface.withOpacity(0.6),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 28,
                      color: scheme.primary,
                    ),
                  ),
                  const AppSpacer.md(),
                  AppText(
                    'Ambil Foto KTP',
                    variant: AppTextVariant.titleSmall,
                    fontWeight: FontWeight.w600,
                    color: scheme.primary,
                  ),
                  const AppSpacer.xs(),
                  AppText(
                    'Ketuk untuk membuka kamera',
                    variant: AppTextVariant.bodySmall,
                    color: scheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
      ),
    );
  }
}

// ── KTP preview (setelah foto diambil) ───────────────────────────────────────

class _KtpPreview extends StatelessWidget {
  final File photo;
  final VoidCallback onRetake;

  const _KtpPreview({required this.photo, required this.onRetake});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Gambar KTP
        ClipRRect(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          child: Image.file(
            photo,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: scheme.errorContainer,
              child: Center(
                child: Icon(Icons.broken_image_outlined, color: scheme.error),
              ),
            ),
          ),
        ),

        // Overlay status berhasil
        Positioned(
          top: SpacingTokens.sm,
          left: SpacingTokens.sm,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(RadiusTokens.full),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, size: 14, color: Colors.greenAccent[400]),
                const AppSpacer(5, horizontal: true),
                const AppText(
                  'Foto KTP',
                  variant: AppTextVariant.labelSmall,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),

        // Tombol ambil ulang
        Positioned(
          top: SpacingTokens.sm,
          right: SpacingTokens.sm,
          child: GestureDetector(
            onTap: onRetake,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(RadiusTokens.full),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                  AppSpacer(4, horizontal: true),
                  AppText(
                    'Ambil ulang',
                    variant: AppTextVariant.labelSmall,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
