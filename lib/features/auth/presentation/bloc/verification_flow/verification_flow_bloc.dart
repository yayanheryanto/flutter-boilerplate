import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:emas/core/utils/account_type.dart';

part 'verification_flow_event.dart';
part 'verification_flow_state.dart';

@injectable
class VerificationFlowBloc extends Bloc<VerificationFlowEvent, VerificationFlowState> {
  VerificationFlowBloc() : super(const VerificationFlowState()) {
    on<VerificationFlowStarted>((event, emit) => emit(state.copyWith(accountType: event.accountType, status: VerificationFlowStatus.editing)));
    on<VerificationSubmissionStarted>((event, emit) => emit(state.copyWith(status: VerificationFlowStatus.submitting)));
    on<VerificationSubmissionSucceeded>((event, emit) => emit(state.copyWith(status: VerificationFlowStatus.success)));
    on<VerificationSubmissionFailed>((event, emit) => emit(state.copyWith(status: VerificationFlowStatus.failure, errorMessage: event.message)));
    on<VerificationFlowReset>((event, emit) => emit(const VerificationFlowState()));
  }
}
