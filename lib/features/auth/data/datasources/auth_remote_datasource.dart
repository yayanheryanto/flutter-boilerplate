import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:emas/features/auth/data/models/auth_model.dart';

part 'auth_remote_datasource.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/auth/login')
  Future<AuthModel> login(@Body() Map<String, dynamic> body);

  @POST('/auth/register')
  Future<AuthModel> register(@Body() Map<String, dynamic> body);

  @POST('/auth/logout')
  Future<void> logout();

  @POST('/auth/refresh')
  Future<AuthModel> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  @POST('/auth/forgot-password')
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);
}
