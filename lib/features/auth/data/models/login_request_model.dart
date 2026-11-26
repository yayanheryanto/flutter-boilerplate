/// Body `POST AuthEndpoints.login`.
class LoginRequestModel {
  final String phone;
  final String password;

  const LoginRequestModel({required this.phone, required this.password});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'password': password,
      };
}
