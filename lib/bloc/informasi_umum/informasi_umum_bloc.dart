import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/informasi_umum_form_model.dart';
import '../../data/models/informasi_umum_model.dart';
import '../../data/services/informasi_umum_service.dart';

part 'informasi_umum_event.dart';
part 'informasi_umum_state.dart';

class InformasiUmumBloc extends Bloc<InformasiUmumEvent, InformasiUmumState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  InformasiUmumEvent? _lastEvent;
  InformasiUmumBloc({bool useConnectivityListener = true})
    : super(InformasiUmumInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is InformasiUmumFailed &&
            (state as InformasiUmumFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchInformasiUmum>((event, emit) async {
      _lastEvent = event;
      emit(InformasiUmumLoading());
      final result = await InformasiUmumService().getInformasiUmum();
      result.fold(
        (error) {
          emit(InformasiUmumFailed(error));
        },
        (data) {
          emit(InformasiUmumLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateInformasiUmum>((event, emit) async {
      _lastEvent = event;
      emit(InformasiUmumLoading());
      final result = await InformasiUmumService().createInformasiUmum(
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(InformasiUmumFailed(error));
        }
      }, (success) async => emit(InformasiUmumCreated()));
    });

    on<UpdateInformasiUmum>((event, emit) async {
      _lastEvent = event;
      emit(InformasiUmumLoading());
      final result = await InformasiUmumService().updateInformasiUmum(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(InformasiUmumFailed(error));
        }
      }, (success) async => emit(InformasiUmumUpdated()));
    });

    on<DeleteInformasiUmum>((event, emit) async {
      _lastEvent = event;
      emit(InformasiUmumLoading());
      final result = await InformasiUmumService().deleteInformasiUmum(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(InformasiUmumFailed(error));
        }
      }, (success) async => emit(InformasiUmumDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
