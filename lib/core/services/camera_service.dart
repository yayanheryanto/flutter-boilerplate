import 'dart:io';

import 'package:emas/core/constants/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';


abstract class CameraService {
  Future<File?> takePhoto({int? imageQuality, int? maxWidth});
  Future<File?> takeSelfie({int? imageQuality, int? maxWidth});
  Future<File?> pickFromGallery({int? imageQuality, int? maxWidth});
  Future<List<File>> pickMultipleFromGallery({int? imageQuality});
}

@LazySingleton(as: CameraService)
class CameraServiceImpl implements CameraService {
  final ImagePicker _picker;

  CameraServiceImpl(this._picker);

  @override
  Future<File?> takePhoto({
    int? imageQuality,
    int? maxWidth,
  }) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality ?? AppConstants.imageQuality,
      maxWidth: (maxWidth ?? AppConstants.maxImageWidth).toDouble(),
    );
    return picked != null ? File(picked.path) : null;
  }

  @override
  Future<File?> takeSelfie({
    int? imageQuality,
    int? maxWidth,
  }) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: imageQuality ?? AppConstants.imageQuality,
      maxWidth: (maxWidth ?? AppConstants.maxImageWidth).toDouble(),
    );
    return picked != null ? File(picked.path) : null;
  }

  @override
  Future<File?> pickFromGallery({
    int? imageQuality,
    int? maxWidth,
  }) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: imageQuality ?? AppConstants.imageQuality,
      maxWidth: (maxWidth ?? AppConstants.maxImageWidth).toDouble(),
    );
    return picked != null ? File(picked.path) : null;
  }

  @override
  Future<List<File>> pickMultipleFromGallery({int? imageQuality}) async {
    final picked = await _picker.pickMultiImage(
      imageQuality: imageQuality ?? AppConstants.imageQuality,
    );
    return picked.map((x) => File(x.path)).toList();
  }
}