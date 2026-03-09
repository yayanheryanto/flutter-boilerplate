import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/network/dio_client.dart';
import 'package:boilerplate/features/auth/data/datasources/auth_remote_datasource.dart';

/// Feature DI module for Auth.
/// Registers auth-specific dependencies that depend on core (e.g. DioClient).
/// Keeps core/di free of feature imports (Clean Architecture).
@module
abstract class AuthModule {
  @lazySingleton
  AuthRemoteDataSource authRemoteDataSource(DioClient client) =>
      AuthRemoteDataSource(client.dio);
}
