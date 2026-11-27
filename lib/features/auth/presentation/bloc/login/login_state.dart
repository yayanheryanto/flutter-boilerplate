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

final class LoginInProgress extends LoginState {
  const LoginInProgress();
}

final class LoginSuccess extends LoginState {
  final AuthEntity auth;

  const LoginSuccess(this.auth);

  @override
  List<Object?> get props => [auth];
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
