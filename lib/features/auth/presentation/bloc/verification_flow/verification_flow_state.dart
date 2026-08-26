part of 'verification_flow_bloc.dart';

enum VerificationFlowStatus { initial, editing, submitting, success, failure }

class VerificationFlowState extends Equatable {
  final AccountType? accountType;
  final VerificationFlowStatus status;
  final String? errorMessage;

  const VerificationFlowState({this.accountType, this.status = VerificationFlowStatus.initial, this.errorMessage});

  VerificationFlowState copyWith({AccountType? accountType, VerificationFlowStatus? status, String? errorMessage}) => VerificationFlowState(
    accountType: accountType ?? this.accountType,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [accountType, status, errorMessage];
}
