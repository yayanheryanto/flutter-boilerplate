import 'dart:io';

import 'package:camera/camera.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/snackbar/app_snackbar.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraPickPage extends StatefulWidget {
  const CameraPickPage({super.key});

  @override
  State<CameraPickPage> createState() => _CameraPickPageState();
}

class _CameraPickPageState extends State<CameraPickPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  File? _photo;
  bool _isInitializing = true;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Memanggil fungsi async tanpa await langsung di sini
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Tetap panggil dispose kamera tanpa membuat metode dispose() menjadi async
    _controller?.dispose();
    super.dispose();
  }

  // Jika didChangeAppLifecycleState bawaan dari WidgetsBindingObserver,
  // ia mengembalikan tipe data void, bukan Future<void>.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      ctrl.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  // ── Camera init ───────────────────────────────────────────────────────────

  Future<void> _initCamera() async {
    setState(() => _isInitializing = true);
    try {
      _cameras = await availableCameras();

      // Prefer front camera
      final front = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      final ctrl = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await ctrl.initialize();

      if (mounted) {
        setState(() {
          _controller = ctrl;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isInitializing = false);
        AppSnackbar.error(
          context,
          'Gagal membuka kamera. Pastikan izin kamera sudah diberikan.',
        );
      }
    }
  }

  // ── Capture ───────────────────────────────────────────────────────────────

  Future<void> _capture() async {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final xfile = await ctrl.takePicture();
      if (mounted) setState(() => _photo = File(xfile.path));
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(context, 'Gagal mengambil foto. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _retake() => setState(() => _photo = null);

  void _confirm() {
    // Return the captured photo back to the calling page
    context.pop(_photo);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: Colors.black,
      appBar: AppPageBar(
        title: 'Verifikasi Wajah',
        onBack: () => context.pop(),
      ),
      body: Column(
        children: [
          // ── Camera / preview area ───────────────────────────────────────
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Live preview or captured photo
                _buildCameraView(),

                // Bracket overlay — always visible
                const _ViewfinderOverlay(),
              ],
            ),
          ),

          // ── Bottom panel ────────────────────────────────────────────────
          _BottomPanel(
            hasPhoto: _photo != null,
            isCapturing: _isCapturing,
            onCapture: _capture,
            onRetake: _retake,
            onSave: _confirm,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    // Show captured photo
    if (_photo != null) {
      return Image.file(_photo!, fit: BoxFit.cover);
    }

    // Loading
    if (_isInitializing || _controller == null || !_controller!.value.isInitialized) {
      return const ColoredBox(
        color: Color(0xFFD8D8D8),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Live camera preview — fill entire area
    return ClipRect(
      child: OverflowBox(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize!.height,
            height: _controller!.value.previewSize!.width,
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }
}

// ─── Viewfinder Overlay ───────────────────────────────────────────────────────

class _ViewfinderOverlay extends StatelessWidget {
  const _ViewfinderOverlay();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 40.0),
      child: CustomPaint(
        painter: _BracketPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    const arm = 28.0;

    final corners = [
      [const Offset(0, arm), Offset.zero, const Offset(arm, 0)],
      [Offset(size.width - arm, 0), Offset(size.width, 0), Offset(size.width, arm)],
      [Offset(0, size.height - arm), Offset(0, size.height), Offset(arm, size.height)],
      [
        Offset(size.width - arm, size.height),
        Offset(size.width, size.height),
        Offset(size.width, size.height - arm),
      ],
    ];

    for (final pts in corners) {
      canvas.drawPath(
        Path()
          ..moveTo(pts[0].dx, pts[0].dy)
          ..lineTo(pts[1].dx, pts[1].dy)
          ..lineTo(pts[2].dx, pts[2].dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}

// ─── Bottom Panel ─────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  final bool hasPhoto;
  final bool isCapturing;
  final VoidCallback onCapture;
  final VoidCallback onRetake;
  final VoidCallback onSave;

  const _BottomPanel({
    required this.hasPhoto,
    required this.isCapturing,
    required this.onCapture,
    required this.onRetake,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2C2C2C),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: hasPhoto ? _AfterCapture(onRetake: onRetake, onSave: onSave) : _BeforeCapture(isCapturing: isCapturing, onCapture: onCapture),
    );
  }
}

class _BeforeCapture extends StatelessWidget {
  final bool isCapturing;
  final VoidCallback onCapture;

  const _BeforeCapture({required this.isCapturing, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppText(
          'Wajah harus berada di dalam bingkai foto dan\npastikan wajah Anda terlihat dengan jelas.',
          variant: AppTextVariant.bodySmall,
          color: Colors.white,
          textAlign: TextAlign.center,
          height: 1.5,
        ),
        const SizedBox(height: 24),

        // Shutter button
        GestureDetector(
          onTap: isCapturing ? null : onCapture,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isCapturing ? Colors.grey.shade600 : Colors.white.withOpacity(0.85),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: isCapturing
                ? const Padding(
                    padding: EdgeInsets.all(18),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class _AfterCapture extends StatelessWidget {
  final VoidCallback onRetake;
  final VoidCallback onSave;

  const _AfterCapture({required this.onRetake, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppText(
          'Silakan foto ulang jika wajah tidak terlihat jelas,\nterpotong, buram, atau pencahayaan kurang',
          variant: AppTextVariant.bodySmall,
          color: Colors.white,
          textAlign: TextAlign.center,
          height: 1.5,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Foto Ulang',
                variant: AppButtonVariant.outlined,
                onPressed: onRetake,
                borderRadius: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Simpan',
                onPressed: onSave,
                borderRadius: 25,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
