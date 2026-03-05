import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class RetryInterceptor extends Interceptor {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retryCount = options.extra['retryCount'] as int? ?? 0;

    final shouldRetry = err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.receiveTimeout;

    if (shouldRetry && retryCount < _maxRetries) {
      options.extra['retryCount'] = retryCount + 1;
      await Future<void>.delayed(_retryDelay * (retryCount + 1));

      try {
        final dio = Dio();
        final response = await dio.fetch<Map<String, dynamic>>(options);
        handler.resolve(response);
        return;
      } catch (e) {
        // continue to next error handler
      }
    }

    handler.next(err);
  }
}
