import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';

abstract class FilePickerService {
  Future<File?> pickFile({List<String>? allowedExtensions});
  Future<List<File>> pickMultipleFiles({List<String>? allowedExtensions});
  Future<File?> pickPDF();
}

@LazySingleton(as: FilePickerService)
class FilePickerServiceImpl implements FilePickerService {
  @override
  Future<File?> pickFile({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    if (result?.files.single.path != null) {
      return File(result!.files.single.path!);
    }
    return null;
  }

  @override
  Future<List<File>> pickMultipleFiles({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );
    return result?.files
            .where((f) => f.path != null)
            .map((f) => File(f.path!))
            .toList() ??
        [];
  }

  @override
  Future<File?> pickPDF() async {
    return pickFile(allowedExtensions: ['pdf']);
  }
}
