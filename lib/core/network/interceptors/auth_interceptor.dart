import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/network/interceptors/logging_interceptor.dart';
import 'package:emas/core/network/interceptors/mock_interceptor.dart';
import 'package:emas/core/services/token_service.dart';

/// Menambahkan bearer token dan me-refresh token saat 401.
///
/// Memakai [QueuedInterceptor] supaya beberapa request yang gagal 401
/// bersamaan tidak memicu refresh berkali-kali: request berikutnya menunggu,
/// lalu cukup diulang dengan token yang sudah baru.
@singleton
class AuthInterceptor extends QueuedInterceptor {
  static const _retriedKey = 'auth_retried';
  static const _refreshPath = '/auth/refresh';

  final TokenService _tokenService;

  /// Dio untuk mengulang request setelah refresh. Memakai `BaseOptions`
  /// yang sama dengan Dio utama (baseUrl, timeout, header), tapi **tanpa**
  /// interceptor ini: request ulang yang di-`fetch` dari dalam antrean
  /// [QueuedInterceptor] lalu gagal lagi akan menunggu antrean yang sama
  /// dan menyebabkan deadlock.
  Dio? _retryDio;

  AuthInterceptor(this._tokenService);

  /// Dipanggil oleh `DioClient` setelah Dio utama dibuat.
  void attach(Dio dio) {
    // Hanya logging & mock yang ikut; Dio baru sudah memasang interceptor
    // bawaannya sendiri, dan Auth/Retry sengaja tidak disertakan.
    _retryDio = Dio(dio.options)
      ..interceptors.addAll(
        dio.interceptors.where((i) => i is LoggingInterceptor || i is MockInterceptor),
      );
  }

  @override
  Future<void> onRequest(
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
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final dio = _retryDio;

    final shouldHandle = err.response?.statusCode == 401 &&
        options.extra[_retriedKey] != true &&
        !options.path.endsWith(_refreshPath) &&
        dio != null;

    if (!shouldHandle) {
      handler.next(err);
      return;
    }

    try {
      final sentToken = _bearerOf(options);
      var currentToken = await _tokenService.getToken();

      // Token sudah diperbarui oleh request lain di antrean → cukup ulangi.
      if (currentToken == null || currentToken.isEmpty || currentToken == sentToken) {
        currentToken = await _refreshToken(options.baseUrl);
      }

      if (currentToken == null) {
        await _tokenService.clearTokens();
        handler.next(err);
        return;
      }

      options.extra[_retriedKey] = true;
      options.headers['Authorization'] = 'Bearer $currentToken';
      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    } catch (_) {
      await _tokenService.clearTokens();
      handler.next(err);
    }
  }

  /// Mengembalikan access token baru, atau `null` bila refresh tidak mungkin.
  Future<String?> _refreshToken(String baseUrl) async {
    final refreshToken = await _tokenService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    // Dio terpisah tanpa interceptor agar tidak terjadi loop refresh.
    final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
    final response = await refreshDio.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refresh_token': refreshToken},
    );

    final newToken = response.data?['access_token'] as String?;
    if (newToken == null || newToken.isEmpty) return null;

    await _tokenService.saveToken(newToken);
    final newRefreshToken = response.data?['refresh_token'] as String?;
    if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
      await _tokenService.saveRefreshToken(newRefreshToken);
    }
    return newToken;
  }

  String? _bearerOf(RequestOptions options) {
    final header = options.headers['Authorization'];
    if (header is! String || !header.startsWith('Bearer ')) return null;
    return header.substring('Bearer '.length);
  }
}
