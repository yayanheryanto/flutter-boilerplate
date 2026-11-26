import 'dart:async';

import 'package:dio/dio.dart';

/// Respons palsu yang dikembalikan sebuah [MockRoute].
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

  /// Error dengan bentuk body standar `{ "message": ..., "errors": {...} }`
  /// — bentuk yang dibaca `ErrorMapper`.
  MockResponse.error(
    int statusCode,
    String message, {
    Map<String, List<String>>? errors,
    Duration? delay,
  }) : this(
          statusCode,
          data: <String, dynamic>{
            'message': message,
            if (errors != null) 'errors': errors,
          },
          delay: delay,
        );

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
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

/// Satu endpoint palsu: method + path (boleh berisi `:param`) → resolver.
class MockRoute {
  final String method;
  final String path;
  final MockResolver resolve;

  late final RegExp _pattern = RegExp(
    '^${path.split('/').map((s) => s.startsWith(':') ? '(?<${s.substring(1)}>[^/]+)' : RegExp.escape(s)).join('/')}\$',
  );

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
