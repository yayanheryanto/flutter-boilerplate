/// Body `POST AuthEndpoints.verifyOtp`.
class VerifyOtpRequestModel {
  final String verificationId;
  final String code;

  const VerifyOtpRequestModel({required this.verificationId, required this.code});

  Map<String, dynamic> toJson() => {
        'verification_id': verificationId,
        'code': code,
      };
}

/// Body `POST AuthEndpoints.resendOtp`.
class ResendOtpRequestModel {
  final String verificationId;

  const ResendOtpRequestModel({required this.verificationId});

  Map<String, dynamic> toJson() => {'verification_id': verificationId};
}
