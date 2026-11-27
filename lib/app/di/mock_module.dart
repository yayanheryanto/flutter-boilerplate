import 'package:injectable/injectable.dart';

import 'package:emas/core/network/mock/mock_api.dart';
import 'package:emas/features/auth/data/mock/auth_mock_api.dart';
import 'package:emas/features/promo/data/mock/promo_mock_api.dart';

/// Mendaftarkan seluruh backend palsu per fitur ke `MockInterceptor`.
///
/// Fitur baru: buat `features/<fitur>/data/mock/<fitur>_mock_api.dart`
/// lalu tambahkan `...XxxMockApi().routes` di bawah.
/// Saat endpoint sungguhan siap, hapus route-nya dari sini (atau matikan
/// semua mock dengan `--dart-define=USE_MOCK=false`).
@module
abstract class MockModule {
  @singleton
  MockRegistry get mockRegistry => MockRegistry([
        ...AuthMockApi().routes,
        ...PromoMockApi().routes,
      ]);
}
