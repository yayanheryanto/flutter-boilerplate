import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  AppNavigator._();

  // ── Navigator Key ──────────────────────────────────────────────────────────

  /// Key tunggal yang dipakai oleh GoRouter, AppToast, AppPopover,
  /// AppProgressOverlay, dan semua overlay lainnya.
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  // ── Internal GoRouter accessor ─────────────────────────────────────────────

  /// Mendapatkan GoRouter dari context aktif.
  /// Mengembalikan null jika navigator belum siap.
  static GoRouter? get _router {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return null;
    return GoRouter.of(ctx);
  }

  // ── Context & State ────────────────────────────────────────────────────────

  /// BuildContext aktif dari navigator. Gunakan untuk show dialog, snackbar, dll.
  static BuildContext? get currentContext => navigatorKey.currentContext;

  /// Apakah navigator bisa pop (ada route di stack).
  static bool get canPop => navigatorKey.currentState?.canPop() ?? false;

  /// Location path saat ini, e.g. '/dashboard'.
  static String get currentLocation {
    final router = _router;
    if (router == null) return '/';
    return router.routeInformationProvider.value.uri.path;
  }

  // ── Go (replace current stack) ─────────────────────────────────────────────

  /// Navigate ke [path] dan hapus semua route sebelumnya dari stack.
  /// Gunakan untuk navigasi setelah login/logout.
  ///
  /// ```dart
  /// AppNavigator.go(AppRoutes.dashboard);
  /// ```
  static void go(String path, {Object? extra}) {
    _router?.go(path, extra: extra);
  }

  /// Navigate ke named route dan hapus semua route sebelumnya.
  ///
  /// ```dart
  /// AppNavigator.goNamed('dashboard');
  /// ```
  static void goNamed(
      String name, {
        Map<String, String> pathParameters = const {},
        Map<String, dynamic> queryParameters = const {},
        Object? extra,
      }) {
    _router?.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  // ── Push (tambah ke stack) ─────────────────────────────────────────────────

  /// Push [path] ke atas stack navigasi.
  ///
  /// ```dart
  /// final result = await AppNavigator.push<bool>(AppRoutes.confirmDelete);
  /// ```
  static Future<T?> push<T>(String path, {Object? extra}) async {
    final router = _router;
    if (router == null) return null;
    return router.push<T>(path, extra: extra);
  }

  /// Push named route ke atas stack navigasi.
  ///
  /// ```dart
  /// await AppNavigator.pushNamed('profile', extra: userId);
  /// ```
  static Future<T?> pushNamed<T>(
      String name, {
        Map<String, String> pathParameters = const {},
        Map<String, dynamic> queryParameters = const {},
        Object? extra,
      }) async {
    final router = _router;
    if (router == null) return null;
    return router.pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  // ── Push Replacement (ganti route teratas) ─────────────────────────────────

  /// Ganti route teratas dengan [path].
  ///
  /// ```dart
  /// AppNavigator.pushReplacement(AppRoutes.login);
  /// ```
  static Future<T?> pushReplacement<T>(String path, {Object? extra}) async {
    final router = _router;
    if (router == null) return null;
    return router.pushReplacement<T>(path, extra: extra);
  }

  /// Ganti route teratas dengan named route.
  static Future<T?> pushReplacementNamed<T>(
      String name, {
        Map<String, String> pathParameters = const {},
        Map<String, dynamic> queryParameters = const {},
        Object? extra,
      }) async {
    final router = _router;
    if (router == null) return null;
    return router.pushReplacementNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  // ── Pop ────────────────────────────────────────────────────────────────────

  /// Kembali ke route sebelumnya dengan optional [result].
  ///
  /// ```dart
  /// AppNavigator.pop();
  /// AppNavigator.pop<bool>(true); // kembalikan result ke caller
  /// ```
  static void pop<T>([T? result]) {
    if (canPop) {
      _router?.pop(result);
    }
  }

  /// Pop semua route hingga root (route pertama di stack).
  ///
  /// ```dart
  /// AppNavigator.popUntilFirst();
  /// ```
  static void popUntilFirst() {
    final state = navigatorKey.currentState;
    if (state == null) return;
    state.popUntil((route) => route.isFirst);
  }

  // ── Refresh ────────────────────────────────────────────────────────────────

  /// Paksa GoRouter untuk re-evaluate redirect guards.
  /// Berguna setelah login/logout agar guard bisa mengarahkan ulang.
  ///
  /// ```dart
  /// // Setelah login berhasil di BLoC/Cubit:
  /// AppNavigator.refresh();
  /// ```
  static void refresh() {
    _router?.refresh();
  }
}
