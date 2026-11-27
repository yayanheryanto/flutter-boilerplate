part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final int navigationIndex;
  final bool isRefreshing;

  const DashboardState({this.navigationIndex = 0, this.isRefreshing = false});

  DashboardState copyWith({int? navigationIndex, bool? isRefreshing}) => DashboardState(
    navigationIndex: navigationIndex ?? this.navigationIndex,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );

  @override
  List<Object?> get props => [navigationIndex, isRefreshing];
}
