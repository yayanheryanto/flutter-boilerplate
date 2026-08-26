import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<DashboardTabChanged>((event, emit) => emit(state.copyWith(navigationIndex: event.index)));
    on<DashboardBannerChanged>((event, emit) => emit(state.copyWith(bannerIndex: event.index)));
    on<DashboardRefreshRequested>((event, emit) async {
      emit(state.copyWith(isRefreshing: true));
      await Future<void>.delayed(const Duration(milliseconds: 800));
      emit(state.copyWith(isRefreshing: false));
    });
  }
}
