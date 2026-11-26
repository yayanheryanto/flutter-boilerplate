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
/// Alur purpose [OtpPurpose.register]:
/// 1. [OtpStarted] tanpa `verificationId` → `POST /auth/otp/request`
/// 2. [OtpCodeSubmitted] → `POST /auth/otp/verify` (login)
/// 3. [OtpResendRequested] → `/auth/otp/resend`, atau request ulang bila
///    request pertama gagal.
///
/// Purpose lain belum punya endpoint, jadi untuk sementara langsung dianggap
/// terverifikasi agar alur lupa/ganti password tetap jalan seperti sebelumnya.
@injectable
class OtpBloc extends Bloc<OtpEvent, OtpState> {
  static const int maxResend = 3;
  static const int codeLength = 6;

  final RequestOtpUseCase _requestOtp;
  final VerifyOtpUseCase _verifyOtp;
  final ResendOtpUseCase _resendOtp;
  final AnalyticsService _analytics;
  final CrashlyticsService _crashlytics;

  Timer? _ticker;

  OtpBloc(
    this._requestOtp,
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

  Future<void> _onStarted(OtpStarted event, Emitter<OtpState> emit) async {
    final args = event.args;
    emit(
      OtpState.initial().copyWith(
        purpose: args.purpose,
        destination: args.destination,
        verificationId: args.verificationId,
      ),
    );

    if (_needsInitialRequest) {
      await _requestInitialOtp(emit);
    } else {
      _startCooldown(args.resendCooldown, emit);
    }
  }

  /// Register tanpa `verificationId` → OTP belum pernah di-request.
  bool get _needsInitialRequest =>
      state.purpose == OtpPurpose.register && state.verificationId == null;

  Future<void> _requestInitialOtp(Emitter<OtpState> emit) async {
    emit(state.copyWith(status: OtpStatus.requesting, clearMessage: true));

    final result = await _requestOtp(
      RequestOtpParams(phone: state.destination, purpose: state.purpose),
    );

    result.fold(
      // Countdown tetap 0 → tombol kirim ulang aktif untuk mencoba lagi.
      (failure) => emit(state.copyWith(status: OtpStatus.failure, message: failure.message)),
      (challenge) {
        emit(
          state.copyWith(
            status: OtpStatus.codeSent,
            verificationId: challenge.verificationId,
            destination: challenge.maskedDestination,
            message: 'Kode OTP telah dikirim ke ${challenge.maskedDestination}',
          ),
        );
        _startCooldown(challenge.resendCooldown, emit);
      },
    );
  }

  Future<void> _onCodeSubmitted(
    OtpCodeSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    if (state.isVerifying || state.isRequesting || event.code.length != codeLength) return;

    emit(state.copyWith(status: OtpStatus.verifying, clearMessage: true));

    final verificationId = state.verificationId;
    if (state.purpose != OtpPurpose.register) {
      // TODO(api): sambungkan ke endpoint OTP lupa/ganti password.
      emit(state.copyWith(status: OtpStatus.verified));
      return;
    }
    if (verificationId == null) {
      emit(
        state.copyWith(
          status: OtpStatus.failure,
          message: 'Kode OTP belum terkirim, silakan tekan kirim ulang',
        ),
      );
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

    // Request pertama gagal → ulangi request, bukan resend.
    if (_needsInitialRequest) {
      await _requestInitialOtp(emit);
      return;
    }

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
    // Request bisa selesai setelah user menutup halaman (bloc sudah close).
    // Membuat timer di titik ini akan memanggil add() pada bloc yang
    // tertutup → StateError → crash.
    if (isClosed) return;
    emit(state.copyWith(resendCountdown: duration.inSeconds));
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      add(const _OtpCooldownTicked());
    });
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
