/// Body `POST AuthEndpoints.login`.
class LoginRequestModel {
  final String phone;
  final String password;

  /// ID instalasi aplikasi (lihat `DeviceIdService`).
  final String deviceId;

  const LoginRequestModel({
    required this.phone,
    required this.password,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
        'device_id': deviceId,
      };
}
