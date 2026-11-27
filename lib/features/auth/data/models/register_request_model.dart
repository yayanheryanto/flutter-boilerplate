/// Body `POST AuthEndpoints.register` — seluruh isi form pendaftaran.
///
/// JSON ditulis manual (bukan json_serializable) supaya kontraknya mudah
/// dibaca dan disesuaikan saat backend final tersedia.
class RegisterRequestModel {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool termsAccepted;

  /// ID instalasi aplikasi (lihat `DeviceIdService`).
  final String deviceId;

  const RegisterRequestModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.termsAccepted,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'terms_accepted': termsAccepted,
        'device_id': deviceId,
      };
}
