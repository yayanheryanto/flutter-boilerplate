import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/auth/domain/entities/registered_user.dart';
import 'package:emas/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool termsAccepted;

  const RegisterParams({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.termsAccepted,
  });

  @override
  List<Object?> get props => [name, phone, email, termsAccepted];
}

/// Mendaftarkan akun baru. OTP diminta terpisah lewat `RequestOtpUseCase`.
@injectable
class RegisterUseCase extends UseCase<RegisteredUser, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<AppFailure, RegisteredUser>> call(RegisterParams params) {
    return _repository.register(
      name: params.name.trim(),
      phone: normalizePhone(params.phone),
      email: params.email.trim().toLowerCase(),
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      termsAccepted: params.termsAccepted,
    );
  }
}

/// Menyeragamkan nomor HP ke format lokal `08xxxxxxxx`:
/// buang spasi/strip/kurung, ubah prefix `+62`/`62` menjadi `0`.
String normalizePhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
  if (digits.startsWith('62')) return '0${digits.substring(2)}';
  return digits;
}
