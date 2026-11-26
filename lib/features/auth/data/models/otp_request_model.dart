/// Body `POST AuthEndpoints.requestOtp` — minta OTP dikirim ke [phone].
class RequestOtpRequestModel {
  final String phone;

  /// `register` | `forgot_password` | `change_password`.
  final String purpose;

  const RequestOtpRequestModel({required this.phone, required this.purpose});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'purpose': purpose,
      };
}

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
