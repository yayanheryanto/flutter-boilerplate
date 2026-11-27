import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/utils/app_logger.dart';

/// Membuka "amplop" respons sukses backend:
///
/// ```json
/// { "reff_no": "79465b44-…", "response": { …data… } }
/// ```
///
/// menjadi `{ …data… }` sehingga datasource Retrofit & model cukup memetakan
/// isi `response` saja. `reff_no` disimpan di `Response.extra['reff_no']`
/// dan dicatat di log untuk pelacakan ke tim backend.
///
/// Respons yang tidak berbentuk amplop diteruskan apa adanya.
@singleton
class ApiEnvelopeInterceptor extends Interceptor {
  static const String reffNoKey = 'reff_no';
  static const String dataKey = 'response';

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map<String, dynamic> && body.containsKey(dataKey)) {
      final reffNo = body[reffNoKey];
      if (reffNo != null) {
        response.extra[reffNoKey] = reffNo;
        AppLogger.d('${response.requestOptions.path} reff_no=$reffNo', tag: 'HTTP');
      }
      response.data = body[dataKey];
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final body = err.response?.data;
    if (body is Map<String, dynamic> && body[reffNoKey] != null) {
      AppLogger.d('${err.requestOptions.path} error reff_no=${body[reffNoKey]}', tag: 'HTTP');
    }
    handler.next(err);
  }
}
