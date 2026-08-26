import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:emas/features/dashboard/domain/entities/payment_method.dart';

part 'buy_npl_confirmation_event.dart';
part 'buy_npl_confirmation_state.dart';

@injectable
class BuyNplConfirmationBloc extends Bloc<BuyNplConfirmationEvent, BuyNplConfirmationState> {
  BuyNplConfirmationBloc() : super(const BuyNplConfirmationState()) {
    on<PaymentMethodSelected>((event, emit) => emit(state.copyWith(selectedMethod: event.method)));
    on<PaymentTermsChanged>((event, emit) => emit(state.copyWith(agreeToTerms: event.value)));
  }
}
