part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  /// Error dari server per field (kosong bila tidak ada).
  Map<String, String> get fieldErrors => const {};

  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

final class RegisterInProgress extends RegisterState {
  const RegisterInProgress();
}

/// Akun berhasil dibuat (respons register) — lanjut ke halaman OTP,
/// yang akan me-request OTP ke [RegisteredUser.phone].
final class RegisterSuccess extends RegisterState {
  final RegisteredUser user;

  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class RegisterFailure extends RegisterState {
  final String message;

  @override
  final Map<String, String> fieldErrors;

  const RegisterFailure({required this.message, this.fieldErrors = const {}});

  RegisterFailure withoutFieldError(String field) => RegisterFailure(
        message: message,
        fieldErrors: Map.of(fieldErrors)..remove(field),
      );

  @override
  List<Object?> get props => [message, fieldErrors];
}
