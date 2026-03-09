import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

/// Injectable @module — registers dependencies that cannot be annotated
/// directly (external package classes).
///
/// Core has no dependency on features. Feature-specific bindings (e.g. Auth)
/// live in their own feature di/ modules (Clean Architecture).
@module
abstract class AppModule {
  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}
