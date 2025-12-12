import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/jabatan_model.dart';
import '../../data/services/jabatan_service.dart';

part 'jabatan_event.dart';
part 'jabatan_state.dart';

class JabatanBloc extends Bloc<JabatanEvent, JabatanState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  JabatanEvent? _lastEvent;
  JabatanBloc({bool useConnectivityListener = true}) : super(JabatanInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is JabatanFailed &&
            (state as JabatanFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchJabatan>((event, emit) async {
      _lastEvent = event;
      emit(JabatanLoading());
      final result = await JabatanService().getJabatan();
      result.fold(
        (error) {
          emit(JabatanFailed(error));
        },
        (data) {
          emit(JabatanLoaded(data));
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
