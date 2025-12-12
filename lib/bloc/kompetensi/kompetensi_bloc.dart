import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/kompetensi_model.dart';
import '../../data/services/kompetensi_service.dart';

part 'kompetensi_event.dart';
part 'kompetensi_state.dart';

class KompetensiBloc extends Bloc<KompetensiEvent, KompetensiState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  KompetensiEvent? _lastEvent;
  KompetensiBloc({bool useConnectivityListener = true})
    : super(KompetensiInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is KompetensiFailed &&
            (state as KompetensiFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchKompetensi>((event, emit) async {
      _lastEvent = event;
      emit(KompetensiLoading());
      final result = await KompetensiService().getKompetensi();
      result.fold(
        (error) {
          emit(KompetensiFailed(error));
        },
        (data) {
          emit(KompetensiLoaded(data));
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
