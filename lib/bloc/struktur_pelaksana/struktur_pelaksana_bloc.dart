import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/struktur_pelaksana_form_model.dart';
import '../../data/models/struktur_pelaksana_model.dart';
import '../../data/services/struktur_pelaksana_service.dart';

part 'struktur_pelaksana_event.dart';
part 'struktur_pelaksana_state.dart';

class StrukturPelaksanaBloc
    extends Bloc<StrukturPelaksanaEvent, StrukturPelaksanaState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StrukturPelaksanaEvent? _lastEvent;
  StrukturPelaksanaBloc({bool useConnectivityListener = true})
    : super(StrukturPelaksanaInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is StrukturPelaksanaFailed &&
            (state as StrukturPelaksanaFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchStrukturPelaksana>((event, emit) async {
      _lastEvent = event;
      emit(StrukturPelaksanaLoading());
      final result = await StrukturPelaksanaService().getStrukturPelaksana();
      result.fold(
        (error) {
          emit(StrukturPelaksanaFailed(error));
        },
        (data) {
          emit(StrukturPelaksanaLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateStrukturPelaksana>((event, emit) async {
      _lastEvent = event;
      emit(StrukturPelaksanaLoading());
      final result = await StrukturPelaksanaService().createStrukturPelaksana(
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(StrukturPelaksanaFailed(error));
        }
      }, (success) async => emit(StrukturPelaksanaCreated()));
    });

    on<UpdateStrukturPelaksana>((event, emit) async {
      _lastEvent = event;
      emit(StrukturPelaksanaLoading());
      final result = await StrukturPelaksanaService().updateStrukturPelaksana(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(StrukturPelaksanaFailed(error));
        }
      }, (success) async => emit(StrukturPelaksanaUpdated()));
    });

    on<DeleteStrukturPelaksana>((event, emit) async {
      _lastEvent = event;
      emit(StrukturPelaksanaLoading());
      final result = await StrukturPelaksanaService().deleteStrukturPelaksana(
        event.id,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(StrukturPelaksanaFailed(error));
        }
      }, (success) async => emit(StrukturPelaksanaDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
