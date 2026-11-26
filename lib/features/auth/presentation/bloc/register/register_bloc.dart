import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/auth/domain/entities/registered_user.dart';
import 'package:emas/features/auth/domain/usecases/auth/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

/// Mengelola submit form pendaftaran.
///
/// Hanya bertanggung jawab atas langkah "kirim form daftar → akun dibuat".
/// Request & verifikasi OTP ditangani `OtpBloc` di halaman OTP, sehingga
/// kegagalan kirim OTP bisa dicoba ulang tanpa mendaftar ulang.
@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterFieldEdited>(_onFieldEdited);
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    // Abaikan tap ganda selama request berjalan.
    if (state is RegisterInProgress) return;

    emit(const RegisterInProgress());

    final result = await _registerUseCase(
      RegisterParams(
        name: event.name,
        phone: event.phone,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        termsAccepted: event.termsAccepted,
      ),
    );

    result.fold(
      (failure) => emit(
        RegisterFailure(
          message: failure.message,
          fieldErrors: _fieldErrorsOf(failure),
        ),
      ),
      (user) => emit(RegisterSuccess(user)),
    );
  }

  /// Menghapus pesan error server pada field yang sedang diubah user.
  void _onFieldEdited(
    RegisterFieldEdited event,
    Emitter<RegisterState> emit,
  ) {
    final current = state;
    if (current is! RegisterFailure || !current.fieldErrors.containsKey(event.field)) {
      return;
    }
    emit(current.withoutFieldError(event.field));
  }

  /// `{ "email": ["Email sudah terdaftar"] }` → `{ "email": "Email sudah terdaftar" }`.
  Map<String, String> _fieldErrorsOf(AppFailure failure) {
    if (failure is! ValidationFailure) return const {};
    final errors = failure.errors ?? const <String, List<String>>{};
    return {
      for (final entry in errors.entries)
        if (entry.value.isNotEmpty) entry.key: entry.value.first,
    };
  }
}
