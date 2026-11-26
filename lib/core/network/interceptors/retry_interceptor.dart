import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Mengulang request yang gagal karena koneksi/timeout dengan backoff linear.
@singleton
class RetryInterceptor extends Interceptor {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);
  static const String _retryCountKey = 'retryCount';

  /// Dio utama (diset oleh `DioClient`) — request yang diulang tetap
  /// melewati semua interceptor & konfigurasi timeout yang sama.
  Dio? _dio;

  void attach(Dio dio) => _dio = dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retryCount = options.extra[_retryCountKey] as int? ?? 0;
    final dio = _dio;

    final shouldRetry = dio != null &&
        retryCount < _maxRetries &&
        (err.type == DioExceptionType.connectionError ||
            err.type == DioExceptionType.connectionTimeout ||
            err.type == DioExceptionType.receiveTimeout);

    if (!shouldRetry) {
      handler.next(err);
      return;
    }

    options.extra[_retryCountKey] = retryCount + 1;
    await Future<void>.delayed(_retryDelay * (retryCount + 1));

    try {
      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
