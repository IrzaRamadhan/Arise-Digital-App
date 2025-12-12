part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardFailed extends DashboardState {
  final String message;
  const DashboardFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class DashboardLoaded extends DashboardState {
  final DashboardSummaryModel data;
  const DashboardLoaded(this.data);

  @override
  List<Object> get props => [data];
}
