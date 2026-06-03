import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/constants/app_constants.dart';
import 'package:emas/core/errors/app_exception.dart';
import 'package:emas/features/auth/data/models/auth_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuth(AuthModel model);
  Future<AuthModel?> getAuth();
  Future<void> clearAuth();
}

@LazySingleton(as: AuthLocalDataSource)
class HiveAuthLocalDataSource implements AuthLocalDataSource {
  Box<dynamic> get _box => Hive.box(AppConstants.authBox);

  @override
  Future<void> saveAuth(AuthModel model) async {
    try {
      await _box.put(AppConstants.userKey, jsonEncode(model.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to save auth: $e');
    }
  }

  @override
  Future<AuthModel?> getAuth() async {
    try {
      final jsonString = _box.get(AppConstants.userKey) as String?;
      if (jsonString == null) return null;
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthModel.fromJson(json);
    } catch (e) {
      throw CacheException(message: 'Failed to get auth: $e');
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      await _box.delete(AppConstants.userKey);
      await _box.delete(AppConstants.tokenKey);
      await _box.delete(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth: $e');
    }
  }
}
