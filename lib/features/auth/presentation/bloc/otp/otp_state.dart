part of 'otp_bloc.dart';

enum OtpStatus {
  idle,
  verifying,

  /// OTP benar. Untuk purpose register, [OtpState.auth] berisi sesi login.
  verified,

  /// Verifikasi / kirim ulang gagal — pesan di [OtpState.message].
  failure,

  /// OTP baru berhasil dikirim — pesan info di [OtpState.message].
  codeResent,
}

/// State tunggal + `copyWith` karena halaman OTP menampilkan beberapa hal
/// sekaligus (countdown, jumlah kirim ulang, status verifikasi).
final class OtpState extends Equatable {
  final OtpPurpose purpose;
  final String destination;
  final String? verificationId;
  final OtpStatus status;
  final int resendCountdown;
  final int resendCount;
  final bool isResending;
  final String? message;
  final AuthEntity? auth;

  const OtpState({
    required this.purpose,
    required this.destination,
    required this.verificationId,
    required this.status,
    required this.resendCountdown,
    required this.resendCount,
    required this.isResending,
    required this.message,
    required this.auth,
  });

  factory OtpState.initial() => const OtpState(
        purpose: OtpPurpose.register,
        destination: '',
        verificationId: null,
        status: OtpStatus.idle,
        resendCountdown: 0,
        resendCount: 0,
        isResending: false,
        message: null,
        auth: null,
      );

  bool get isVerifying => status == OtpStatus.verifying;

  bool get resendExhausted => resendCount >= OtpBloc.maxResend;

  bool get canResend => resendCountdown == 0 && !resendExhausted && !isResending && !isVerifying;

  OtpState copyWith({
    OtpPurpose? purpose,
    String? destination,
    String? verificationId,
    OtpStatus? status,
    int? resendCountdown,
    int? resendCount,
    bool? isResending,
    String? message,
    bool clearMessage = false,
    AuthEntity? auth,
  }) {
    return OtpState(
      purpose: purpose ?? this.purpose,
      destination: destination ?? this.destination,
      verificationId: verificationId ?? this.verificationId,
      status: status ?? this.status,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      resendCount: resendCount ?? this.resendCount,
      isResending: isResending ?? this.isResending,
      message: clearMessage ? null : (message ?? this.message),
      auth: auth ?? this.auth,
    );
  }

  @override
  List<Object?> get props => [
        purpose,
        destination,
        verificationId,
        status,
        resendCountdown,
        resendCount,
        isResending,
        message,
        auth,
      ];
}
