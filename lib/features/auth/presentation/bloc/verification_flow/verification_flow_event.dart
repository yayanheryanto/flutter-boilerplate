part of 'verification_flow_bloc.dart';

abstract class VerificationFlowEvent extends Equatable {
  const VerificationFlowEvent();
  @override
  List<Object?> get props => [];
}

class VerificationFlowStarted extends VerificationFlowEvent {
  final AccountType accountType;
  const VerificationFlowStarted(this.accountType);
  @override
  List<Object?> get props => [accountType];
}

class VerificationSubmissionStarted extends VerificationFlowEvent {
  const VerificationSubmissionStarted();
}

class VerificationSubmissionSucceeded extends VerificationFlowEvent {
  const VerificationSubmissionSucceeded();
}

class VerificationSubmissionFailed extends VerificationFlowEvent {
  final String message;
  const VerificationSubmissionFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class VerificationFlowReset extends VerificationFlowEvent {
  const VerificationFlowReset();
}
