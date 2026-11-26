import 'package:equatable/equatable.dart';

/// OTP yang sudah dikirim server dan menunggu diverifikasi.
class OtpChallenge extends Equatable {
  /// ID sesi verifikasi — dikirim balik saat verify/resend.
  final String verificationId;

  /// Tujuan OTP yang sudah disamarkan server, mis. `08********89`.
  final String maskedDestination;

  final Duration expiresIn;

  /// Jeda minimum sebelum boleh minta kirim ulang.
  final Duration resendCooldown;

  const OtpChallenge({
    required this.verificationId,
    required this.maskedDestination,
    required this.expiresIn,
    required this.resendCooldown,
  });

  @override
  List<Object?> get props => [verificationId, maskedDestination, expiresIn, resendCooldown];
}
