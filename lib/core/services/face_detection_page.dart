import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;
import 'package:permission_handler/permission_handler.dart';

/// Halaman kamera selfie dengan face detection (ML Kit).
///
/// Menampilkan live preview + overlay lingkaran. Saat wajah masuk
/// dalam lingkaran dan proporsi tepat, FAB hijau muncul untuk capture.
/// Setelah capture, file [File] dikembalikan ke pemanggil via [Navigator.pop].
///
/// Penggunaan:
/// ```dart
/// final File? photo = await Navigator.push<File?>(
///   context,
///   MaterialPageRoute(builder: (_) => const FaceDetectionPage()),
/// );
/// ```
class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> with WidgetsBindingObserver {
  // ── Camera ─────────────────────────────────────────────────────────────────
  CameraController? _cam;
  bool _ready = false;
  bool _isFront = false;

  // ── Layout sizes ───────────────────────────────────────────────────────────
  Size? _screenSize;
  Size? _previewBoxSize;

  // ── Frame processing ───────────────────────────────────────────────────────
  int _lastProcessedMs = 0;
  static const int _processIntervalMs = 220;
  bool _processing = false;

  // ── ML Kit ─────────────────────────────────────────────────────────────────
  late final FaceDetector _detector;

  // ── UI state ───────────────────────────────────────────────────────────────
  bool _faceInside = false;
  String _hint = 'Posisikan wajah di dalam lingkaran';
  Color _ringColor = Colors.red;

  // ── Capture ────────────────────────────────────────────────────────────────
  bool _capturing = false;

  // ── AE/AF timer ────────────────────────────────────────────────────────────
  Timer? _aeTimer;

  // ── Lifecycle guard ────────────────────────────────────────────────────────
  // Prevents re-entrant init/dispose races (e.g. double back-press,
  // or didChangeAppLifecycleState firing during teardown).
  bool _disposing = false;

  // ── Fill thresholds ────────────────────────────────────────────────────────
  static const double _minFill = 0.40;
  static const double _maxFill = 0.95;

  // ── Ring radius ratio ──────────────────────────────────────────────────────
  static const double _ringRatio = 0.72;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: false,
        enableContours: false,
        enableClassification: false,
        enableTracking: false,
      ),
    );
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Fire-and-forget safe stop — avoids accessing freed ByteBuffer.
    // NOTE: the AppBar back button already awaits _stopAndDispose()
    // before popping, so by the time dispose() runs this is usually
    // already a no-op (cam == null).
    _stopAndDispose();
    _detector.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_ready || _cam == null || _disposing) return;
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _pauseCamera();
      case AppLifecycleState.resumed:
        _initCamera();
      default:
        break;
    }
  }

  // ── Camera init ────────────────────────────────────────────────────────────

  Future<void> _initCamera() async {
    if (_disposing) return;
    await Permission.camera.request();

    final cameras = await availableCameras();
    final selected = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _isFront = selected.lensDirection == CameraLensDirection.front;

    final ctrl = CameraController(
      selected,
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );

    await ctrl.initialize();

    // If teardown started while we were awaiting initialize(), discard
    // this controller immediately instead of starting its stream.
    if (_disposing || !mounted) {
      try {
        await ctrl.dispose();
      } catch (_) {}
      return;
    }

    _cam = ctrl;

    try {
      await ctrl.lockCaptureOrientation(DeviceOrientation.portraitUp);
    } catch (_) {}

    if (mounted) setState(() => _ready = true);
    await ctrl.startImageStream(_onFrame);
    _startAeTimer();
  }

  Future<void> _pauseCamera() async {
    _aeTimer?.cancel();
    try {
      await _cam?.stopImageStream();
    } catch (_) {}
    try {
      await _cam?.dispose();
    } catch (_) {}
    _cam = null;
    if (mounted) setState(() => _ready = false);
  }

  /// Safely stop stream + dispose before leaving the page.
  ///
  /// Call this BEFORE popping the route (e.g. from the AppBar back
  /// button) — this is the key fix for "Image is already closed":
  /// it guarantees the previous [CameraController] is fully torn down
  /// before a new instance of this page can call [_initCamera] again.
  Future<void> _stopAndDispose() async {
    if (_disposing) return;
    _disposing = true;
    _aeTimer?.cancel();

    final cam = _cam;
    _cam = null; // nullify first to stop _onFrame from queuing new work

    if (cam == null) return;

    // Wait for any in-flight frame to finish
    while (_processing) {
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }

    try {
      if (cam.value.isStreamingImages) await cam.stopImageStream();
    } catch (_) {}
    try {
      await cam.dispose();
    } catch (_) {}
  }

  // ── AE / AF ────────────────────────────────────────────────────────────────

  void _startAeTimer() {
    _aeTimer?.cancel();
    _aeTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => _meterOnCircle(),
    );
    _meterOnCircle();
  }

  Future<void> _meterOnCircle() async {
    final cam = _cam;
    if (cam == null || !cam.value.isInitialized) return;
    if (_screenSize == null || _previewBoxSize == null) return;

    final pt = _circleCenterOnPreview01();
    await _applyFocusExposure(cam, pt, exposureOffset: 0.4);
  }

  Future<void> _applyFocusExposure(
    CameraController cam,
    Offset point, {
    required double exposureOffset,
  }) async {
    try {
      await cam.setFocusMode(FocusMode.auto);
    } catch (_) {}
    try {
      await cam.setExposureMode(ExposureMode.auto);
    } catch (_) {}
    try {
      await cam.setFocusPoint(point);
    } catch (_) {}
    try {
      await cam.setExposurePoint(point);
    } catch (_) {}
    try {
      final min = await cam.getMinExposureOffset();
      final max = await cam.getMaxExposureOffset();
      await cam.setExposureOffset(exposureOffset.clamp(min, max));
    } catch (_) {}
  }

  // ── Frame processing ───────────────────────────────────────────────────────

  Future<void> _onFrame(CameraImage image) async {
    if (!_ready || _processing || _capturing || _disposing) return;
    final cam = _cam; // capture local ref — may be nullified by _stopAndDispose
    if (cam == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastProcessedMs < _processIntervalMs) return;
    _lastProcessedMs = now;
    _processing = true;

    try {
      if (_screenSize == null || _previewBoxSize == null) return;

      final rotation = InputImageRotationValue.fromRawValue(
            cam.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      final format =
          InputImageFormatValue.fromRawValue(image.format.raw as int) ?? (Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888);

      final inputImage = InputImage.fromBytes(
        bytes: _concatPlanes(image.planes),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await _detector.processImage(inputImage);

      // Bail out if teardown started while ML Kit was processing —
      // avoids calling setState/_cam after dispose started.
      if (_disposing || !mounted) return;

      // Image size after rotation
      final rot = cam.description.sensorOrientation;
      final rotatedSize =
          (rot == 90 || rot == 270) ? Size(image.height.toDouble(), image.width.toDouble()) : Size(image.width.toDouble(), image.height.toDouble());

      // Map circle rect from screen to image coordinates
      Rect circleOnImage = _mapScreenRectToImageCover(
        _circleRect(_screenSize!),
        _screenSize!,
        _previewBoxSize!,
        rotatedSize,
      );

      // Mirror for front camera
      if (_isFront) {
        circleOnImage = Rect.fromLTWH(
          rotatedSize.width - circleOnImage.right,
          circleOnImage.top,
          circleOnImage.width,
          circleOnImage.height,
        );
      }

      final (ok, hint) = _evaluateFace(faces, circleOnImage);

      if (mounted) {
        setState(() {
          _faceInside = ok;
          _ringColor = ok ? Colors.green : Colors.red;
          _hint = hint;
        });
      }
    } catch (_) {
    } finally {
      _processing = false;
    }
  }

  /// Returns (isValid, hintMessage) based on face position vs circle.
  (bool, String) _evaluateFace(List<Face> faces, Rect circleOnImage) {
    if (faces.isEmpty) {
      return (false, 'Posisikan wajah di dalam lingkaran');
    }

    faces.sort(
      (a, b) => b.boundingBox.area().compareTo(a.boundingBox.area()),
    );
    final box = faces.first.boundingBox;
    final cx = circleOnImage.center.dx;
    final cy = circleOnImage.center.dy;
    final radius = math.min(circleOnImage.width, circleOnImage.height) / 2;
    final margin = radius * 0.03;

    final center = box.center;
    final corners = [
      box.topLeft,
      box.topRight,
      box.bottomLeft,
      box.bottomRight,
    ];

    final centerInside = (center - Offset(cx, cy)).distance <= radius - margin;
    final cornersInside = corners.every(
      (p) => (p - Offset(cx, cy)).distance <= radius - margin,
    );

    if (!centerInside && !cornersInside) {
      return (false, 'Geser wajah ke tengah lingkaran');
    }

    final fill = math.sqrt(
          box.width * box.width + box.height * box.height,
        ) /
        (2 * radius);

    if (fill < _minFill) return (false, 'Maju sedikit');
    if (fill > _maxFill) return (false, 'Mundur sedikit');
    return (true, 'Tahan…');
  }

  // ── Capture ────────────────────────────────────────────────────────────────

  Future<void> _capture() async {
    if (!_faceInside || _capturing) return;
    final cam = _cam;
    if (cam == null || !cam.value.isInitialized) return;
    if (_screenSize == null || _previewBoxSize == null) return;

    setState(() => _capturing = true);
    try {
      _aeTimer?.cancel();

      if (cam.value.isStreamingImages) {
        try {
          await cam.stopImageStream();
        } catch (_) {}
      }

      // Pre-focus and lock to reduce blur
      await _prefocusAndLock(cam);
      await Future.delayed(const Duration(milliseconds: 120));

      final shot = await cam.takePicture();
      final resultFile = await _processCapturedImage(File(shot.path));

      if (resultFile != null) {
        // Stop & dispose BEFORE popping — same fix as the back button.
        await _stopAndDispose();
        if (mounted) Navigator.of(context).pop(resultFile);
        return;
      }

      // Decoding failed — restore camera and let user retry.
      try {
        await cam.startImageStream(_onFrame);
      } catch (_) {}
      await _restoreAutoMode(cam);
    } catch (e) {
      try {
        await _cam?.startImageStream(_onFrame);
      } catch (_) {}
      if (_cam != null && _cam!.value.isInitialized) {
        await _restoreAutoMode(_cam!);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memotret: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  Future<File?> _processCapturedImage(File raw) async {
    final bytes = await raw.readAsBytes();
    imglib.Image? full = imglib.decodeImage(bytes);
    if (full == null) return null;

    // Rotate to portrait if needed
    if (full.width > full.height) {
      full = imglib.copyRotate(full, angle: 90);
    }

    // Mirror for front camera to align with overlay
    if (_isFront) {
      full = imglib.flipHorizontal(full);
    }

    final circleOnImage = _mapScreenRectToImageCover(
      _circleRect(_screenSize!),
      _screenSize!,
      _previewBoxSize!,
      Size(full.width.toDouble(), full.height.toDouble()),
    );

    final x = circleOnImage.left.floor().clamp(0, full.width - 1);
    final y = circleOnImage.top.floor().clamp(0, full.height - 1);
    final w = circleOnImage.width.floor().clamp(1, full.width - x);
    final h = circleOnImage.height.floor().clamp(1, full.height - y);

    final cropped = imglib.copyCrop(full, x: x, y: y, width: w, height: h);
    final masked = _applyCircleMask(cropped);

    final outPath = raw.path.replaceFirst(
      RegExp(r'\.jpe?g$', caseSensitive: false),
      '_circle.png',
    );
    final outFile = File(outPath);
    await outFile.writeAsBytes(imglib.encodePng(masked), flush: true);
    return outFile;
  }

  Future<void> _prefocusAndLock(CameraController cam) async {
    if (_screenSize == null || _previewBoxSize == null) return;
    final pt = _circleCenterOnPreview01();
    await _applyFocusExposure(cam, pt, exposureOffset: 0.0);
    await Future.delayed(const Duration(milliseconds: 350));
    try {
      await cam.setFocusMode(FocusMode.locked);
    } catch (_) {}
    try {
      await cam.setExposureMode(ExposureMode.locked);
    } catch (_) {}
  }

  Future<void> _restoreAutoMode(CameraController cam) async {
    await _applyFocusExposure(
      cam,
      _circleCenterOnPreview01(),
      exposureOffset: 0.4,
    );
    _startAeTimer();
  }

  // ── Geometry helpers ───────────────────────────────────────────────────────

  Rect _circleRect(Size screen) {
    final shortest = math.min(screen.width, screen.height);
    final diameter = shortest * _ringRatio;
    return Rect.fromCenter(
      center: Offset(screen.width / 2, screen.height / 3 + diameter / 2),
      width: diameter,
      height: diameter,
    );
  }

  Offset _circleCenterOnPreview01() {
    final circle = _circleRect(_screenSize!);
    final s1 = math.max(
      _screenSize!.width / _previewBoxSize!.width,
      _screenSize!.height / _previewBoxSize!.height,
    );
    final dispW = _previewBoxSize!.width * s1;
    final dispH = _previewBoxSize!.height * s1;
    final dx = (_screenSize!.width - dispW) / 2.0;
    final dy = (_screenSize!.height - dispH) / 2.0;

    final bx = (circle.center.dx - dx) / s1;
    final by = (circle.center.dy - dy) / s1;

    return Offset(
      (bx / _previewBoxSize!.width).clamp(0.0, 1.0),
      (by / _previewBoxSize!.height).clamp(0.0, 1.0),
    );
  }

  Rect _mapScreenRectToImageCover(
    Rect screenRect,
    Size screen,
    Size box,
    Size image,
  ) {
    final s1 = math.max(screen.width / box.width, screen.height / box.height);
    final dispW = box.width * s1;
    final dispH = box.height * s1;
    final dx = (screen.width - dispW) / 2.0;
    final dy = (screen.height - dispH) / 2.0;

    final bx = (screenRect.left - dx) / s1;
    final by = (screenRect.top - dy) / s1;
    final bw = screenRect.width / s1;
    final bh = screenRect.height / s1;

    final s2 = math.max(box.width / image.width, box.height / image.height);
    final visW = box.width / s2;
    final visH = box.height / s2;
    final offX = (image.width - visW) / 2.0;
    final offY = (image.height - visH) / 2.0;

    return Rect.fromLTWH(
      offX + (bx / box.width) * visW,
      offY + (by / box.height) * visH,
      (bw / box.width) * visW,
      (bh / box.height) * visH,
    );
  }

  imglib.Image _applyCircleMask(imglib.Image src) {
    final w = src.width;
    final h = src.height;
    final cx = w / 2.0;
    final cy = h / 2.0;
    final r2 = math.pow(math.min(w, h) / 2.0, 2);

    for (int y = 0; y < h; y++) {
      final dy = (y + 0.5) - cy;
      for (int x = 0; x < w; x++) {
        final dx = (x + 0.5) - cx;
        if (dx * dx + dy * dy > r2) {
          final p = src.getPixel(x, y);
          src.setPixelRgba(x, y, p.r.toInt(), p.g.toInt(), p.b.toInt(), 0);
        }
      }
    }
    return src;
  }

  Uint8List _concatPlanes(List<Plane> planes) {
    final builder = BytesBuilder();
    for (final p in planes) {
      builder.add(p.bytes);
    }
    return builder.toBytes();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: Colors.black,
      appBar: AppPageBar(
        title: 'Verifikasi Wajah',
        // Stop & dispose camera BEFORE popping — this is the fix for
        // "Image is already closed" when re-entering this page:
        // without this, a new CameraController is created while the
        // old one is still tearing down in the background, causing
        // overlapping ImageReader sessions on Android.
        onBack: () async {
          await _stopAndDispose();
          if (mounted) context.pop();
        },
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                _screenSize = Size(constraints.maxWidth, constraints.maxHeight);
                final pv = _cam!.value.previewSize!;
                _previewBoxSize = Size(pv.height, pv.width);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Live preview ─────────────────────────────────────
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _previewBoxSize!.width,
                        height: _previewBoxSize!.height,
                        child: CameraPreview(_cam!),
                      ),
                    ),

                    // ── Circle overlay ───────────────────────────────────
                    IgnorePointer(
                      child: CustomPaint(
                        painter: _CircleOverlayPainter(
                          ringColor: _ringColor,
                          circleRect: _circleRect(_screenSize!),
                        ),
                        size: Size.infinite,
                      ),
                    ),

                    // ── Hint text ────────────────────────────────────────
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 48,
                      child: Text(
                        _hint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Colors.black54, blurRadius: 8),
                          ],
                        ),
                      ),
                    ),

                    // ── Capture loading overlay ──────────────────────────
                    if (_capturing)
                      const ColoredBox(
                        color: Colors.black45,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              },
            ),
      floatingActionButton: _faceInside
          ? FloatingActionButton.extended(
              onPressed: _capture,
              backgroundColor: Colors.green,
              icon: const Icon(Icons.check),
              label: const Text('Verifikasi'),
            )
          : null,
    );
  }
}

// ─── Circle Overlay Painter ───────────────────────────────────────────────────

class _CircleOverlayPainter extends CustomPainter {
  final Color ringColor;
  final Rect circleRect;

  const _CircleOverlayPainter({
    required this.ringColor,
    required this.circleRect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dim outside circle
    final dimPath = Path()
      ..addRect(Offset.zero & size)
      ..addOval(circleRect);
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        dimPath,
        Path()
          ..addOval(
            circleRect,
          ),
      ),
      Paint()..color = Colors.black.withOpacity(0.35),
    );

    // Ring
    canvas.drawOval(
      circleRect,
      Paint()
        ..color = ringColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(
    _CircleOverlayPainter old,
  ) =>
      old.ringColor != ringColor || old.circleRect != circleRect;
}

extension on Rect {
  double area() => width * height;
}
