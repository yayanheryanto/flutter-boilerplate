import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/entities/otp_challenge.dart';
import 'package:emas/features/auth/domain/repositories/auth_repository.dart';

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
