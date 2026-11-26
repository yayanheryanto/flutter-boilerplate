import 'package:equatable/equatable.dart';

import 'package:emas/features/auth/domain/entities/otp_purpose.dart';

/// Argumen halaman OTP, dikirim lewat `GoRouter` `extra`.
///
/// Diserialisasi ke `Map` (lihat [toExtra]/[OtpPageArgs.fromExtra]) supaya
/// aman dipulihkan oleh extra codec saat state restoration / deep link.
class OtpPageArgs extends Equatable {
  final OtpPurpose purpose;

  /// Nomor HP tujuan OTP. Untuk register, nomor ini dipakai untuk
  /// me-request OTP saat halaman dibuka.
  final String destination;

  /// Diisi bila OTP sudah di-request sebelum halaman dibuka. `null` →
  /// `OtpBloc` me-request OTP sendiri (purpose register).
  final String? verificationId;

  final Duration resendCooldown;

  const OtpPageArgs({
    required this.purpose,
    required this.destination,
    this.verificationId,
    this.resendCooldown = const Duration(seconds: 60),
  });

  factory OtpPageArgs.fromExtra(Object? extra) {
    final map = extra is Map<Object?, Object?> ? extra : const <String, Object?>{};
    return OtpPageArgs(
      purpose: OtpPurpose.fromName(map['purpose'] as String?),
      // 'phone' dipertahankan untuk kompatibilitas pemanggil lama.
      destination: (map['destination'] ?? map['phone'] ?? '') as String,
      verificationId: map['verificationId'] as String?,
      resendCooldown: Duration(seconds: (map['resendCooldown'] as int?) ?? 60),
    );
  }

  Map<String, dynamic> toExtra() => {
        'purpose': purpose.name,
        'destination': destination,
        if (verificationId != null) 'verificationId': verificationId,
        'resendCooldown': resendCooldown.inSeconds,
      };

  @override
  List<Object?> get props => [purpose, destination, verificationId, resendCooldown];
}
