import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/dashboard_model.dart';
import '../../data/services/dashboard_statistik_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  DashboardEvent? _lastEvent;
  DashboardBloc({bool useConnectivityListener = true})
    : super(DashboardInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is DashboardFailed &&
            (state as DashboardFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchDashboard>((event, emit) async {
      _lastEvent = event;
      emit(DashboardLoading());
      final result = await DashboardService().getDashboard(event.dinasId);
      result.fold(
        (error) {
          emit(DashboardFailed(error));
        },
        (data) {
          emit(DashboardLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
