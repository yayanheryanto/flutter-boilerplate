import 'package:fpdart/fpdart.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/entities/otp_challenge.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, AuthEntity>> login({
    required String email,
    required String password,
  });

  /// Mendaftarkan akun baru. Akun belum aktif sampai OTP diverifikasi
  /// lewat [verifyOtp]; hasilnya berisi `verificationId` untuk langkah itu.
  Future<Either<AppFailure, OtpChallenge>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });

  /// Memverifikasi OTP. Bila benar, sesi login disimpan dan dikembalikan.
  Future<Either<AppFailure, AuthEntity>> verifyOtp({
    required String verificationId,
    required String code,
  });

  /// Meminta OTP baru untuk sesi verifikasi yang sama.
  Future<Either<AppFailure, OtpChallenge>> resendOtp({
    required String verificationId,
  });

  Future<Either<AppFailure, Unit>> logout();

  Future<Either<AppFailure, AuthEntity>> refreshToken();

  Future<Either<AppFailure, AuthEntity?>> getCachedAuth();

  Future<Either<AppFailure, Unit>> forgotPassword({required String email});
}
