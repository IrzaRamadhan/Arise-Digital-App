import 'dart:async';

import 'package:arise/data/models/lokasi_form_model.dart' show LokasiFormModel;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lokasi_model.dart';
import '../../data/services/lokasi_service.dart';

part 'lokasi_event.dart';
part 'lokasi_state.dart';

class LokasiBloc extends Bloc<LokasiEvent, LokasiState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  LokasiEvent? _lastEvent;
  LokasiBloc({bool useConnectivityListener = true}) : super(LokasiInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is LokasiFailed &&
            (state as LokasiFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchLokasi>((event, emit) async {
      _lastEvent = event;
      emit(LokasiLoading());
      final result = await LokasiService().getLokasi();
      result.fold(
        (error) {
          emit(LokasiFailed(error));
        },
        (data) {
          emit(LokasiLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateLokasi>((event, emit) async {
      _lastEvent = event;
      emit(LokasiLoading());
      final result = await LokasiService().createLokasi(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LokasiFailed(error));
        }
      }, (success) async => emit(LokasiCreated()));
    });

    on<UpdateLokasi>((event, emit) async {
      _lastEvent = event;
      emit(LokasiLoading());
      final result = await LokasiService().updateLokasi(event.id, event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LokasiFailed(error));
        }
      }, (success) async => emit(LokasiUpdated()));
    });

    on<DeleteLokasi>((event, emit) async {
      _lastEvent = event;
      emit(LokasiLoading());
      final result = await LokasiService().deleteLokasi(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LokasiFailed(error));
        }
      }, (success) async => emit(LokasiDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
