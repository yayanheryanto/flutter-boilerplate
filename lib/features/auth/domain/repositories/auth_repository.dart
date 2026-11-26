import 'package:fpdart/fpdart.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/entities/otp_challenge.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/domain/entities/registered_user.dart';

abstract class AuthRepository {
  Future<Either<AppFailure, AuthEntity>> login({
    required String email,
    required String password,
  });

  /// Mendaftarkan akun baru. Akun belum aktif sampai nomor HP
  /// diverifikasi: lanjutkan dengan [requestOtp] lalu [verifyOtp].
  Future<Either<AppFailure, RegisteredUser>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required bool termsAccepted,
  });

  /// Meminta server mengirim OTP ke [phone] untuk [purpose].
  Future<Either<AppFailure, OtpChallenge>> requestOtp({
    required String phone,
    required OtpPurpose purpose,
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
