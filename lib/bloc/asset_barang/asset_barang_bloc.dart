import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/maintenance_complete_form_model.dart';
import '../../data/services/asset_barang_service.dart';

part 'asset_barang_event.dart';
part 'asset_barang_state.dart';

class AssetBarangBloc extends Bloc<AssetBarangEvent, AssetBarangState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  AssetBarangEvent? _lastEvent;
  AssetBarangBloc({bool useConnectivityListener = true})
    : super(AssetBarangInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is AssetBarangFailed &&
            (state as AssetBarangFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<ApproveAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetBarangLoading());
      final result = await AssetBarangService().approve(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetBarangFailed(error));
        }
      }, (success) async => emit(AssetBarangApproved()));
    });

    on<RejectAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetBarangLoading());
      final result = await AssetBarangService().reject(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetBarangFailed(error));
        }
      }, (success) async => emit(AssetBarangRejected()));
    });

    on<MaintenanceStartAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetBarangLoading());
      final result = await AssetBarangService().maintenanceStart(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetBarangFailed(error));
        }
      }, (success) async => emit(AssetBarangMaintenanceStarted()));
    });

    on<MaintenanceCompleteAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetBarangLoading());
      final result = await AssetBarangService().maintenanceComplete(
        id: event.id,
        data: event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetBarangFailed(error));
        }
      }, (success) async => emit(AssetBarangMaintenanceCompleted()));
    });

    on<DecommissionProposeAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetBarangLoading());
      final result = await AssetBarangService().decommissionPropose(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetBarangFailed(error));
        }
      }, (success) async => emit(AssetBarangDecommissionProposed()));
    });

    on<DisposalProposeAssetBarang>((event, emit) async {
      _lastEvent = event;
      emit(AssetBarangLoading());
      final result = await AssetBarangService().disposalPropose(
        id: event.id,
        reason: event.reason,
        method: event.method,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetBarangFailed(error));
        }
      }, (success) async => emit(AssetBarangDisposalProposed()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
