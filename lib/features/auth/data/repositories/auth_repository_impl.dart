import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/errors/app_exception.dart';
import 'package:boilerplate/core/errors/app_failure.dart';
import 'package:boilerplate/core/errors/error_mapper.dart';
import 'package:boilerplate/core/services/token_service.dart';
import 'package:boilerplate/features/auth/domain/entities/auth_entity.dart';
import 'package:boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:boilerplate/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:boilerplate/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:boilerplate/features/auth/data/models/auth_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenService _tokenService;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._tokenService,
  );

  @override
  Future<Either<AppFailure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login({
        'email': email,
        'password': password,
      });

      await _saveAuth(model);

      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, AuthEntity>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final model = await _remoteDataSource.register({
        'email': email,
        'password': password,
        'name': name,
      });

      await _saveAuth(model);

      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _clearAuth();
      return const Right(unit);
    } on DioException catch (e) {
      // Still clear local auth even if remote fails
      await _clearAuth();
      return Left(ErrorMapper.mapDioException(e));
    } catch (e) {
      await _clearAuth();
      return const Right(unit);
    }
  }

  @override
  Future<Either<AppFailure, AuthEntity>> refreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) {
        return const Left(UnauthorizedFailure());
      }

      final model = await _remoteDataSource.refreshToken({
        'refresh_token': refreshToken,
      });

      await _saveAuth(model);

      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, AuthEntity?>> getCachedAuth() async {
    try {
      final model = await _localDataSource.getAuth();
      return Right(model?.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> forgotPassword({
    required String email,
  }) async {
    try {
      await _remoteDataSource.forgotPassword({'email': email});
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Future<void> _saveAuth(AuthModel model) async {
    await _localDataSource.saveAuth(model);
    await _tokenService.saveToken(model.accessToken);
    if (model.refreshToken != null) {
      await _tokenService.saveRefreshToken(model.refreshToken!);
    }
  }

  Future<void> _clearAuth() async {
    await _localDataSource.clearAuth();
    await _tokenService.clearTokens();
  }
}
