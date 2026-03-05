import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:boilerplate/features/auth/domain/entities/auth_entity.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
class AuthModel with _$AuthModel {
  const factory AuthModel({
    @JsonKey(name: 'user_id') required String userId,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'token_expiry') DateTime? tokenExpiry,
  }) = _AuthModel;

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
}

extension AuthModelMapper on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiry: tokenExpiry,
    );
  }
}

extension AuthEntityMapper on AuthEntity {
  AuthModel toModel() {
    return AuthModel(
      userId: userId,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenExpiry: tokenExpiry,
    );
  }
}
