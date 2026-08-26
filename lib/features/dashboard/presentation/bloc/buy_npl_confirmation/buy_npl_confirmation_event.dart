part of 'buy_npl_confirmation_bloc.dart';

abstract class BuyNplConfirmationEvent extends Equatable {
  const BuyNplConfirmationEvent();
  @override
  List<Object?> get props => [];
}

class PaymentMethodSelected extends BuyNplConfirmationEvent {
  final PaymentMethod method;
  const PaymentMethodSelected(this.method);
  @override
  List<Object?> get props => [method];
}

class PaymentTermsChanged extends BuyNplConfirmationEvent {
  final bool value;
  const PaymentTermsChanged(this.value);
  @override
  List<Object?> get props => [value];
}
