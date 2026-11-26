/// Body `POST AuthEndpoints.register`.
///
/// JSON ditulis manual (bukan json_serializable) supaya kontraknya mudah
/// dibaca dan disesuaikan saat backend final tersedia.
class RegisterRequestModel {
  final String name;
  final String phone;
  final String email;
  final String password;

  const RegisterRequestModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      };
}
