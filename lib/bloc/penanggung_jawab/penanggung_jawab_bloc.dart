import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/penanggung_jawab_model.dart';
import '../../data/services/penanggung_jawab_service.dart';

part 'penanggung_jawab_event.dart';
part 'penanggung_jawab_state.dart';

class PenanggungJawabBloc
    extends Bloc<PenanggungJawabEvent, PenanggungJawabState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  PenanggungJawabEvent? _lastEvent;
  PenanggungJawabBloc({bool useConnectivityListener = true})
    : super(PenanggungJawabInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is PenanggungJawabFailed &&
            (state as PenanggungJawabFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchPenanggungJawab>((event, emit) async {
      _lastEvent = event;
      emit(PenanggungJawabLoading());
      final result = await PenanggungJawabService().getPenanggungJawab();
      result.fold(
        (error) {
          emit(PenanggungJawabFailed(error));
        },
        (data) {
          emit(PenanggungJawabLoaded(data));
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
