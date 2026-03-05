import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/constants/app_constants.dart';

abstract class TokenService {
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> clearTokens();
}

@LazySingleton(as: TokenService)
class HiveTokenService implements TokenService {
  Box<dynamic> get _box => Hive.box(AppConstants.authBox);

  @override
  Future<String?> getToken() async {
    return _box.get(AppConstants.tokenKey) as String?;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _box.get(AppConstants.refreshTokenKey) as String?;
  }

  @override
  Future<void> saveToken(String token) async {
    await _box.put(AppConstants.tokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _box.put(AppConstants.refreshTokenKey, token);
  }

  @override
  Future<void> clearTokens() async {
    await _box.delete(AppConstants.tokenKey);
    await _box.delete(AppConstants.refreshTokenKey);
  }
}
