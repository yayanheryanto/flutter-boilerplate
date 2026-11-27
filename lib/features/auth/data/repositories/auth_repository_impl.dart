import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_exception.dart';
import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/errors/error_mapper.dart';
import 'package:emas/core/services/device_id_service.dart';
import 'package:emas/core/services/token_service.dart';
import 'package:emas/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:emas/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emas/features/auth/data/models/auth_model.dart';
import 'package:emas/features/auth/data/models/login_request_model.dart';
import 'package:emas/features/auth/data/models/otp_request_model.dart';
import 'package:emas/features/auth/data/models/register_request_model.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/entities/otp_challenge.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/domain/entities/registered_user.dart';
import 'package:emas/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenService _tokenService;
  final DeviceIdService _deviceIdService;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._tokenService,
    this._deviceIdService,
  );

  @override
  Future<Either<AppFailure, AuthEntity>> login({
    required String phone,
    required String password,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.login(
        LoginRequestModel(
          phone: phone,
          password: password,
          deviceId: await _deviceIdService.getDeviceId(),
        ),
      );
      await _saveAuth(model);
      return model.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, RegisteredUser>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required bool termsAccepted,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.register(
        RegisterRequestModel(
          name: name,
          phone: phone,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
          termsAccepted: termsAccepted,
          deviceId: await _deviceIdService.getDeviceId(),
        ),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, OtpChallenge>> requestOtp({
    required String phone,
    required OtpPurpose purpose,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.requestOtp(
        RequestOtpRequestModel(phone: phone, purpose: _purposeToApi(purpose)),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, AuthEntity>> verifyOtp({
    required String verificationId,
    required String code,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.verifyOtp(
        VerifyOtpRequestModel(verificationId: verificationId, code: code),
      );
      await _saveAuth(model);
      return model.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, OtpChallenge>> resendOtp({
    required String verificationId,
  }) {
    return _guard(() async {
      final model = await _remoteDataSource.resendOtp(
        ResendOtpRequestModel(verificationId: verificationId),
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, Unit>> logout() async {
    // Sesi lokal selalu dibersihkan, apa pun hasil request ke server.
    final result = await _guard(() async {
      await _remoteDataSource.logout();
      return unit;
    });
    await _clearAuth();
    return result;
  }

  @override
  Future<Either<AppFailure, AuthEntity>> refreshToken() async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null) {
      return const Left(UnauthorizedFailure());
    }
    return _guard(() async {
      final model = await _remoteDataSource.refreshToken({
        'refresh_token': refreshToken,
      });
      await _saveAuth(model);
      return model.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, AuthEntity?>> getCachedAuth() {
    return _guard(() async {
      final model = await _localDataSource.getAuth();
      return model?.toEntity();
    });
  }

  @override
  Future<Either<AppFailure, Unit>> forgotPassword({
    required String email,
  }) {
    return _guard(() async {
      await _remoteDataSource.forgotPassword({'email': email});
      return unit;
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Nilai `purpose` di API (snake_case) — format wire, jadi ada di data layer.
  String _purposeToApi(OtpPurpose purpose) => switch (purpose) {
        OtpPurpose.register => 'register',
        OtpPurpose.forgotPassword => 'forgot_password',
        OtpPurpose.changePassword => 'change_password',
      };

  /// Satu tempat untuk mengubah exception menjadi [AppFailure], supaya tiap
  /// method repository cukup berisi "jalur bahagia".
  Future<Either<AppFailure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapException(e));
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
