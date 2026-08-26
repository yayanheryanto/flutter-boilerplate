part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class DashboardTabChanged extends DashboardEvent {
  final int index;
  const DashboardTabChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class DashboardBannerChanged extends DashboardEvent {
  final int index;
  const DashboardBannerChanged(this.index);
  @override
  List<Object?> get props => [index];
}

class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}
