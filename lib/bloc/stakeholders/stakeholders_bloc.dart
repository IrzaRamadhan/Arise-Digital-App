import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/stakeholders_form_model.dart';
import '../../data/models/stakeholders_model.dart';
import '../../data/services/stakeholders_service.dart';

part 'stakeholders_event.dart';
part 'stakeholders_state.dart';

class StakeholdersBloc extends Bloc<StakeholdersEvent, StakeholdersState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  StakeholdersEvent? _lastEvent;
  StakeholdersBloc({bool useConnectivityListener = true})
    : super(StakeholdersInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is StakeholdersFailed &&
            (state as StakeholdersFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchStakeholders>((event, emit) async {
      _lastEvent = event;
      emit(StakeholdersLoading());
      final result = await StakeholdersService().getStakeholders();
      result.fold(
        (error) {
          emit(StakeholdersFailed(error));
        },
        (data) {
          emit(StakeholdersLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateStakeholders>((event, emit) async {
      _lastEvent = event;
      emit(StakeholdersLoading());
      final result = await StakeholdersService().createStakeholders(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(StakeholdersFailed(error));
        }
      }, (success) async => emit(StakeholdersCreated()));
    });

    on<UpdateStakeholders>((event, emit) async {
      _lastEvent = event;
      emit(StakeholdersLoading());
      final result = await StakeholdersService().updateStakeholders(
        event.id,
        event.data,
      );
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(StakeholdersFailed(error));
        }
      }, (success) async => emit(StakeholdersUpdated()));
    });

    on<DeleteStakeholders>((event, emit) async {
      _lastEvent = event;
      emit(StakeholdersLoading());
      final result = await StakeholdersService().deleteStakeholders(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(StakeholdersFailed(error));
        }
      }, (success) async => emit(StakeholdersDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
