part of 'buy_npl_confirmation_bloc.dart';

class BuyNplConfirmationState extends Equatable {
  final PaymentMethod? selectedMethod;
  final bool agreeToTerms;

  const BuyNplConfirmationState({this.selectedMethod, this.agreeToTerms = false});

  bool get canPay => selectedMethod != null && agreeToTerms;

  BuyNplConfirmationState copyWith({PaymentMethod? selectedMethod, bool? agreeToTerms}) =>
      BuyNplConfirmationState(
        selectedMethod: selectedMethod ?? this.selectedMethod,
        agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      );

  @override
  List<Object?> get props => [selectedMethod, agreeToTerms];
}
