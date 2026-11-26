part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  Map<String, String> get fieldErrors => const {};

  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Mengecek sesi tersimpan saat halaman dibuka.
final class LoginCheckingSession extends LoginState {
  const LoginCheckingSession();
}

final class LoginInProgress extends LoginState {
  const LoginInProgress();
}

final class LoginSuccess extends LoginState {
  final AuthEntity auth;

  /// `true` bila berasal dari sesi tersimpan (bukan submit form).
  final bool restored;

  const LoginSuccess(this.auth, {this.restored = false});

  @override
  List<Object?> get props => [auth, restored];
}

/// Kredensial benar tapi nomor HP belum diverifikasi OTP (403).
final class LoginNeedsVerification extends LoginState {
  final String phone;
  final String message;

  const LoginNeedsVerification({required this.phone, required this.message});

  @override
  List<Object?> get props => [phone, message];
}

final class LoginFailure extends LoginState {
  final String message;

  @override
  final Map<String, String> fieldErrors;

  const LoginFailure({required this.message, this.fieldErrors = const {}});

  LoginFailure withoutFieldError(String field) =>
      LoginFailure(message: message, fieldErrors: Map.of(fieldErrors)..remove(field));

  @override
  List<Object?> get props => [message, fieldErrors];
}
