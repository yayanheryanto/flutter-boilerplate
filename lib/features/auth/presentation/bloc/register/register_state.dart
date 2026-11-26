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

/// Akun terdaftar dan OTP sudah dikirim — lanjut ke halaman OTP.
final class RegisterSuccess extends RegisterState {
  final OtpChallenge challenge;

  const RegisterSuccess(this.challenge);

  @override
  List<Object?> get props => [challenge];
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
