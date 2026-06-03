import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/usecases/auth/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/firebase/firebase_services.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCachedAuthUseCase _getCachedAuthUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AnalyticsService _analyticsService;
  final CrashlyticsService _crashlyticsService;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCachedAuthUseCase,
    this._forgotPasswordUseCase,
    this._analyticsService,
    this._crashlyticsService,
  ) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckCacheRequested>(_onCheckCacheRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        _crashlyticsService.log('Login failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (auth) {
        _analyticsService.logLogin();
        _analyticsService.setUserId(auth.userId);
        _crashlyticsService.setUserId(auth.userId);
        emit(AuthAuthenticated(auth: auth));
      },
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    result.fold(
      (failure) {
        _crashlyticsService.log('Register failed: ${failure.message}');
        emit(AuthError(message: failure.message));
      },
      (auth) {
        _analyticsService.logSignUp();
        _analyticsService.setUserId(auth.userId);
        emit(AuthAuthenticated(auth: auth));
      },
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        _analyticsService.setUserId(null);
        emit(const AuthUnauthenticated());
      },
    );
  }

  Future<void> _onCheckCacheRequested(
    AuthCheckCacheRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _getCachedAuthUseCase();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (auth) {
        if (auth != null && !auth.isTokenExpired) {
          emit(AuthAuthenticated(auth: auth));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthForgotPasswordSent()),
    );
  }
}
