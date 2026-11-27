import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/firebase/firebase_services.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/usecases/auth/login_usecase.dart';
import 'package:emas/features/auth/domain/usecases/auth/register_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Submit form login.
///
/// Auto-login (sesi tersimpan) ditangani `redirect` di `AppRouter`, sehingga
/// halaman login tidak pernah dibangun bila user sudah login.
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final AnalyticsService _analytics;
  final CrashlyticsService _crashlytics;

  LoginBloc(
    this._loginUseCase,
    this._analytics,
    this._crashlytics,
  ) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onSubmitted);
    on<LoginFieldEdited>(_onFieldEdited);
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state is LoginInProgress) return;
    emit(const LoginInProgress());

    final result = await _loginUseCase(
      LoginParams(phone: event.phone, password: event.password),
    );

    result.fold(
      (failure) {
        unawaited(_crashlytics.log('Login failed: ${failure.statusCode} ${failure.message}'));
        if (failure.statusCode == 403) {
          // Akun ada tapi nomor HP belum diverifikasi → arahkan ke OTP.
          emit(LoginNeedsVerification(phone: normalizePhone(event.phone), message: failure.message));
        } else {
          emit(LoginFailure(message: failure.message, fieldErrors: _fieldErrorsOf(failure)));
        }
      },
      (auth) {
        unawaited(_analytics.logLogin(method: 'phone'));
        unawaited(_analytics.setUserId(auth.userId));
        unawaited(_crashlytics.setUserId(auth.userId));
        emit(LoginSuccess(auth));
      },
    );
  }

  void _onFieldEdited(LoginFieldEdited event, Emitter<LoginState> emit) {
    final current = state;
    if (current is! LoginFailure || !current.fieldErrors.containsKey(event.field)) return;
    emit(current.withoutFieldError(event.field));
  }

  Map<String, String> _fieldErrorsOf(AppFailure failure) {
    if (failure is! ValidationFailure) return const {};
    final errors = failure.errors ?? const <String, List<String>>{};
    return {
      for (final entry in errors.entries)
        if (entry.value.isNotEmpty) entry.key: entry.value.first,
    };
  }
}
