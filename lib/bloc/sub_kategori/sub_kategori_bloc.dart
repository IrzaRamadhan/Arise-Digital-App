import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/sub_kategori_form_model.dart';
import '../../data/models/sub_kategori_model.dart';
import '../../data/services/sub_kategori_service.dart';

part 'sub_kategori_event.dart';
part 'sub_kategori_state.dart';

class SubKategoriBloc extends Bloc<SubKategoriEvent, SubKategoriState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  SubKategoriEvent? _lastEvent;
  SubKategoriBloc({bool useConnectivityListener = true})
    : super(SubKategoriInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is SubKategoriFailed &&
            (state as SubKategoriFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchSubKategori>((event, emit) async {
      _lastEvent = event;
      emit(SubKategoriLoading());
      final result = await SubKategoriService().getSubKategori();
      result.fold(
        (error) {
          emit(SubKategoriFailed(error));
        },
        (data) {
          emit(SubKategoriLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateSubKategori>((event, emit) async {
      _lastEvent = event;
      emit(SubKategoriLoading());
      final result = await SubKategoriService().createSubKategori(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(SubKategoriFailed(error));
        }
      }, (success) async => emit(SubKategoriCreated()));
    });

    on<UpdateSubKategori>((event, emit) async {
      _lastEvent = event;
      emit(SubKategoriLoading());
      final result = await SubKategoriService().updateSubKategori(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(SubKategoriFailed(error));
        }
      }, (success) async => emit(SubKategoriUpdated()));
    });

    on<DeleteSubKategori>((event, emit) async {
      _lastEvent = event;
      emit(SubKategoriLoading());
      final result = await SubKategoriService().deleteSubKategori(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(SubKategoriFailed(error));
        }
      }, (success) async => emit(SubKategoriDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
