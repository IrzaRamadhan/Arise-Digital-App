import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/maintenance_complete_form_model.dart';
import '../../data/services/asset_sdm_service.dart';

part 'asset_sdm_event.dart';
part 'asset_sdm_state.dart';

class AssetSdmBloc extends Bloc<AssetSdmEvent, AssetSdmState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  AssetSdmEvent? _lastEvent;
  AssetSdmBloc({bool useConnectivityListener = true})
    : super(AssetSdmInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is AssetSdmFailed &&
            (state as AssetSdmFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<ApproveAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetSdmLoading());
      final result = await AssetSdmService().approve(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetSdmFailed(error));
        }
      }, (success) async => emit(AssetSdmApproved()));
    });

    on<RejectAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetSdmLoading());
      final result = await AssetSdmService().reject(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetSdmFailed(error));
        }
      }, (success) async => emit(AssetSdmRejected()));
    });

    on<MaintenanceStartAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetSdmLoading());
      final result = await AssetSdmService().maintenanceStart(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetSdmFailed(error));
        }
      }, (success) async => emit(AssetSdmMaintenanceStarted()));
    });

    on<MaintenanceCompleteAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetSdmLoading());
      final result = await AssetSdmService().maintenanceComplete(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetSdmFailed(error));
        }
      }, (success) async => emit(AssetSdmMaintenanceCompleted()));
    });

    on<DecommissionProposeAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetSdmLoading());
      final result = await AssetSdmService().decommissionPropose(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetSdmFailed(error));
        }
      }, (success) async => emit(AssetSdmDecommissionProposed()));
    });

    on<DisposalProposeAssetSdm>((event, emit) async {
      _lastEvent = event;
      emit(AssetSdmLoading());
      final result = await AssetSdmService().disposalPropose(
        id: event.id,
        reason: event.reason,
        method: event.method,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AssetSdmFailed(error));
        }
      }, (success) async => emit(AssetSdmDisposalProposed()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
