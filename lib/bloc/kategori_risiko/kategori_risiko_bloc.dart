import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/kategori_risiko_form_model.dart';
import '../../data/models/kategori_risiko_model.dart';
import '../../data/services/kategori_risiko_service.dart';

part 'kategori_risiko_event.dart';
part 'kategori_risiko_state.dart';

class KategoriRisikoBloc
    extends Bloc<KategoriRisikoEvent, KategoriRisikoState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  KategoriRisikoEvent? _lastEvent;
  KategoriRisikoBloc({bool useConnectivityListener = true})
    : super(KategoriRisikoInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is KategoriRisikoFailed &&
            (state as KategoriRisikoFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchKategoriRisiko>((event, emit) async {
      _lastEvent = event;
      emit(KategoriRisikoLoading());
      final result = await KategoriRisikoService().getKategoriRisiko();
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(KategoriRisikoFailed(error));
          }
        },
        (data) {
          emit(KategoriRisikoLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateKategoriRisiko>((event, emit) async {
      _lastEvent = event;
      emit(KategoriRisikoLoading());
      final result = await KategoriRisikoService().createKategoriRisiko(
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(KategoriRisikoFailed(error));
        }
      }, (success) async => emit(KategoriRisikoCreated()));
    });

    on<UpdateKategoriRisiko>((event, emit) async {
      _lastEvent = event;
      emit(KategoriRisikoLoading());
      final result = await KategoriRisikoService().updateKategoriRisiko(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(KategoriRisikoFailed(error));
        }
      }, (success) async => emit(KategoriRisikoUpdated()));
    });

    on<DeleteKategoriRisiko>((event, emit) async {
      emit(KategoriRisikoLoading());
      final result = await KategoriRisikoService().deleteKategoriRisiko(
        event.id,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(KategoriRisikoFailed(error));
        }
      }, (success) async => emit(KategoriRisikoDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
