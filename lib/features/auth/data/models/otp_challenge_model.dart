import 'package:emas/features/auth/domain/entities/otp_challenge.dart';

/// Respons `register` dan `resendOtp`: OTP sudah dikirim dan menunggu
/// diverifikasi.
///
/// ```json
/// {
///   "verification_id": "reg_1717000000000",
///   "destination": "08********89",
///   "expires_in": 300,
///   "resend_in": 60
/// }
/// ```
class OtpChallengeModel {
  final String verificationId;
  final String destination;
  final int expiresIn;
  final int resendIn;

  const OtpChallengeModel({
    required this.verificationId,
    required this.destination,
    required this.expiresIn,
    required this.resendIn,
  });

  factory OtpChallengeModel.fromJson(Map<String, dynamic> json) {
    return OtpChallengeModel(
      verificationId: json['verification_id'] as String,
      destination: json['destination'] as String? ?? '',
      expiresIn: (json['expires_in'] as num?)?.toInt() ?? 300,
      resendIn: (json['resend_in'] as num?)?.toInt() ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
        'verification_id': verificationId,
        'destination': destination,
        'expires_in': expiresIn,
        'resend_in': resendIn,
      };

  OtpChallenge toEntity() => OtpChallenge(
        verificationId: verificationId,
        maskedDestination: destination,
        expiresIn: Duration(seconds: expiresIn),
        resendCooldown: Duration(seconds: resendIn),
      );
}
