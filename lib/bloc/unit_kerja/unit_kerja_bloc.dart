import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/unit_kerja_model.dart';
import '../../data/services/unit_kerja_service.dart';

part 'unit_kerja_event.dart';
part 'unit_kerja_state.dart';

class UnitKerjaBloc extends Bloc<UnitKerjaEvent, UnitKerjaState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  UnitKerjaEvent? _lastEvent;
  UnitKerjaBloc({bool useConnectivityListener = true})
    : super(UnitKerjaInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is UnitKerjaFailed &&
            (state as UnitKerjaFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchUnitKerja>((event, emit) async {
      _lastEvent = event;
      emit(UnitKerjaLoading());
      final result = await UnitKerjaService().getUnitKerja(event.dinasId);
      result.fold(
        (error) {
          emit(UnitKerjaFailed(error));
        },
        (data) {
          emit(UnitKerjaLoaded(data));
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
