import 'package:boilerplate/shared/widgets/buttons/app_button.dart';
import 'package:boilerplate/shared/widgets/input/app_text_field.dart';
import 'package:boilerplate/shared/widgets/typography/app_text.dart';
import 'package:boilerplate/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:boilerplate/shared/widgets/dialogs/app_dialog.dart';
import 'package:boilerplate/shared/widgets/overlays/app_overlays.dart';
import 'package:boilerplate/shared/widgets/pickers/app_date_picker.dart';
import 'package:boilerplate/shared/widgets/pickers/app_pickers.dart';
import 'package:boilerplate/shared/widgets/snackbar/app_snackbar.dart';
import 'package:boilerplate/shared/widgets/toast/app_toast.dart';
import 'package:boilerplate/core/utils/app_form_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Design System showcase page.
///
/// Register in AppRouter during development:
/// ```dart
/// GoRoute(path: '/ui-demo', builder: (_, __) => const UiDemoPage()),
/// ```
class UiDemoPage extends StatefulWidget {
  const UiDemoPage({super.key});

  @override
  State<UiDemoPage> createState() => _UiDemoPageState();
}

class _UiDemoPageState extends State<UiDemoPage> {
  // GlobalKeys untuk popover & stepper
  final _popoverKey = GlobalKey();
  final _stepKey1 = GlobalKey();
  final _stepKey2 = GlobalKey();
  final _stepKey3 = GlobalKey();

  // State pickers
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;
  TimeOfDay? _selectedTime;
  DateTime? _selectedMonthYear;
  Color? _pickedColor = const Color(0xFFF57C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Demo'),
        actions: [
          IconButton(
            key: _stepKey3,
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Start tour',
            onPressed: _showStepper,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ─── TOAST ────────────────────────────────────────────────────────
          const _SectionHeader('Toast (Global Overlay)'),
          _hint('Tidak butuh context/Scaffold. Otomatis queue jika dipanggil bersamaan.'),
          _DemoTile('Success Toast', () async {
            AppToast.success('Data berhasil disimpan!');
          }),
          _DemoTile('Error Toast (top)', () async {
            AppToast.error('Gagal menghubungi server.', position: AppToastPosition.top);
          }),
          _DemoTile('Warning Toast (center)', () async {
            AppToast.warning('Perubahan belum disimpan.', position: AppToastPosition.center);
          }),
          _DemoTile('Queue 3 toast sekaligus', () async {
            AppToast.success('Langkah 1 selesai');
            AppToast.info('Langkah 2 berjalan...');
            AppToast.warning('Langkah 3 perlu perhatian');
          }),

          // ─── SNACKBAR ──────────────────────────────────────────────────────
          const _SectionHeader('Snackbar (Scaffold-based)'),
          _DemoTile('Success Snackbar', () async {
            AppSnackbar.success(context, 'Profil berhasil diperbarui!');
          }),
          _DemoTile('Error Snackbar', () async {
            AppSnackbar.error(context, 'Koneksi internet terputus.');
          }),
          _DemoTile('Info + action', () async {
            AppSnackbar.info(
              context,
              'Update tersedia.',
              actionLabel: 'Update',
              onAction: () => AppToast.success('Mengunduh update...'),
            );
          }),

          // ─── BANNER ───────────────────────────────────────────────────────
          const _SectionHeader('Banner (Top of Screen)'),
          _DemoTile('Info Banner + action', () async {
            AppBanner.show(
              context,
              'Versi 2.1.0 tersedia.',
              action: 'Update',
              onAction: () => AppToast.success('Mengunduh...'),
              autoDismiss: true,
              autoDismissDuration: const Duration(seconds: 6),
            );
          }),
          _DemoTile('Warning Banner (auto-dismiss 4s)', () async {
            AppBanner.show(
              context,
              'Mode offline aktif. Beberapa fitur tidak tersedia.',
              type: AppBannerType.warning,
              autoDismiss: true,
              autoDismissDuration: const Duration(seconds: 4),
            );
          }),
          _DemoTile('Error Banner', () async {
            AppBanner.show(
              context,
              'Sesi habis. Silakan login ulang.',
              type: AppBannerType.error,
              action: 'Login',
              onAction: () {},
            );
          }),
          _DemoTile('Dismiss Banner', () async {
            AppBanner.hide(context);
          }),

          // ─── DIALOGS ──────────────────────────────────────────────────────
          const _SectionHeader('Dialogs'),
          _DemoTile('Confirm — Info', () async {
            final confirmed = await AppConfirmDialog.show(
              context,
              title: 'Simpan perubahan?',
              message: 'Perubahan yang belum disimpan akan disimpan.',
              confirmLabel: 'Simpan',
            );
            if (confirmed ?? false) AppToast.success('Disimpan!');
          }),
          _DemoTile('Confirm — Danger (Hapus)', () async {
            final confirmed = await AppConfirmDialog.show(
              context,
              title: 'Hapus item ini?',
              message: 'Tindakan ini tidak dapat dibatalkan.',
              confirmLabel: 'Hapus',
              type: AppDialogType.danger,
            );
            if (confirmed ?? false) AppToast.error('Item dihapus');
          }),
          _DemoTile('Alert — Session expired', () async {
            await AppAlertDialog.show(
              context,
              title: 'Sesi Berakhir',
              message: 'Silakan login ulang untuk melanjutkan.',
              type: AppDialogType.warning,
            );
          }),
          _DemoTile('Input Dialog', () async {
            final value = await AppInputDialog.show(
              context,
              title: 'Ubah nama file',
              fieldLabel: 'Nama File',
              initialValue: 'dokumen.pdf',
            );
            if (value != null) AppToast.info('Nama baru: $value');
          }),
          _DemoTile('Loading Dialog (auto-hide 2s)', () async {
            await AppLoadingDialog.show(context, message: 'Mengunggah...');
            await Future<void>.delayed(const Duration(seconds: 2));
            if (!context.mounted) return;
            AppLoadingDialog.hide(context);
          }),
          _DemoTile('Custom Dialog', () async {
            final selected = await AppCustomDialog.show<String>(
              context,
              title: 'Pilih Paket',
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PlanTile(plan: 'Free', price: 'Gratis', features: '5 proyek, 1 pengguna'),
                  _PlanTile(plan: 'Pro', price: 'Rp 150k/bln', features: '50 proyek, 10 pengguna'),
                  _PlanTile(plan: 'Enterprise', price: 'Custom', features: 'Unlimited'),
                ],
              ),
              actions: [
                const AppDialogAction(label: 'Batal', variant: AppButtonVariant.outlined),
                const AppDialogAction(label: 'Lanjut', returnValue: 'pro'),
              ],
            );
            if (selected != null) AppToast.success('Paket dipilih: $selected');
          }),

          // ─── BOTTOM SHEETS ────────────────────────────────────────────────
          const _SectionHeader('Bottom Sheets'),
          _DemoTile('Options Sheet', () async {
            final action = await AppOptionsBottomSheet.show<String>(
              context,
              title: 'Opsi Postingan',
              options: const [
                AppSheetOption(label: 'Edit', icon: Icons.edit_outlined, value: 'edit'),
                AppSheetOption(label: 'Bagikan', icon: Icons.share_outlined, value: 'share'),
                AppSheetOption(label: 'Hapus', icon: Icons.delete_outline, value: 'delete', isDestructive: true),
              ],
            );
            if (action != null) AppToast.info('Dipilih: $action');
          }),
          _DemoTile('Confirm Sheet — Danger', () async {
            final confirmed = await AppConfirmBottomSheet.show(
              context,
              title: 'Hapus akun?',
              message: 'Semua data akan dihapus permanen.',
              confirmLabel: 'Ya, hapus',
              type: AppSheetConfirmType.danger,
            );
            if (confirmed ?? false) AppToast.error('Akun dihapus');
          }),
          _DemoTile('Form Sheet — Tambah Kontak', () async {
            final nameCtrl = TextEditingController();
            final result = await AppFormBottomSheet.show<Map<String, String>>(
              context,
              title: 'Tambah Kontak',
              subtitle: 'Isi data kontak di bawah ini.',
              formBuilder: (key) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: nameCtrl,
                    label: 'Nama Lengkap',
                    hint: 'e.g. Budi Santoso',
                    prefixIcon: Icons.person_outline,
                    validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  const AppTextField(
                    label: 'Email',
                    hint: 'budi@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                ],
              ),
              onSubmit: (key) async {
                if (key.currentState?.validate() ?? false) {
                  await Future<void>.delayed(const Duration(milliseconds: 800));
                  return {'name': nameCtrl.text};
                }
                return null;
              },
            );
            nameCtrl.dispose();
            if (result != null) AppToast.success('Kontak ditambahkan: ${result['name']}');
          }),
          _DemoTile('Draggable Sheet — Notifikasi', () async {
            await AppDraggableBottomSheet.show<void>(
              context,
              title: 'Notifikasi',
              initialSize: 0.4,
              content: Column(
                children: List.generate(
                  8,
                      (i) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.notifications_outlined, size: 16)),
                    title: Text('Notifikasi ke-${i + 1}'),
                    subtitle: const Text('Ketuk untuk melihat detail'),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ),
            );
          }),

          // ─── DATE PICKERS ─────────────────────────────────────────────────
          const _SectionHeader('Date & Time Pickers'),
          _DemoTile(
            'Pick Date: ${_selectedDate != null ? _fmt(_selectedDate!) : '-'}',
                () async {
              final date = await AppDatePicker.pickDate(context);
              if (date != null) setState(() => _selectedDate = date);
            },
          ),
          _DemoTile(
            'Pick Time: ${_selectedTime?.format(context) ?? '-'}',
                () async {
              final time = await AppDatePicker.pickTime(context);
              if (time != null) setState(() => _selectedTime = time);
            },
          ),
          _DemoTile('Pick DateTime (gabungan)', () async {
            final dt = await AppDatePicker.pickDateTime(context);
            if (!mounted) return;
            if (dt != null) AppToast.info('$dt');
          }),
          _DemoTile(
            'Pick Range: ${_selectedRange != null ? '${_fmtS(_selectedRange!.start)} → ${_fmtS(_selectedRange!.end)}' : '-'}',
                () async {
              final range = await AppDatePicker.pickDateRange(context);
              if (range != null) setState(() => _selectedRange = range);
            },
          ),
          _DemoTile(
            'Pick Bulan/Tahun: ${_selectedMonthYear != null ? '${_bulan(_selectedMonthYear!.month)} ${_selectedMonthYear!.year}' : '-'}',
                () async {
              final date = await AppDatePicker.pickMonthYear(context);
              if (date != null) setState(() => _selectedMonthYear = date);
            },
          ),
          const SizedBox(height: 12),
          _hint('Form field versions (langsung di Form):'),
          AppDateField(label: 'Tanggal Lahir', onChanged: (d) => AppToast.info('DOB: $d')),
          const SizedBox(height: 12),
          AppDateRangeField(label: 'Periode Cuti', onChanged: (r) => AppToast.info('Range: $r')),
          const SizedBox(height: 12),
          AppTimeField(label: 'Jam Meeting', onChanged: (t) => AppToast.info('Time: $t')),

          // ─── PICKERS ──────────────────────────────────────────────────────
          const _SectionHeader('Pickers Lainnya'),
          AppColorPicker(
            label: 'Warna Label',
            initialColor: _pickedColor,
            onChanged: (c) => setState(() => _pickedColor = c),
          ),
          const SizedBox(height: 16),
          AppImagePickerField(
            label: 'Foto Profil',
            shape: AppImagePickerShape.circle,
            size: 96,
            onChanged: (f) { if (f != null) AppToast.success('Foto dipilih'); },
          ),

          // ─── OVERLAYS ─────────────────────────────────────────────────────
          const _SectionHeader('Overlays'),
          _DemoTile('Progress Overlay — indeterminate (2s)', () async {
            AppProgressOverlay.show(context, message: 'Memproses...');
            await Future<void>.delayed(const Duration(seconds: 2));
            AppProgressOverlay.hide();
          }),
          _DemoTile('Progress Overlay — dengan progress bar', () async {
            AppProgressOverlay.show(context, progress: 0.0, message: 'Mengunggah...');
            for (var i = 1; i <= 10; i++) {
              await Future<void>.delayed(const Duration(milliseconds: 180));
              AppProgressOverlay.update(progress: i / 10, message: 'Mengunggah... ${i * 10}%');
            }
            await Future<void>.delayed(const Duration(milliseconds: 300));
            AppProgressOverlay.hide();
          }),
          const SizedBox(height: 8),

          // Popover
          AppButton(
            key: _popoverKey,
            label: 'Buka Popover ↙',
            variant: AppButtonVariant.outlined,
            onPressed: () => AppPopover.show(
              context,
              anchorKey: _popoverKey,
              anchor: AppPopoverAnchor.topLeft,
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText('Apa itu Popover?', variant: AppTextVariant.titleSmall, fontWeight: FontWeight.w600),
                  SizedBox(height: 4),
                  AppText(
                    'Kartu kontekstual yang menempel pada widget. Ketuk di luar untuk menutup.',
                    variant: AppTextVariant.bodySmall,
                  ),
                  SizedBox(height: 8),
                  AppButton(
                    label: 'Mengerti',
                    size: AppButtonSize.small,
                    isExpanded: false,
                    onPressed: AppPopover.dismiss,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(key: _stepKey1, icon: const Icon(Icons.home_outlined), onPressed: () {}),
              IconButton(key: _stepKey2, icon: const Icon(Icons.search_rounded), onPressed: () {}),
              AppButton(
                label: 'Mulai tour',
                isExpanded: false,
                size: AppButtonSize.small,
                onPressed: _showStepper,
              ),
            ],
          ),

          // ─── FORM VALIDATORS ──────────────────────────────────────────────
          const _SectionHeader('Form Validators + AppFormMixin'),
          const _ValidatorDemoForm(),

          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showStepper() {
    AppStepperOverlay.show(
      context,
      steps: [
        AppStep(
          key: _stepKey1,
          title: 'Beranda',
          description: 'Kembali ke feed utama kapan saja.',
        ),
        AppStep(
          key: _stepKey2,
          title: 'Cari',
          description: 'Temukan konten, orang, atau topik.',
        ),
        AppStep(
          key: _stepKey3,
          title: 'Bantuan',
          description: 'Ketuk ikon ini untuk mengulangi tour ini.',
          anchor: AppPopoverAnchor.bottomRight,
        ),
      ],
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
  String _fmtS(DateTime d) => '${d.day}/${d.month}';
  String _bulan(int m) => ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][m];
}

// ─── Form dengan AppFormMixin ──────────────────────────────────────────────────

class _ValidatorDemoForm extends StatefulWidget {
  const _ValidatorDemoForm();

  @override
  State<_ValidatorDemoForm> createState() => _ValidatorDemoFormState();
}

class _ValidatorDemoFormState extends State<_ValidatorDemoForm>
    with AppFormMixin<_ValidatorDemoForm> {
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            label: 'Email',
            hint: 'user@example.com',
            prefixIcon: Icons.email_outlined,
            validator: AppValidators.compose([
              AppValidators.required(message: 'Email wajib diisi'),
              AppValidators.email(message: 'Format email tidak valid'),
            ]),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _passCtrl,
            label: 'Password',
            prefixIcon: Icons.lock_outline,
            validator: AppValidators.strongPassword(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Konfirmasi Password',
            prefixIcon: Icons.lock_outline,
            validator: AppValidators.matchesOther(
                  () => _passCtrl.text,
              message: 'Password tidak sama',
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'No. HP',
            hint: '08xxxxxxxxx',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: AppValidators.compose([
              AppValidators.required(),
              AppValidators.phone(),
            ]),
          ),
          const SizedBox(height: 16),
          AppButton(
            label: isSubmitting ? 'Memvalidasi...' : 'Submit Form',
            isLoading: isSubmitting,
            onPressed: () async => submitForm(() async {
              await Future<void>.delayed(const Duration(seconds: 1));
              AppToast.success('Validasi berhasil!');
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 8),
          AppText(title, variant: AppTextVariant.titleSmall, fontWeight: FontWeight.bold, color: primary),
        ],
      ),
    );
  }
}

/// Tile yang menerima [AsyncCallback] sehingga semua handler bisa pakai async/await.
class _DemoTile extends StatelessWidget {
  final String label;
  final AsyncCallback onTap;
  const _DemoTile(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.35)),
      ),
      child: ListTile(
        dense: true,
        title: Text(label, style: const TextStyle(fontSize: 13.5)),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

Widget _hint(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: AppText(text, variant: AppTextVariant.bodySmall, color: Colors.grey),
);

class _PlanTile extends StatelessWidget {
  final String plan, price, features;
  const _PlanTile({required this.plan, required this.price, required this.features});

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    leading: const Icon(Icons.check_circle_outline, size: 18),
    title: Text(plan, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    subtitle: Text(features, style: const TextStyle(fontSize: 12)),
    trailing: Text(
      price,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
    ),
    contentPadding: EdgeInsets.zero,
  );
}
