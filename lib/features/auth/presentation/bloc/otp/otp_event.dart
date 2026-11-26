part of 'otp_bloc.dart';

sealed class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object?> get props => [];
}

/// Halaman OTP dibuka. Dispatch sekali saat bloc dibuat.
final class OtpStarted extends OtpEvent {
  final OtpPageArgs args;

  const OtpStarted(this.args);

  @override
  List<Object?> get props => [args];
}

/// Semua digit OTP sudah terisi.
final class OtpCodeSubmitted extends OtpEvent {
  final String code;

  const OtpCodeSubmitted(this.code);

  @override
  List<Object?> get props => [code];
}

final class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}

/// Internal: satu detik cooldown kirim ulang berlalu.
final class _OtpCooldownTicked extends OtpEvent {
  const _OtpCooldownTicked();
}
