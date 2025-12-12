import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/level_dampak_form_model.dart';
import '../../data/models/level_dampak_model.dart';
import '../../data/services/level_dampak_service.dart';

part 'level_dampak_event.dart';
part 'level_dampak_state.dart';

class LevelDampakBloc extends Bloc<LevelDampakEvent, LevelDampakState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  LevelDampakEvent? _lastEvent;
  LevelDampakBloc({bool useConnectivityListener = true})
    : super(LevelDampakInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is LevelDampakFailed &&
            (state as LevelDampakFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchLevelDampak>((event, emit) async {
      _lastEvent = event;
      emit(LevelDampakLoading());
      final result = await LevelDampakService().getLevelDampak();
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(LevelDampakFailed(error));
          }
        },
        (data) {
          emit(LevelDampakLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateLevelDampak>((event, emit) async {
      _lastEvent = event;
      emit(LevelDampakLoading());
      final result = await LevelDampakService().createLevelDampak(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LevelDampakFailed(error));
        }
      }, (success) async => emit(LevelDampakCreated()));
    });

    on<UpdateLevelDampak>((event, emit) async {
      _lastEvent = event;
      emit(LevelDampakLoading());
      final result = await LevelDampakService().updateLevelDampak(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LevelDampakFailed(error));
        }
      }, (success) async => emit(LevelDampakUpdated()));
    });

    on<DeleteLevelDampak>((event, emit) async {
      emit(LevelDampakLoading());
      final result = await LevelDampakService().deleteLevelDampak(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(LevelDampakFailed(error));
        }
      }, (success) async => emit(LevelDampakDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
