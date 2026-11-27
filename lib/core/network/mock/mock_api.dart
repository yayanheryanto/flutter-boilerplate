import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';

/// Respons palsu yang dikembalikan sebuah [MockRoute].
///
/// [data] cukup berisi **isi** respons. `MockInterceptor` membungkusnya ke
/// format backend:
/// - 2xx → `{ "reff_no": "<uuid>", "response": <data> }`
/// - error → `<data>` + `"reff_no"` (`{ "reff_no", "message", "code", "errors" }`)
///
/// Status 2xx diteruskan sebagai respons sukses; selain itu diubah menjadi
/// `DioException.badResponse` sehingga alurnya sama persis dengan error
/// dari backend sungguhan (lewat `ErrorMapper` → `AppFailure`).
class MockResponse {
  final int statusCode;
  final Object? data;

  /// Latensi khusus untuk route ini. `null` = pakai default registry.
  final Duration? delay;

  const MockResponse(this.statusCode, {this.data, this.delay});

  const MockResponse.ok(Object? data, {Duration? delay}) : this(200, data: data, delay: delay);

  const MockResponse.created(Object? data, {Duration? delay}) : this(201, data: data, delay: delay);

  /// Error dengan bentuk body standar
  /// `{ "message": ..., "code": ..., "errors": {...} }` — bentuk yang dibaca
  /// `ErrorMapper`. [code] adalah kode error yang bisa dibaca mesin
  /// (mis. `OTP_EXPIRED`) untuk membedakan sebab dengan status HTTP yang sama.
  MockResponse.error(
    int statusCode,
    String message, {
    String? code,
    Map<String, List<String>>? errors,
    Duration? delay,
  }) : this(
          statusCode,
          data: <String, dynamic>{
            'message': message,
            if (code != null) 'code': code,
            if (errors != null) 'errors': errors,
          },
          delay: delay,
        );

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  /// Body akhir yang dikirim ke aplikasi, sesuai format backend.
  Object? envelope(String reffNo) {
    if (isSuccess) return <String, dynamic>{'reff_no': reffNo, 'response': data};
    final body = data;
    if (body is Map<String, dynamic>) return <String, dynamic>{'reff_no': reffNo, ...body};
    return body;
  }
}

/// `reff_no` palsu berformat UUID v4, mis. `79465b44-3f8e-4b9c-b43b-1626cea61ee6`.
String generateMockReffNo() {
  final random = Random();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // versi 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // varian RFC 4122
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

typedef MockResolver = FutureOr<MockResponse> Function(MockRequest request);

/// Informasi request yang diterima handler mock.
class MockRequest {
  final RequestOptions options;

  /// Nilai path param, mis. `/orders/:id` → `{'id': '42'}`.
  final Map<String, String> pathParams;

  const MockRequest(this.options, this.pathParams);

  /// Body JSON sebagai Map (kosong bila body bukan Map).
  Map<String, dynamic> get body {
    final data = options.data;
    return data is Map<String, dynamic> ? data : <String, dynamic>{};
  }

  Map<String, dynamic> get query => options.queryParameters;

  String? header(String name) => options.headers[name]?.toString();
}

/// Satu endpoint palsu: method + path → resolver.
///
/// Path param boleh ditulis `{id}` (format Retrofit, jadi konstanta endpoint
/// yang sama bisa dipakai) atau `:id`.
class MockRoute {
  final String method;
  final String path;
  final MockResolver resolve;

  late final RegExp _pattern = RegExp(
    '^${path.split('/').map(_segmentPattern).join('/')}\$',
  );

  static String _segmentPattern(String segment) {
    final name = segment.startsWith(':')
        ? segment.substring(1)
        : segment.startsWith('{') && segment.endsWith('}')
            ? segment.substring(1, segment.length - 1)
            : null;
    return name == null ? RegExp.escape(segment) : '(?<$name>[^/]+)';
  }

  MockRoute(this.method, this.path, this.resolve);

  MockRoute.get(String path, MockResolver resolve) : this('GET', path, resolve);

  MockRoute.post(String path, MockResolver resolve) : this('POST', path, resolve);

  MockRoute.put(String path, MockResolver resolve) : this('PUT', path, resolve);

  MockRoute.patch(String path, MockResolver resolve) : this('PATCH', path, resolve);

  MockRoute.delete(String path, MockResolver resolve) : this('DELETE', path, resolve);

  /// Mengembalikan path params bila cocok, atau `null`.
  Map<String, String>? match(RequestOptions options) {
    if (options.method.toUpperCase() != method) return null;
    final m = _pattern.firstMatch(Uri.parse(options.path).path);
    if (m == null) return null;
    return {for (final name in m.groupNames) name: m.namedGroup(name)!};
  }
}

/// Kumpulan [MockRoute] dari semua fitur. Dibentuk di lapisan `app/`
/// (lihat `lib/app/di/mock_module.dart`) agar `core/` tidak mengenal fitur.
class MockRegistry {
  final List<MockRoute> routes;

  /// Latensi default untuk mensimulasikan jaringan.
  final Duration defaultDelay;

  const MockRegistry(
    this.routes, {
    this.defaultDelay = const Duration(milliseconds: 800),
  });
}
