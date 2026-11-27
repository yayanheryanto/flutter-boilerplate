import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/network/mock/mock_api.dart';
import 'package:emas/core/utils/app_logger.dart';

/// Menjawab request dengan data palsu selama backend belum tersedia.
///
/// Aktif hanya bila `AppConfig.useMock == true`. Request yang tidak punya
/// [MockRoute] tetap diteruskan ke jaringan seperti biasa, jadi endpoint
/// bisa dipindah ke backend asli satu per satu.
///
/// Dipasang sebagai interceptor **terakhir** agar auth header & logging
/// tetap berjalan, dan respons/error mock melewati interceptor lain
/// persis seperti respons dari server.
@singleton
class MockInterceptor extends Interceptor {
  final MockRegistry _registry;

  MockInterceptor(this._registry);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!AppConfig.useMock) {
      handler.next(options);
      return;
    }

    for (final route in _registry.routes) {
      final params = route.match(options);
      if (params == null) continue;

      final mock = await route.resolve(MockRequest(options, params));
      await Future<void>.delayed(mock.delay ?? _registry.defaultDelay);

      AppLogger.d('[MOCK] ${options.method} ${options.path} → ${mock.statusCode}', tag: 'HTTP');

      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: mock.statusCode,
        data: mock.envelope(generateMockReffNo()),
      );

      if (mock.isSuccess) {
        handler.resolve(response, true);
      } else {
        handler.reject(
          DioException.badResponse(
            statusCode: mock.statusCode,
            requestOptions: options,
            response: response,
          ),
          true,
        );
      }
      return;
    }

    handler.next(options);
  }
}
