import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String userId;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String accessToken;
  final String? refreshToken;
  final DateTime? tokenExpiry;

  const AuthEntity({
    required this.userId,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.accessToken,
    this.refreshToken,
    this.tokenExpiry,
  });

  bool get isTokenExpired {
    if (tokenExpiry == null) return false;
    return DateTime.now().isAfter(tokenExpiry!);
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        photoUrl,
        accessToken,
        refreshToken,
        tokenExpiry,
      ];
}
