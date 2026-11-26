import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/firebase/firebase_services.dart';
import 'package:emas/features/auth/domain/usecases/auth/logout_usecase.dart';

enum LogoutStatus { idle, inProgress, success }

/// Keluar dari akun.
///
/// Cubit (bukan Bloc) karena hanya satu aksi tanpa event lain. Memakai
/// `LogoutUseCase` dari domain auth — fitur profil tidak bergantung pada
/// presentation layer fitur auth.
@injectable
class LogoutCubit extends Cubit<LogoutStatus> {
  final LogoutUseCase _logout;
  final AnalyticsService _analytics;
  final CrashlyticsService _crashlytics;

  LogoutCubit(this._logout, this._analytics, this._crashlytics) : super(LogoutStatus.idle);

  Future<void> logout() async {
    if (state == LogoutStatus.inProgress) return;
    emit(LogoutStatus.inProgress);

    final result = await _logout();

    // Sesi lokal selalu dihapus oleh repository, jadi kegagalan request ke
    // server (mis. offline) tidak boleh menahan user tetap "login".
    result.fold(
      (failure) => unawaited(_crashlytics.log('Logout remote failed: ${failure.message}')),
      (_) {},
    );
    unawaited(_analytics.setUserId(null));

    if (!isClosed) emit(LogoutStatus.success);
  }
}
