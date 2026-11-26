import 'package:equatable/equatable.dart';

/// Akun yang baru dibuat lewat pendaftaran, belum login.
/// Nomor HP perlu diverifikasi OTP sebelum akun aktif.
class RegisteredUser extends Equatable {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final bool isVerified;
  final DateTime? createdAt;

  const RegisteredUser({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.isVerified,
    this.createdAt,
  });

  @override
  List<Object?> get props => [userId, name, phone, email, isVerified, createdAt];
}
