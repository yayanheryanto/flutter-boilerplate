import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/firebase/firebase_services.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/domain/usecases/auth/otp_usecase.dart';
import 'package:emas/features/auth/presentation/models/otp_page_args.dart';

part 'otp_event.dart';
part 'otp_state.dart';

/// Verifikasi & kirim ulang OTP, termasuk aturan cooldown dan batas kirim
/// ulang (sebelumnya tersebar di `State` widget).
///
/// Purpose [OtpPurpose.register] memanggil API. Purpose lain belum punya
/// endpoint, jadi untuk sementara langsung dianggap terverifikasi agar
/// alur lupa/ganti password tetap jalan seperti sebelumnya.
@injectable
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  static const int maxResend = 3;
  static const int codeLength = 6;

  final VerifyOtpUseCase _verifyOtp;
  final ResendOtpUseCase _resendOtp;
  final AnalyticsService _analytics;
  final CrashlyticsService _crashlytics;

  Timer? _ticker;

  OtpBloc(
    this._verifyOtp,
    this._resendOtp,
    this._analytics,
    this._crashlytics,
  ) : super(OtpState.initial()) {
    on<OtpStarted>(_onStarted);
    on<OtpCodeSubmitted>(_onCodeSubmitted);
    on<OtpResendRequested>(_onResendRequested);
    on<_OtpCooldownTicked>(_onCooldownTicked);
  }

  void _onStarted(OtpStarted event, Emitter<OtpState> emit) {
    final args = event.args;
    emit(
      OtpState.initial().copyWith(
        purpose: args.purpose,
        destination: args.destination,
        verificationId: args.verificationId,
      ),
    );
    _startCooldown(args.resendCooldown, emit);
  }

  Future<void> _onCodeSubmitted(
    OtpCodeSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (state.isVerifying || event.code.length != codeLength) return;

    emit(state.copyWith(status: OtpStatus.verifying, clearMessage: true));

    final verificationId = state.verificationId;
    if (state.purpose != OtpPurpose.register || verificationId == null) {
      // TODO(api): sambungkan ke endpoint OTP lupa/ganti password.
      emit(state.copyWith(status: OtpStatus.verified));
      return;
    }

    final result = await _verifyOtp(
      VerifyOtpParams(verificationId: verificationId, code: event.code),
    );

    result.fold(
      (failure) {
        unawaited(_crashlytics.log('OTP verify failed: ${failure.message}'));
        emit(state.copyWith(status: OtpStatus.failure, message: failure.message));
      },
      (auth) {
        unawaited(_analytics.logSignUp(method: 'phone'));
        unawaited(_analytics.setUserId(auth.userId));
        unawaited(_crashlytics.setUserId(auth.userId));
        _ticker?.cancel();
        emit(state.copyWith(status: OtpStatus.verified, auth: auth));
      },
    );
  }

  Future<void> _onResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    if (!state.canResend) return;

    emit(state.copyWith(isResending: true, clearMessage: true));

    final verificationId = state.verificationId;
    if (state.purpose != OtpPurpose.register || verificationId == null) {
      // TODO(api): sambungkan ke endpoint kirim ulang OTP lupa/ganti password.
      emit(state.copyWith(isResending: false, resendCount: state.resendCount + 1));
      _startCooldown(const Duration(seconds: 60), emit);
      return;
    }

    final result = await _resendOtp(verificationId);

    result.fold(
      (failure) => emit(
        state.copyWith(isResending: false, status: OtpStatus.failure, message: failure.message),
      ),
      (challenge) {
        emit(
          state.copyWith(
            isResending: false,
            resendCount: state.resendCount + 1,
            destination: challenge.maskedDestination,
            status: OtpStatus.codeResent,
            message: 'Kode OTP baru telah dikirim',
          ),
        );
        _startCooldown(challenge.resendCooldown, emit);
      },
    );
  }

  void _onCooldownTicked(_OtpCooldownTicked event, Emitter<OtpState> emit) {
    final next = state.resendCountdown - 1;
    if (next <= 0) _ticker?.cancel();
    emit(state.copyWith(resendCountdown: next < 0 ? 0 : next));
  }

  void _startCooldown(Duration duration, Emitter<OtpState> emit) {
    _ticker?.cancel();
    emit(state.copyWith(resendCountdown: duration.inSeconds));
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const _OtpCooldownTicked()),
    );
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
