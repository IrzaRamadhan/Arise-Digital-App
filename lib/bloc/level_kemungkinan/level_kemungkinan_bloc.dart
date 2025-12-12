import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level_kemungkinan_form_model.dart';
import '../../data/models/level_kemungkinan_model.dart';
import '../../data/services/level_kemungkinan_service.dart';

part 'level_kemungkinan_event.dart';
part 'level_kemungkinan_state.dart';

class LevelKemungkinanBloc
    extends Bloc<LevelKemungkinanEvent, LevelKemungkinanState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  LevelKemungkinanEvent? _lastEvent;
  LevelKemungkinanBloc({bool useConnectivityListener = true})
    : super(LevelKemungkinanInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is LevelKemungkinanFailed &&
            (state as LevelKemungkinanFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchLevelKemungkinan>((event, emit) async {
      _lastEvent = event;
      emit(LevelKemungkinanLoading());
      final result = await LevelKemungkinanService().getLevelKemungkinan();
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(LevelKemungkinanFailed(error));
          }
        },
        (data) {
          emit(LevelKemungkinanLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateLevelKemungkinan>((event, emit) async {
      _lastEvent = event;
      emit(LevelKemungkinanLoading());
      final result = await LevelKemungkinanService().createLevelKemungkinan(
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LevelKemungkinanFailed(error));
        }
      }, (success) async => emit(LevelKemungkinanCreated()));
    });

    on<UpdateLevelKemungkinan>((event, emit) async {
      _lastEvent = event;
      emit(LevelKemungkinanLoading());
      final result = await LevelKemungkinanService().updateLevelKemungkinan(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LevelKemungkinanFailed(error));
        }
      }, (success) async => emit(LevelKemungkinanUpdated()));
    });

    on<DeleteLevelKemungkinan>((event, emit) async {
      emit(LevelKemungkinanLoading());
      final result = await LevelKemungkinanService().deleteLevelKemungkinan(
        event.id,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LevelKemungkinanFailed(error));
        }
      }, (success) async => emit(LevelKemungkinanDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
