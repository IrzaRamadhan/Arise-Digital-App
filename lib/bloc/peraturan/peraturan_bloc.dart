import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/peraturan_form_model.dart';
import '../../data/models/peraturan_model.dart';
import '../../data/services/peraturan_service.dart';

part 'peraturan_event.dart';
part 'peraturan_state.dart';

class PeraturanBloc extends Bloc<PeraturanEvent, PeraturanState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  PeraturanEvent? _lastEvent;
  PeraturanBloc({bool useConnectivityListener = true})
    : super(PeraturanInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is PeraturanFailed &&
            (state as PeraturanFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchPeraturan>((event, emit) async {
      _lastEvent = event;
      emit(PeraturanLoading());
      final result = await PeraturanService().getPeraturan();
      result.fold(
        (error) {
          emit(PeraturanFailed(error));
        },
        (data) {
          emit(PeraturanLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreatePeraturan>((event, emit) async {
      _lastEvent = event;
      emit(PeraturanLoading());
      final result = await PeraturanService().createPeraturan(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(PeraturanFailed(error));
        }
      }, (success) async => emit(PeraturanCreated()));
    });

    on<UpdatePeraturan>((event, emit) async {
      _lastEvent = event;
      emit(PeraturanLoading());
      final result = await PeraturanService().updatePeraturan(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(PeraturanFailed(error));
        }
      }, (success) async => emit(PeraturanUpdated()));
    });

    on<DeletePeraturan>((event, emit) async {
      _lastEvent = event;
      emit(PeraturanLoading());
      final result = await PeraturanService().deletePeraturan(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(PeraturanFailed(error));
        }
      }, (success) async => emit(PeraturanDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
