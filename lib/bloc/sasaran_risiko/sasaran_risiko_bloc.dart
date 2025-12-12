import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/sasaran_risiko_form_model.dart';
import '../../data/models/sasaran_risiko_model.dart';
import '../../data/services/sasaran_risiko_service.dart';

part 'sasaran_risiko_event.dart';
part 'sasaran_risiko_state.dart';

class SasaranRisikoBloc extends Bloc<SasaranRisikoEvent, SasaranRisikoState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  SasaranRisikoEvent? _lastEvent;
  SasaranRisikoBloc({bool useConnectivityListener = true})
    : super(SasaranRisikoInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is SasaranRisikoFailed &&
            (state as SasaranRisikoFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchSasaranRisiko>((event, emit) async {
      _lastEvent = event;
      emit(SasaranRisikoLoading());
      final result = await SasaranRisikoService().getSasaranRisiko();
      result.fold(
        (error) {
          emit(SasaranRisikoFailed(error));
        },
        (data) {
          emit(SasaranRisikoLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateSasaranRisiko>((event, emit) async {
      _lastEvent = event;
      emit(SasaranRisikoLoading());
      final result = await SasaranRisikoService().createSasaranRisiko(
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(SasaranRisikoFailed(error));
        }
      }, (success) async => emit(SasaranRisikoCreated()));
    });

    on<UpdateSasaranRisiko>((event, emit) async {
      _lastEvent = event;
      emit(SasaranRisikoLoading());
      final result = await SasaranRisikoService().updateSasaranRisiko(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(SasaranRisikoFailed(error));
        }
      }, (success) async => emit(SasaranRisikoUpdated()));
    });

    on<DeleteSasaranRisiko>((event, emit) async {
      _lastEvent = event;
      emit(SasaranRisikoLoading());
      final result = await SasaranRisikoService().deleteSasaranRisiko(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(SasaranRisikoFailed(error));
        }
      }, (success) async => emit(SasaranRisikoDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
