import 'package:emas/features/auth/domain/entities/registered_user.dart';

/// Isi `response` dari `POST AuthEndpoints.register` (amplop `{reff_no, response}`
/// sudah dibuka `ApiEnvelopeInterceptor`).
///
/// ```json
/// {
///   "user_id": "usr_1717000000000",
///   "name": "Dinar Daniswara",
///   "phone": "081234567889",
///   "email": "dinar@gmail.com",
///   "status": "pending_verification",
///   "created_at": "2026-11-26T14:00:00.000"
/// }
/// ```
class RegisterResponseModel {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String status;
  final DateTime? createdAt;

  const RegisterResponseModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    this.createdAt,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      userId: json['user_id'] as String,
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? 'pending_verification',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'phone': phone,
        'email': email,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
      };

  RegisteredUser toEntity() => RegisteredUser(
        userId: userId,
        name: name,
        phone: phone,
        email: email,
        isVerified: status == 'active',
        createdAt: createdAt,
      );
}
