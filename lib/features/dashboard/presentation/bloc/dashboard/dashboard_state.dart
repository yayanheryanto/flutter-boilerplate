part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final int navigationIndex;
  final int bannerIndex;
  final bool isRefreshing;

  const DashboardState({this.navigationIndex = 0, this.bannerIndex = 0, this.isRefreshing = false});

  DashboardState copyWith({int? navigationIndex, int? bannerIndex, bool? isRefreshing}) => DashboardState(
    navigationIndex: navigationIndex ?? this.navigationIndex,
    bannerIndex: bannerIndex ?? this.bannerIndex,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );

  @override
  List<Object?> get props => [navigationIndex, bannerIndex, isRefreshing];
}
