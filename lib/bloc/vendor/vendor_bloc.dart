import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/vendor_form_model.dart';
import '../../data/models/vendor_model.dart';
import '../../data/services/vendor_service.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  VendorEvent? _lastEvent;
  VendorBloc({bool useConnectivityListener = true}) : super(VendorInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is VendorFailed &&
            (state as VendorFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchVendor>((event, emit) async {
      _lastEvent = event;
      emit(VendorLoading());
      final result = await VendorService().getVendor();
      result.fold(
        (error) {
          emit(VendorFailed(error));
        },
        (data) {
          emit(VendorLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateVendor>((event, emit) async {
      _lastEvent = event;
      emit(VendorLoading());
      final result = await VendorService().createVendor(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(VendorFailed(error));
        }
      }, (success) async => emit(VendorCreated()));
    });

    on<UpdateVendor>((event, emit) async {
      _lastEvent = event;
      emit(VendorLoading());
      final result = await VendorService().updateVendor(event.id, event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(VendorFailed(error));
        }
      }, (success) async => emit(VendorUpdated()));
    });

    on<DeleteVendor>((event, emit) async {
      _lastEvent = event;
      emit(VendorLoading());
      final result = await VendorService().deleteVendor(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(VendorFailed(error));
        }
      }, (success) async => emit(VendorDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
