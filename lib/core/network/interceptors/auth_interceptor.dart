import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/services/token_service.dart';

@singleton
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService;

  AuthInterceptor(this._tokenService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _tokenService.getRefreshToken();
        if (refreshToken != null) {
          // Attempt token refresh
          final dio = Dio();
          final response = await dio.post<Map<String, dynamic>>(
            '${err.requestOptions.baseUrl}/auth/refresh',
            data: {'refresh_token': refreshToken},
          );

          final newToken = response.data?['access_token'] as String;
          await _tokenService.saveToken(newToken);

          // Retry original request with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await dio.fetch<Map<String, dynamic>>(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (_) {
        await _tokenService.clearTokens();
      }
    }
    handler.next(err);
  }
}
