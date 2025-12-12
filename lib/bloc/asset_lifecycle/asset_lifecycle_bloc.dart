import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/asset_lifecycle_model.dart';
import '../../data/services/asset_service.dart';

part 'asset_lifecycle_event.dart';
part 'asset_lifecycle_state.dart';

class AssetLifecycleBloc
    extends Bloc<AssetLifecycleEvent, AssetLifecycleState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  AssetLifecycleEvent? _lastEvent;
  AssetLifecycleBloc({bool useConnectivityListener = true})
    : super(AssetLifecycleInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is AssetLifecycleFailed &&
            (state as AssetLifecycleFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchAssetLifecycle>((event, emit) async {
      _lastEvent = event;
      emit(AssetLifecycleLoading());
      final result = await AssetService().showAssetLifecyle(event.id);
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(AssetLifecycleFailed(error));
          }
        },
        (data) {
          emit(AssetLifecycleLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
