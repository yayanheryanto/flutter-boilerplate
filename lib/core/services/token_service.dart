import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/constants/constants.dart';

abstract class TokenService {
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> clearTokens();
}

@LazySingleton(as: TokenService)
class HiveTokenService implements TokenService {
  Box<dynamic> get _box => Hive.box(Constants.authBox);

  @override
  Future<String?> getToken() async {
    return _box.get(Constants.tokenKey) as String?;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _box.get(Constants.refreshTokenKey) as String?;
  }

  @override
  Future<void> saveToken(String token) async {
    await _box.put(Constants.tokenKey, token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _box.put(Constants.refreshTokenKey, token);
  }

  @override
  Future<void> clearTokens() async {
    await _box.delete(Constants.tokenKey);
    await _box.delete(Constants.refreshTokenKey);
  }
}
