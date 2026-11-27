part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

final class LoginSubmitted extends LoginEvent {
  final String phone;
  final String password;

  const LoginSubmitted({required this.phone, required this.password});

  // Password tidak dimasukkan ke props agar tidak tercetak di log.
  @override
  List<Object?> get props => [phone];
}

/// User mengubah field — hapus error server untuk field itu (`phone`/`password`).
final class LoginFieldEdited extends LoginEvent {
  final String field;

  const LoginFieldEdited(this.field);

  @override
  List<Object?> get props => [field];
}
