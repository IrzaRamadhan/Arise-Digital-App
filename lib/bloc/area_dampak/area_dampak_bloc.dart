import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/area_dampak_form_model.dart';
import '../../data/models/area_dampak_model.dart';
import '../../data/services/area_dampak_service.dart';

part 'area_dampak_event.dart';
part 'area_dampak_state.dart';

class AreaDampakBloc extends Bloc<AreaDampakEvent, AreaDampakState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  AreaDampakEvent? _lastEvent;
  AreaDampakBloc({bool useConnectivityListener = true})
    : super(AreaDampakInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is AreaDampakFailed &&
            (state as AreaDampakFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchAreaDampak>((event, emit) async {
      _lastEvent = event;
      emit(AreaDampakLoading());
      final result = await AreaDampakService().getAreaDampak();
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(AreaDampakFailed(error));
          }
        },
        (data) {
          emit(AreaDampakLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateAreaDampak>((event, emit) async {
      _lastEvent = event;
      emit(AreaDampakLoading());
      final result = await AreaDampakService().createAreaDampak(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AreaDampakFailed(error));
        }
      }, (success) async => emit(AreaDampakCreated()));
    });

    on<UpdateAreaDampak>((event, emit) async {
      _lastEvent = event;
      emit(AreaDampakLoading());
      final result = await AreaDampakService().updateAreaDampak(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AreaDampakFailed(error));
        }
      }, (success) async => emit(AreaDampakUpdated()));
    });

    on<DeleteAreaDampak>((event, emit) async {
      emit(AreaDampakLoading());
      final result = await AreaDampakService().deleteAreaDampak(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AreaDampakFailed(error));
        }
      }, (success) async => emit(AreaDampakDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
