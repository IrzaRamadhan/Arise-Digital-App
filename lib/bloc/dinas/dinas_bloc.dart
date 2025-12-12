import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/dinas_model.dart';
import '../../data/services/dinas_service.dart';

part 'dinas_event.dart';
part 'dinas_state.dart';

class DinasBloc extends Bloc<DinasEvent, DinasState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  DinasEvent? _lastEvent;
  DinasBloc({bool useConnectivityListener = true}) : super(DinasInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is DinasFailed &&
            (state as DinasFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchDinas>((event, emit) async {
      _lastEvent = event;
      emit(DinasLoading());
      final result = await DinasService().getDinas();
      result.fold(
        (error) {
          emit(DinasFailed(error));
        },
        (data) {
          emit(DinasLoaded(data));
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
