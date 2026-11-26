import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:emas/features/auth/data/datasources/auth_endpoints.dart';
import 'package:emas/features/auth/data/models/auth_model.dart';
import 'package:emas/features/auth/data/models/otp_challenge_model.dart';
import 'package:emas/features/auth/data/models/otp_request_model.dart';
import 'package:emas/features/auth/data/models/register_request_model.dart';

part 'auth_remote_datasource.g.dart';

/// Kontrak HTTP auth. Selama `AppConfig.useMock` aktif, request yang punya
/// handler di `auth_mock_api.dart` dijawab oleh `MockInterceptor`.
@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  @POST(AuthEndpoints.login)
  Future<AuthModel> login(@Body() Map<String, dynamic> body);

  /// Mendaftarkan akun dan mengirim OTP ke nomor HP.
  @POST(AuthEndpoints.register)
  Future<OtpChallengeModel> register(@Body() RegisterRequestModel body);

  /// Memverifikasi OTP; bila benar server mengembalikan token (login).
  @POST(AuthEndpoints.verifyOtp)
  Future<AuthModel> verifyOtp(@Body() VerifyOtpRequestModel body);

  @POST(AuthEndpoints.resendOtp)
  Future<OtpChallengeModel> resendOtp(@Body() ResendOtpRequestModel body);

  @POST(AuthEndpoints.logout)
  Future<void> logout();

  @POST(AuthEndpoints.refresh)
  Future<AuthModel> refreshToken(@Body() Map<String, dynamic> body);

  @POST(AuthEndpoints.forgotPassword)
  Future<void> forgotPassword(@Body() Map<String, dynamic> body);
}
