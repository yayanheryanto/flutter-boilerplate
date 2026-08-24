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

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({super.key});

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage>
    with WidgetsBindingObserver {
  // ─────────────────────────────────────────────────────────────────────────
  // Camera
  // ─────────────────────────────────────────────────────────────────────────

  CameraController? _cam;

  bool _ready = false;
  bool _isFront = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Layout
  // ─────────────────────────────────────────────────────────────────────────

  Size? _screenSize;
  Size? _previewBoxSize;

  // ─────────────────────────────────────────────────────────────────────────
  // Frame processing
  // ─────────────────────────────────────────────────────────────────────────

  int _lastProcessedMs = 0;

  static const int _processIntervalMs = 220;

  bool _processing = false;

  // ─────────────────────────────────────────────────────────────────────────
  // ML Kit
  // ─────────────────────────────────────────────────────────────────────────

  late final FaceDetector _detector;

  // ─────────────────────────────────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────────────────────────────────

  bool _faceInside = false;

  String _hint =
      'Posisikan wajah di dalam lingkaran';

  Color _ringColor = Colors.red;

  // ─────────────────────────────────────────────────────────────────────────
  // Capture
  // ─────────────────────────────────────────────────────────────────────────

  bool _capturing = false;

  // ─────────────────────────────────────────────────────────────────────────
  // AE / AF
  // ─────────────────────────────────────────────────────────────────────────

  Timer? _aeTimer;

  bool _applyingAe = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle guards
  // ─────────────────────────────────────────────────────────────────────────

  bool _disposing = false;

  bool _initializing = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Face thresholds
  // ─────────────────────────────────────────────────────────────────────────

  static const double _minFill = 0.40;
  static const double _maxFill = 0.95;

  static const double _ringRatio = 0.72;

  // ─────────────────────────────────────────────────────────────────────────
  // Init
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _detector = FaceDetector(
      options: FaceDetectorOptions(),
    );

    unawaited(_initCamera());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dispose
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _disposing = true;

    _aeTimer?.cancel();
    _aeTimer = null;

    final cam = _cam;

    _cam = null;
    _ready = false;

    unawaited(
      _cleanupCamera(cam),
    );

    unawaited(_detector.close());

    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // App lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    if (_disposing) return;

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        unawaited(_pauseCamera());

      case AppLifecycleState.resumed:
        if (!_ready && !_initializing) {
          unawaited(_initCamera());
        }

      default:
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Camera initialization
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _initCamera() async {
    if (_disposing || _initializing) {
      return;
    }

    _initializing = true;

    CameraController? ctrl;

    try {
      final permission =
      await Permission.camera.request();

      if (!permission.isGranted) {
        return;
      }

      if (_disposing || !mounted) {
        return;
      }

      final cameras =
      await availableCameras();

      if (_disposing ||
          !mounted ||
          cameras.isEmpty) {
        return;
      }

      final selected =
      cameras.firstWhere(
            (camera) =>
        camera.lensDirection ==
            CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _isFront =
          selected.lensDirection ==
              CameraLensDirection.front;

      ctrl = CameraController(
        selected,
        ResolutionPreset.high,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
        enableAudio: false,
      );

      await ctrl.initialize();

      if (_disposing || !mounted) {
        await _cleanupCamera(ctrl);
        ctrl = null;
        return;
      }

      _cam = ctrl;

      try {
        await ctrl.lockCaptureOrientation(
          DeviceOrientation.portraitUp,
        );
      } catch (_) {}

      if (_disposing || !mounted) {
        if (_cam == ctrl) {
          _cam = null;
        }

        await _cleanupCamera(ctrl);
        ctrl = null;
        return;
      }

      await ctrl.startImageStream(
        _onFrame,
      );

      if (_disposing || !mounted) {
        if (_cam == ctrl) {
          _cam = null;
        }

        try {
          await ctrl.stopImageStream();
        } catch (_) {}

        await _cleanupCamera(ctrl);

        ctrl = null;
        return;
      }

      if (mounted) {
        setState(() {
          _ready = true;
          _faceInside = false;
          _hint =
          'Posisikan wajah di dalam lingkaran';
          _ringColor = Colors.red;
        });
      }

      _startAeTimer();
    } catch (e) {
      if (ctrl != null) {
        await _cleanupCamera(ctrl);
      }

      if (_cam == ctrl) {
        _cam = null;
      }

      if (mounted && !_disposing) {
        setState(() {
          _ready = false;
        });

        AppSnackBar.show(
          context,
          'Gagal mengaktifkan kamera: $e',
        );
      }
    } finally {
      _initializing = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Pause camera
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _pauseCamera() async {
    if (_disposing) return;

    _aeTimer?.cancel();
    _aeTimer = null;

    final cam = _cam;

    _cam = null;

    if (mounted) {
      setState(() {
        _ready = false;
        _faceInside = false;
      });
    }

    if (cam == null) {
      return;
    }

    await _cleanupCamera(cam);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cleanup camera
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _cleanupCamera(
      CameraController? cam,
      ) async {
    if (cam == null) return;

    try {
      if (cam.value.isStreamingImages) {
        await cam.stopImageStream();
      }
    } catch (_) {}

    try {
      await cam.dispose();
    } catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Back / stop camera
  //
  // IMPORTANT:
  // Tidak menunggu camera.dispose().
  // Route langsung di-pop agar UX tidak terasa lambat.
  // ─────────────────────────────────────────────────────────────────────────

  void _handleBack() {
    if (_disposing) {
      return;
    }

    _disposing = true;

    _aeTimer?.cancel();
    _aeTimer = null;

    final cam = _cam;

    // Putuskan controller dari state terlebih dahulu.
    _cam = null;

    _ready = false;
    _faceInside = false;

    // Cleanup berjalan di background.
    unawaited(
      _cleanupCamera(cam),
    );

    // Pop langsung.
    if (mounted) {
      context.pop();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AE / AF timer
  // ─────────────────────────────────────────────────────────────────────────

  void _startAeTimer() {
    if (_disposing) return;

    _aeTimer?.cancel();

    _aeTimer = Timer.periodic(
      const Duration(seconds: 4),
          (_) {
        unawaited(
          _meterOnCircle(),
        );
      },
    );

    unawaited(
      _meterOnCircle(),
    );
  }

  Future<void> _meterOnCircle() async {
    if (_disposing ||
        _applyingAe) {
      return;
    }

    final cam = _cam;

    if (cam == null ||
        !cam.value.isInitialized) {
      return;
    }

    final screen = _screenSize;
    final previewBox = _previewBoxSize;

    if (screen == null ||
        previewBox == null) {
      return;
    }

    _applyingAe = true;

    try {
      final point =
      _circleCenterOnPreview01();

      await _applyFocusExposure(
        cam,
        point,
        exposureOffset: 0.4,
      );
    } finally {
      _applyingAe = false;
    }
  }

  Future<void> _applyFocusExposure(
      CameraController cam,
      Offset point, {
        required double exposureOffset,
      }) async {
    if (_disposing) return;

    try {
      await cam.setFocusMode(
        FocusMode.auto,
      );
    } catch (_) {}

    if (_disposing) return;

    try {
      await cam.setExposureMode(
        ExposureMode.auto,
      );
    } catch (_) {}

    if (_disposing) return;

    try {
      await cam.setFocusPoint(point);
    } catch (_) {}

    if (_disposing) return;

    try {
      await cam.setExposurePoint(point);
    } catch (_) {}

    if (_disposing) return;

    try {
      final min =
      await cam.getMinExposureOffset();

      final max =
      await cam.getMaxExposureOffset();

      if (_disposing) return;

      await cam.setExposureOffset(
        exposureOffset.clamp(
          min,
          max,
        ),
      );
    } catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Frame processing
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onFrame(
      CameraImage image,
      ) async {
    if (_disposing ||
        !_ready ||
        _processing ||
        _capturing) {
      return;
    }

    final cam = _cam;

    if (cam == null ||
        !cam.value.isInitialized) {
      return;
    }

    final now =
        DateTime.now().millisecondsSinceEpoch;

    if (now - _lastProcessedMs <
        _processIntervalMs) {
      return;
    }

    _lastProcessedMs = now;

    _processing = true;

    try {
      final screen = _screenSize;
      final previewBox =
          _previewBoxSize;

      if (screen == null ||
          previewBox == null) {
        return;
      }

      final rotation =
          InputImageRotationValue.fromRawValue(
            cam.description
                .sensorOrientation,
          ) ??
              InputImageRotation
                  .rotation0deg;

      final format =
          InputImageFormatValue.fromRawValue(
            image.format.raw as int,
          ) ??
              (Platform.isAndroid
                  ? InputImageFormat.nv21
                  : InputImageFormat.bgra8888);

      final inputImage =
      InputImage.fromBytes(
        bytes: _concatPlanes(
          image.planes,
        ),
        metadata:
        InputImageMetadata(
          size: Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          rotation: rotation,
          format: format,
          bytesPerRow:
          image.planes
              .first.bytesPerRow,
        ),
      );

      final faces =
      await _detector.processImage(
        inputImage,
      );

      if (_disposing ||
          !mounted) {
        return;
      }

      final rot =
          cam.description
              .sensorOrientation;

      final rotatedSize =
      (rot == 90 || rot == 270)
          ? Size(
        image.height
            .toDouble(),
        image.width
            .toDouble(),
      )
          : Size(
        image.width
            .toDouble(),
        image.height
            .toDouble(),
      );

      Rect circleOnImage =
      _mapScreenRectToImageCover(
        _circleRect(screen),
        screen,
        previewBox,
        rotatedSize,
      );

      if (_isFront) {
        circleOnImage =
            Rect.fromLTWH(
              rotatedSize.width -
                  circleOnImage.right,
              circleOnImage.top,
              circleOnImage.width,
              circleOnImage.height,
            );
      }

      final (ok, hint) =
      _evaluateFace(
        faces,
        circleOnImage,
      );

      if (_disposing ||
          !mounted) {
        return;
      }

      setState(() {
        _faceInside = ok;
        _ringColor =
        ok ? Colors.green : Colors.red;
        _hint = hint;
      });
    } catch (_) {
      // Ignore camera / MLKit frame errors.
    } finally {
      _processing = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Face evaluation
  // ─────────────────────────────────────────────────────────────────────────

  (bool, String) _evaluateFace(
      List<Face> faces,
      Rect circleOnImage,
      ) {
    if (faces.isEmpty) {
      return (
      false,
      'Posisikan wajah di dalam lingkaran',
      );
    }

    faces.sort(
          (a, b) => b.boundingBox
          .area()
          .compareTo(
        a.boundingBox.area(),
      ),
    );

    final box =
        faces.first.boundingBox;

    final center =
        circleOnImage.center;

    final radius =
        math.min(
          circleOnImage.width,
          circleOnImage.height,
        ) /
            2;

    final margin =
        radius * 0.03;

    final faceCenter =
        box.center;

    final corners = [
      box.topLeft,
      box.topRight,
      box.bottomLeft,
      box.bottomRight,
    ];

    final centerInside =
        (faceCenter - center)
            .distance <=
            radius - margin;

    final cornersInside =
    corners.every(
          (point) =>
      (point - center)
          .distance <=
          radius - margin,
    );

    if (!centerInside &&
        !cornersInside) {
      return (
      false,
      'Geser wajah ke tengah lingkaran',
      );
    }

    final fill = math.sqrt(
      box.width * box.width +
          box.height * box.height,
    ) /
        (2 * radius);

    if (fill < _minFill) {
      return (
      false,
      'Maju sedikit',
      );
    }

    if (fill > _maxFill) {
      return (
      false,
      'Mundur sedikit',
      );
    }

    return (
    true,
    'Tahan…',
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Capture
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _capture() async {
    if (_disposing ||
        !_faceInside ||
        _capturing) {
      return;
    }

    final cam = _cam;

    if (cam == null ||
        !cam.value.isInitialized) {
      return;
    }

    final screen = _screenSize;
    final previewBox =
        _previewBoxSize;

    if (screen == null ||
        previewBox == null) {
      return;
    }

    setState(() {
      _capturing = true;
    });

    try {
      _aeTimer?.cancel();
      _aeTimer = null;

      if (cam.value.isStreamingImages) {
        try {
          await cam.stopImageStream();
        } catch (_) {}
      }

      if (_disposing) return;

      await _prefocusAndLock(
        cam,
      );

      if (_disposing) return;

      await Future<void>.delayed(
        const Duration(
          milliseconds: 120,
        ),
      );

      if (_disposing) return;

      final shot =
      await cam.takePicture();

      if (_disposing) return;

      final result =
      await _processCapturedImage(
        File(shot.path),
      );

      if (_disposing) return;

      if (result != null) {
        final oldCam = _cam;

        _cam = null;
        _ready = false;

        _aeTimer?.cancel();
        _aeTimer = null;

        unawaited(
          _cleanupCamera(oldCam),
        );

        if (mounted) {
          Navigator.of(context)
              .pop(result);
        }

        return;
      }

      if (!_disposing) {
        try {
          await cam.startImageStream(
            _onFrame,
          );
        } catch (_) {}

        await _restoreAutoMode(
          cam,
        );
      }
    } catch (e) {
      if (!_disposing) {
        try {
          if (!cam.value.isStreamingImages) {
            await cam.startImageStream(
              _onFrame,
            );
          }
        } catch (_) {}

        if (!_disposing &&
            cam.value.isInitialized) {
          await _restoreAutoMode(
            cam,
          );
        }

        if (mounted) {
          AppSnackBar.show(
            context,
            'Gagal memotret: $e',
          );
        }
      }
    } finally {
      if (mounted && !_disposing) {
        setState(() {
          _capturing = false;
        });
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Process captured image
  // ─────────────────────────────────────────────────────────────────────────

  Future<File?> _processCapturedImage(
      File raw,
      ) async {
    final screen = _screenSize;
    final previewBox =
        _previewBoxSize;

    if (screen == null ||
        previewBox == null) {
      return null;
    }

    final bytes =
    await raw.readAsBytes();

    if (_disposing) {
      return null;
    }

    imglib.Image? full =
    imglib.decodeImage(bytes);

    if (full == null) {
      return null;
    }

    if (full.width > full.height) {
      full = imglib.copyRotate(
        full,
        angle: 90,
      );
    }

    if (_isFront) {
      full = imglib.flipHorizontal(
        full,
      );
    }

    final circleOnImage =
    _mapScreenRectToImageCover(
      _circleRect(screen),
      screen,
      previewBox,
      Size(
        full.width.toDouble(),
        full.height.toDouble(),
      ),
    );

    final x =
    circleOnImage.left
        .floor()
        .clamp(
      0,
      full.width - 1,
    );

    final y =
    circleOnImage.top
        .floor()
        .clamp(
      0,
      full.height - 1,
    );

    final w =
    circleOnImage.width
        .floor()
        .clamp(
      1,
      full.width - x,
    );

    final h =
    circleOnImage.height
        .floor()
        .clamp(
      1,
      full.height - y,
    );

    final cropped =
    imglib.copyCrop(
      full,
      x: x,
      y: y,
      width: w,
      height: h,
    );

    final masked =
    _applyCircleMask(
      cropped,
    );

    final outPath =
    raw.path.replaceFirst(
      RegExp(
        r'\.jpe?g$',
        caseSensitive: false,
      ),
      '_circle.png',
    );

    final outFile =
    File(outPath);

    await outFile.writeAsBytes(
      imglib.encodePng(masked),
      flush: true,
    );

    return outFile;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Prefocus
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _prefocusAndLock(
      CameraController cam,
      ) async {
    if (_disposing) return;

    final screen = _screenSize;
    final previewBox =
        _previewBoxSize;

    if (screen == null ||
        previewBox == null) {
      return;
    }

    final point =
    _circleCenterOnPreview01();

    await _applyFocusExposure(
      cam,
      point,
      exposureOffset: 0.0,
    );

    if (_disposing) return;

    await Future<void>.delayed(
      const Duration(
        milliseconds: 350,
      ),
    );

    if (_disposing) return;

    try {
      await cam.setFocusMode(
        FocusMode.locked,
      );
    } catch (_) {}

    if (_disposing) return;

    try {
      await cam.setExposureMode(
        ExposureMode.locked,
      );
    } catch (_) {}
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Restore AE / AF
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _restoreAutoMode(
      CameraController cam,
      ) async {
    if (_disposing) return;

    await _applyFocusExposure(
      cam,
      _circleCenterOnPreview01(),
      exposureOffset: 0.4,
    );

    if (_disposing) return;

    _startAeTimer();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Geometry
  // ─────────────────────────────────────────────────────────────────────────

  Rect _circleRect(
      Size screen,
      ) {
    final shortest =
    math.min(
      screen.width,
      screen.height,
    );

    final diameter =
        shortest * _ringRatio;

    return Rect.fromCenter(
      center: Offset(
        screen.width / 2,
        screen.height / 3 +
            diameter / 2,
      ),
      width: diameter,
      height: diameter,
    );
  }

  Offset _circleCenterOnPreview01() {
    final screen =
        _screenSize;

    final box =
        _previewBoxSize;

    if (screen == null ||
        box == null ||
        box.width <= 0 ||
        box.height <= 0) {
      return const Offset(
        0.5,
        0.5,
      );
    }

    final circle =
    _circleRect(screen);

    final s1 = math.max(
      screen.width / box.width,
      screen.height / box.height,
    );

    final dispW =
        box.width * s1;

    final dispH =
        box.height * s1;

    final dx =
        (screen.width - dispW) /
            2.0;

    final dy =
        (screen.height - dispH) /
            2.0;

    final bx =
        (circle.center.dx - dx) /
            s1;

    final by =
        (circle.center.dy - dy) /
            s1;

    return Offset(
      (bx / box.width)
          .clamp(0.0, 1.0),
      (by / box.height)
          .clamp(0.0, 1.0),
    );
  }

  Rect _mapScreenRectToImageCover(
      Rect screenRect,
      Size screen,
      Size box,
      Size image,
      ) {
    if (box.width <= 0 ||
        box.height <= 0 ||
        image.width <= 0 ||
        image.height <= 0) {
      return Rect.zero;
    }

    final s1 = math.max(
      screen.width / box.width,
      screen.height / box.height,
    );

    final dispW =
        box.width * s1;

    final dispH =
        box.height * s1;

    final dx =
        (screen.width - dispW) /
            2.0;

    final dy =
        (screen.height - dispH) /
            2.0;

    final bx =
        (screenRect.left - dx) /
            s1;

    final by =
        (screenRect.top - dy) /
            s1;

    final bw =
        screenRect.width / s1;

    final bh =
        screenRect.height / s1;

    final s2 = math.max(
      box.width / image.width,
      box.height / image.height,
    );

    final visW =
        box.width / s2;

    final visH =
        box.height / s2;

    final offX =
        (image.width - visW) /
            2.0;

    final offY =
        (image.height - visH) /
            2.0;

    return Rect.fromLTWH(
      offX +
          (bx / box.width) *
              visW,
      offY +
          (by / box.height) *
              visH,
      (bw / box.width) *
          visW,
      (bh / box.height) *
          visH,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Circle mask
  // ─────────────────────────────────────────────────────────────────────────

  imglib.Image _applyCircleMask(
      imglib.Image src,
      ) {
    final w = src.width;
    final h = src.height;

    final cx = w / 2.0;
    final cy = h / 2.0;

    final r2 = math.pow(
      math.min(w, h) / 2.0,
      2,
    );

    for (int y = 0; y < h; y++) {
      final dy =
          (y + 0.5) - cy;

      for (int x = 0; x < w; x++) {
        final dx =
            (x + 0.5) - cx;

        if (dx * dx + dy * dy >
            r2) {
          final p =
          src.getPixel(
            x,
            y,
          );

          src.setPixelRgba(
            x,
            y,
            p.r.toInt(),
            p.g.toInt(),
            p.b.toInt(),
            0,
          );
        }
      }
    }

    return src;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Plane concat
  // ─────────────────────────────────────────────────────────────────────────

  Uint8List _concatPlanes(
      List<Plane> planes,
      ) {
    final builder =
    BytesBuilder();

    for (final plane in planes) {
      builder.add(
        plane.bytes,
      );
    }

    return builder.toBytes();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(
      BuildContext context,
      ) {
    final cam = _cam;

    final canShowCamera =
        !_disposing &&
            _ready &&
            cam != null &&
            cam.value.isInitialized &&
            cam.value.previewSize != null;

    return AppScaffoldWrapper(
      backgroundColor: Colors.black,

      appBar: AppPageBar(
        title: 'Verifikasi Wajah',

        onBack: _handleBack,
      ),

      body: !canShowCamera
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : LayoutBuilder(
        builder: (
            context,
            constraints,
            ) {
          final previewSize =
              cam.value.previewSize;

          if (previewSize == null) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          _screenSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          _previewBoxSize =
              Size(
                previewSize.height,
                previewSize.width,
              );

          final screen =
              _screenSize;

          final previewBox =
              _previewBoxSize;

          if (screen == null ||
              previewBox == null) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // ─────────────────────────────────────────────────────
              // Camera preview
              // ─────────────────────────────────────────────────────

              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width:
                  previewBox.width,
                  height:
                  previewBox.height,
                  child:
                  CameraPreview(
                    cam,
                  ),
                ),
              ),

              // ─────────────────────────────────────────────────────
              // Circle overlay
              // ─────────────────────────────────────────────────────

              IgnorePointer(
                child:
                CustomPaint(
                  painter:
                  _CircleOverlayPainter(
                    ringColor:
                    _ringColor,
                    circleRect:
                    _circleRect(
                      screen,
                    ),
                  ),
                  size:
                  Size.infinite,
                ),
              ),

              // ─────────────────────────────────────────────────────
              // Hint
              // ─────────────────────────────────────────────────────

              Positioned(
                left: 16,
                right: 16,
                bottom: 48,
                child: Text(
                  _hint,
                  textAlign:
                  TextAlign.center,
                  style:
                  const TextStyle(
                    color:
                    Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.w600,
                    shadows: [
                      Shadow(
                        color:
                        Colors.black54,
                        blurRadius:
                        8,
                      ),
                    ],
                  ),
                ),
              ),

              // ─────────────────────────────────────────────────────
              // Loading
              // ─────────────────────────────────────────────────────

              if (_capturing)
                const ColoredBox(
                  color:
                  Colors.black45,
                  child:
                  Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),

      floatingActionButton:
      _faceInside &&
          !_capturing &&
          !_disposing
          ? FloatingActionButton.extended(
        onPressed:
        _capture,
        backgroundColor:
        Colors.green,
        icon: const Icon(
          Icons.check,
        ),
        label: const Text(
          'Verifikasi',
        ),
      )
          : null,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Circle Overlay Painter
// ─────────────────────────────────────────────────────────────────────────────

class _CircleOverlayPainter
    extends CustomPainter {
  final Color ringColor;
  final Rect circleRect;

  const _CircleOverlayPainter({
    required this.ringColor,
    required this.circleRect,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    final fullPath = Path()
      ..addRect(
        Offset.zero & size,
      );

    final circlePath = Path()
      ..addOval(circleRect);

    final dimPath =
    Path.combine(
      PathOperation.difference,
      fullPath,
      circlePath,
    );

    canvas.drawPath(
      dimPath,
      Paint()
        ..color =
        Colors.black.withOpacity(
          0.35,
        ),
    );

    canvas.drawOval(
      circleRect,
      Paint()
        ..color = ringColor
        ..style =
            PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(
      _CircleOverlayPainter oldDelegate,
      ) {
    return oldDelegate.ringColor !=
        ringColor ||
        oldDelegate.circleRect !=
            circleRect;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rect extension
// ─────────────────────────────────────────────────────────────────────────────

extension RectExtension on Rect {
  double area() => width * height;
}
