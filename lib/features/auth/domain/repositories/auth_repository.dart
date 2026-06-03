import 'package:fpdart/fpdart.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<AppFailure, AuthEntity>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<AppFailure, Unit>> logout();

  Future<Either<AppFailure, AuthEntity>> refreshToken();

  Future<Either<AppFailure, AuthEntity?>> getCachedAuth();

  Future<Either<AppFailure, Unit>> forgotPassword({required String email});
}
