import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/matriks_risiko_model.dart';
import '../../data/services/matriks_risiko_service.dart';

part 'matriks_risiko_event.dart';
part 'matriks_risiko_state.dart';

class MatriksRisikoBloc extends Bloc<MatriksRisikoEvent, MatriksRisikoState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  MatriksRisikoEvent? _lastEvent;
  MatriksRisikoBloc({bool useConnectivityListener = true})
    : super(MatriksRisikoInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is MatriksRisikoFailed &&
            (state as MatriksRisikoFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchMatriksRisiko>((event, emit) async {
      _lastEvent = event;
      emit(MatriksRisikoLoading());
      final result = await MatriksRisikoService().getMatrixGrid();
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(MatriksRisikoFailed(error));
          }
        },
        (data) {
          emit(MatriksRisikoLoaded(data));
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
