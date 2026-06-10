import 'dart:io';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/services/camera_service.dart';
import 'package:emas/core/services/file_picker_service.dart';
import 'package:emas/core/utils/account_type.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_spacer.dart';
import 'package:emas/shared/widgets/dropdown/app_dropdown.dart';
import 'package:emas/shared/widgets/input/app_text_field.dart';
import 'package:emas/shared/widgets/snackbar/app_snackbar.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NPWPVerificationPage extends StatefulWidget {
  final AccountType accountType;

  const NPWPVerificationPage({
    super.key,
    required this.accountType,
  });

  @override
  State<NPWPVerificationPage> createState() => _NPWPVerificationPageState();
}

class _NPWPVerificationPageState extends State<NPWPVerificationPage> with AppFormMixin<NPWPVerificationPage> {
  // ── Controllers ────────────────────────────────────────────────────────────
  final _namaPerusahaanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _npwpController = TextEditingController();
  final _nibController = TextEditingController();
  final _ktpPicController = TextEditingController();
  final _namaPicController = TextEditingController();
  final _nitkuController = TextEditingController();

  // ── State ──────────────────────────────────────────────────────────────────
  String? _jenisPerusahaan;
  String? _provinsi;
  String? _kota;

  File? _fotoNpwp;
  File? _fotoRekeningKoran;
  File? _aktaPendirian;
  File? _aktaPerubahan;

  static const _jenisPerusahaanOptions = ['PT', 'CV', 'UD', 'Firma', 'Koperasi'];
  static const _provinsiOptions = ['DKI Jakarta', 'Jawa Barat', 'Jawa Tengah', 'Jawa Timur', 'Banten'];
  static const _kotaOptions = [
    'Jakarta Pusat',
    'Jakarta Selatan',
    'Jakarta Barat',
    'Jakarta Utara',
    'Jakarta Timur',
    'Bekasi',
    'Tangerang',
    'Depok',
    'Bogor'
  ];

  @override
  void dispose() {
    _namaPerusahaanController.dispose();
    _alamatController.dispose();
    _npwpController.dispose();
    _nibController.dispose();
    _ktpPicController.dispose();
    _namaPicController.dispose();
    _nitkuController.dispose();
    super.dispose();
  }

  // ── File picker ────────────────────────────────────────────────────────────

  /// Image: uses [CameraService.pickFromGallery] (jpg/jpeg/png)
  Future<void> _pickImage(void Function(File) onPicked) async {
    try {
      final file = await getIt<CameraService>().pickFromGallery(imageQuality: 85);
      if (file != null && mounted) onPicked(file);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Gagal membuka galeri. Pastikan izin sudah diberikan.');
    }
  }

  /// PDF: uses [FilePickerService.pickPDF]
  Future<void> _pickPdf(void Function(File) onPicked) async {
    try {
      final file = await getIt<FilePickerService>().pickPDF();
      if (file != null && mounted) onPicked(file);
    } catch (_) {
      if (mounted) AppSnackbar.error(context, 'Gagal memilih file PDF.');
    }
  }

  Future<void> _pickFotoNpwp() => _pickImage((f) => setState(() => _fotoNpwp = f));

  Future<void> _pickRekeningKoran() => _pickImage((f) => setState(() => _fotoRekeningKoran = f));

  Future<void> _pickAktaPendirian() => _pickPdf((f) => setState(() => _aktaPendirian = f));

  Future<void> _pickAktaPerubahan() => _pickPdf((f) => setState(() => _aktaPerubahan = f));

  // ── Submit ─────────────────────────────────────────────────────────────────

  void _onSubmit() {
    if (!validateForm()) return;
    if (_fotoNpwp == null) {
      AppSnackbar.error(context, 'Foto NPWP wajib diunggah');
      return;
    }
    if (_fotoRekeningKoran == null) {
      AppSnackbar.error(context, 'Foto rekening koran wajib diunggah');
      return;
    }
    if (_aktaPendirian == null) {
      AppSnackbar.error(context, 'Akta pendirian wajib diunggah');
      return;
    }
    // TODO: dispatch company verification event
    context.go(AppRoutes.dashboard);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppPageBar(
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // ── Stepper ──────────────────────────────────────────────────
              VerificationStepper(
                currentStep: 0,
                accountType: widget.accountType,
              ),

              // ── Form ─────────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.md,
                    vertical: SpacingTokens.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacer.sm(),

                      // Nama Perusahaan
                      AppTextField(
                        controller: _namaPerusahaanController,
                        label: 'Nama Perusahaan',
                        hint: 'Masukkan nama perusahaan',
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.required(message: 'Nama perusahaan wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Jenis Perusahaan
                      AppDropdownField<String>(
                        label: 'Jenis Kelamin',
                        hint: 'Pilih jenis perusahaan',
                        value: _jenisPerusahaan,
                        items: _jenisPerusahaanOptions,
                        onChanged: (v) => setState(() => _jenisPerusahaan = v),
                        validator: (v) => v == null ? 'Jenis perusahaan wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Provinsi
                      AppDropdownField<String>(
                        label: 'Provinsi',
                        hint: 'Pilih provinsi',
                        value: _provinsi,
                        items: _provinsiOptions,
                        onChanged: (v) => setState(() {
                          _provinsi = v;
                          _kota = null; // reset kota when provinsi changes
                        }),
                        validator: (v) => v == null ? 'Provinsi wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Kota
                      AppDropdownField<String>(
                        label: 'Kota',
                        hint: 'Pilih kota',
                        value: _kota,
                        items: _kotaOptions,
                        onChanged: (v) => setState(() => _kota = v),
                        validator: (v) => v == null ? 'Kota wajib dipilih' : null,
                      ),
                      const AppSpacer.md(),

                      // Alamat Perusahaan
                      AppTextField(
                        controller: _alamatController,
                        label: 'Alamat Perusahaan',
                        hint: 'Masukkan alamat perusahaan',
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.required(message: 'Alamat perusahaan wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Nomor NPWP
                      AppTextField(
                        controller: _npwpController,
                        label: 'Nomor NPWP Perusahaan',
                        hint: 'Masukkan alamat perusahaan',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: AppInputFormatters.digitsOnly(),
                        validator: AppValidators.required(message: 'Nomor NPWP wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Foto NPWP
                      _UploadPhotoField(
                        label: 'Foto NPWP Perusahaan',
                        file: _fotoNpwp,
                        acceptFormat: 'Format foto harus jpg, jpeg, dan png\nukuran file maksimal 5 MB',
                        onTap: _pickFotoNpwp,
                      ),
                      const AppSpacer.md(),

                      // Foto Rekening Koran
                      _UploadPhotoField(
                        label: 'Foto Halaman Depan Rekening Koran',
                        file: _fotoRekeningKoran,
                        acceptFormat: 'Format foto harus jpg, jpeg, dan png\nukuran file maksimal 5 MB',
                        onTap: _pickRekeningKoran,
                      ),
                      const AppSpacer.md(),

                      // Akta Pendirian
                      _UploadPhotoField(
                        label: 'Akta Pendirian Perusahaan',
                        file: _aktaPendirian,
                        acceptFormat: 'Format foto harus pdf\nukuran file maksimal 5 MB',
                        onTap: _pickAktaPendirian,
                        isPdf: true,
                      ),
                      const AppSpacer.md(),

                      // Akta Perubahan Terakhir
                      _UploadPhotoField(
                        label: 'Akta Perubahan Terakhir',
                        file: _aktaPerubahan,
                        acceptFormat: 'Format foto harus pdf\nukuran file maksimal 5 MB',
                        onTap: _pickAktaPerubahan,
                        isPdf: true,
                      ),
                      const AppSpacer.md(),

                      // Nomor NIB
                      AppTextField(
                        controller: _nibController,
                        label: 'Nomor NIB',
                        hint: 'Masukkan nomor NIB',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: AppInputFormatters.digitsOnly(),
                        validator: AppValidators.required(message: 'Nomor NIB wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Nomor KTP PIC
                      AppTextField(
                        controller: _ktpPicController,
                        label: 'Nomor KTP PIC',
                        hint: 'Masukkan nomor KTP PIC',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: AppInputFormatters.digitsOnly(),
                        validator: AppValidators.compose([
                          AppValidators.required(message: 'Nomor KTP PIC wajib diisi'),
                          AppValidators.exactLength(16, message: 'NIK harus 16 digit'),
                        ]),
                      ),
                      const AppSpacer.md(),

                      // Nama PIC
                      AppTextField(
                        controller: _namaPicController,
                        label: 'Nama PIC',
                        hint: 'Masukkan nama PIC',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        inputFormatters: AppInputFormatters.lettersOnly(),
                        validator: AppValidators.required(message: 'Nama PIC wajib diisi'),
                      ),
                      const AppSpacer.md(),

                      // Nomor NITKU
                      AppTextField(
                        controller: _nitkuController,
                        label: 'Nomor NITKU',
                        hint: 'Masukkan nomor NITKU',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: AppInputFormatters.digitsOnly(),
                        validator: AppValidators.required(message: 'Nomor NITKU wajib diisi'),
                      ),
                      const AppSpacer.xl(),

                      AppButton(
                        label: 'Lanjut',
                        onPressed: _onSubmit,
                        borderRadius: 25,
                      ),
                      const AppSpacer.md(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Upload Photo/PDF Field ───────────────────────────────────────────────────

class _UploadPhotoField extends StatelessWidget {
  final String label;
  final File? file;
  final String acceptFormat;
  final VoidCallback onTap;
  final bool isPdf;

  const _UploadPhotoField({
    required this.label,
    required this.file,
    required this.acceptFormat,
    required this.onTap,
    this.isPdf = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7F5),
              borderRadius: BorderRadius.circular(RadiusTokens.lg),
              border: Border.all(
                color: const Color(0xFFB2EBE8),
                width: 1,
              ),
            ),
            child: file != null ? _FilePreview(file: file!, isPdf: isPdf) : _UploadPlaceholder(acceptFormat: acceptFormat, isPdf: isPdf),
          ),
        ),
      ],
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  final String acceptFormat;
  final bool isPdf;

  const _UploadPlaceholder({
    required this.acceptFormat,
    required this.isPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingTokens.lg,
        horizontal: SpacingTokens.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingTokens.xl,
              vertical: SpacingTokens.sm,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF80CBC8),
              borderRadius: BorderRadius.circular(RadiusTokens.full),
            ),
            child: const AppText(
              'Unggah Foto',
              variant: AppTextVariant.titleSmall,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
          AppText(
            acceptFormat,
            variant: AppTextVariant.bodySmall,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
            textAlign: TextAlign.center,
            height: 1.5,
          ),
        ],
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  final File file;
  final bool isPdf;

  const _FilePreview({required this.file, required this.isPdf});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF80CBC8).withOpacity(0.3),
              borderRadius: BorderRadius.circular(RadiusTokens.sm),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
              color: const Color(0xFF26A69A),
              size: 22,
            ),
          ),
          const SizedBox(width: SpacingTokens.sm),
          Expanded(
            child: AppText(
              file.path.split('/').last,
              variant: AppTextVariant.bodySmall,
              fontWeight: FontWeight.w500,
              maxLines: 1,
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}
