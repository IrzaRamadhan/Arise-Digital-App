import 'dart:async';

import 'package:arise/data/models/asset_sdm_form_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/asset_barang_form_model.dart';
import '../../data/models/asset_model.dart';
import '../../data/services/asset_service.dart';

part 'asset_event.dart';
part 'asset_state.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  AssetEvent? _lastEvent;
  AssetBloc({bool useConnectivityListener = true}) : super(AssetInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is AssetFailed &&
            (state as AssetFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchAssetDetail>((event, emit) async {
      _lastEvent = event;
      emit(AssetLoading());
      final result = await AssetService().showAsset(event.id, event.type);
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(AssetFailed(error));
          }
        },
        (data) {
          emit(AssetDetailLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetLoading());
      final result = await AssetService().createAssetBarang(
        data: event.data,
        file: event.lampiranFile,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetFailed(error));
        }
      }, (success) async => emit(AssetBarangCreated()));
    });

    on<CreateAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetLoading());
      final result = await AssetService().createAssetSdm(data: event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetFailed(error));
        }
      }, (success) async => emit(AssetSdmCreated()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
