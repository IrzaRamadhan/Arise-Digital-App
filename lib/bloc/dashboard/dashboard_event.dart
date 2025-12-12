part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboard extends DashboardEvent {
  final int dinasId;
  const FetchDashboard(this.dinasId);

  @override
  List<Object> get props => [dinasId];
}
