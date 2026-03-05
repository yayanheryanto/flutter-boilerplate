import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/network/dio_client.dart';
import 'package:boilerplate/features/auth/data/datasources/auth_remote_datasource.dart';

/// Injectable @module — mendaftarkan dependensi yang tidak bisa di-annotate
/// langsung karena merupakan kelas dari package eksternal.
///
/// Semua yang ada di sini adalah kelas milik package lain (bukan milik kita),
/// sehingga tidak bisa diberi @injectable/@lazySingleton secara langsung.
/// Dengan @module, injectable_generator tetap bisa me-resolve mereka sebagai
/// parameter constructor untuk kelas-kelas milik kita.
@module
abstract class AppModule {

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  AuthRemoteDataSource authRemoteDataSource(DioClient client) =>
      AuthRemoteDataSource(client.dio);
}
