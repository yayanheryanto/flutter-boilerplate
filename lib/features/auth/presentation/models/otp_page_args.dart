import 'package:equatable/equatable.dart';

import 'package:emas/features/auth/domain/entities/otp_challenge.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';

/// Argumen halaman OTP, dikirim lewat `GoRouter` `extra`.
///
/// Diserialisasi ke `Map` (lihat [toExtra]/[OtpPageArgs.fromExtra]) supaya
/// aman dipulihkan oleh extra codec saat state restoration / deep link.
class OtpPageArgs extends Equatable {
  final OtpPurpose purpose;

  /// Tujuan OTP untuk ditampilkan (sudah disamarkan bila dari server).
  final String destination;

  /// `null` untuk alur yang belum punya endpoint (lupa/ganti password).
  final String? verificationId;

  final Duration resendCooldown;

  const OtpPageArgs({
    required this.purpose,
    required this.destination,
    this.verificationId,
    this.resendCooldown = const Duration(seconds: 60),
  });

  factory OtpPageArgs.fromChallenge(OtpPurpose purpose, OtpChallenge challenge) {
    return OtpPageArgs(
      purpose: purpose,
      destination: challenge.maskedDestination,
      verificationId: challenge.verificationId,
      resendCooldown: challenge.resendCooldown,
    );
  }

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
