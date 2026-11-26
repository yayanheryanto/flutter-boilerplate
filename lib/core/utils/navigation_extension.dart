import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';

/// Navigasi "kembali" yang aman.
///
/// `context.pop()` melempar `GoError: There is nothing to pop` bila halaman
/// dibuka lewat `context.go()` (stack hanya berisi halaman itu) atau bila
/// dipanggil dari halaman root seperti tab dashboard. Pakai [popOrGo] untuk
/// semua tombol back.
extension SafeNavigation on BuildContext {
  /// Kembali ke halaman sebelumnya; bila tidak ada, pindah ke [fallback].
  void popOrGo([String fallback = AppRoutes.dashboard]) {
    if (canPop()) {
      pop();
    } else {
      go(fallback);
    }
  }
}
