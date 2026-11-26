part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

/// User menekan tombol "Daftar" dengan form yang sudah lolos validasi lokal.
final class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String phone;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  // Password sengaja tidak dimasukkan ke props agar tidak ikut tercetak
  // oleh AppBlocObserver / log.
  @override
  List<Object?> get props => [name, phone, email];
}

/// User mengubah isi field — dipakai untuk menghapus error dari server.
final class RegisterFieldEdited extends RegisterEvent {
  /// Nama field sesuai key error backend: `name`, `phone`, `email`, `password`.
  final String field;

  const RegisterFieldEdited(this.field);

  @override
  List<Object?> get props => [field];
}
