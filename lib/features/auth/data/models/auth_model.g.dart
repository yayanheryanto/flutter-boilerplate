// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthModelImpl _$$AuthModelImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$AuthModelImpl',
      json,
      ($checkedConvert) {
        final val = _$AuthModelImpl(
          userId: $checkedConvert('user_id', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String),
          displayName: $checkedConvert('display_name', (v) => v as String?),
          photoUrl: $checkedConvert('photo_url', (v) => v as String?),
          accessToken: $checkedConvert('access_token', (v) => v as String),
          refreshToken: $checkedConvert('refresh_token', (v) => v as String?),
          tokenExpiry: $checkedConvert('token_expiry',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'displayName': 'display_name',
        'photoUrl': 'photo_url',
        'accessToken': 'access_token',
        'refreshToken': 'refresh_token',
        'tokenExpiry': 'token_expiry'
      },
    );

Map<String, dynamic> _$$AuthModelImplToJson(_$AuthModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'display_name': instance.displayName,
      'photo_url': instance.photoUrl,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_expiry': instance.tokenExpiry?.toIso8601String(),
    };
