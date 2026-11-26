import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/entities/otp_challenge.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/domain/repositories/auth_repository.dart';
import 'package:emas/features/auth/domain/usecases/auth/register_usecase.dart';

// ─── RequestOtpUseCase ───────────────────────────────────────────────────────

class RequestOtpParams extends Equatable {
  final String phone;
  final OtpPurpose purpose;

  const RequestOtpParams({required this.phone, required this.purpose});

  @override
  List<Object?> get props => [phone, purpose];
}

/// Meminta OTP dikirim ke nomor HP (mis. setelah pendaftaran berhasil).
@injectable
class RequestOtpUseCase extends UseCase<OtpChallenge, RequestOtpParams> {
  final AuthRepository _repository;

  RequestOtpUseCase(this._repository);

  @override
  Future<Either<AppFailure, OtpChallenge>> call(RequestOtpParams params) {
    return _repository.requestOtp(
      phone: normalizePhone(params.phone),
      purpose: params.purpose,
    );
  }
}

// ─── VerifyOtpUseCase ────────────────────────────────────────────────────────

class VerifyOtpParams extends Equatable {
  final String verificationId;
  final String code;

  const VerifyOtpParams({required this.verificationId, required this.code});

  @override
  List<Object?> get props => [verificationId, code];
}

/// Memverifikasi OTP pendaftaran; bila benar user langsung login.
@injectable
class VerifyOtpUseCase extends UseCase<AuthEntity, VerifyOtpParams> {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthEntity>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(
      verificationId: params.verificationId,
      code: params.code,
    );
  }
}

// ─── ResendOtpUseCase ────────────────────────────────────────────────────────

@injectable
class ResendOtpUseCase extends UseCase<OtpChallenge, String> {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  /// [verificationId] dari [OtpChallenge] sebelumnya.
  @override
  Future<Either<AppFailure, OtpChallenge>> call(String verificationId) {
    return _repository.resendOtp(verificationId: verificationId);
  }
}
