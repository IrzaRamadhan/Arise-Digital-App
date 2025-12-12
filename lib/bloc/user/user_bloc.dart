import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_form_model.dart';
import '../../data/models/user_model.dart';
import '../../data/services/user_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  UserEvent? _lastEvent;
  UserBloc() : super(UserInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none && state is UserFailed) {
        if ((state as UserFailed).message == 'Connection') {
          add(FetchUser());
        }
      }
    });

    on<FetchUser>((event, emit) async {
      _lastEvent = event;
      emit(UserLoading());
      final result = await UserService().getUser();
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(UserFailed(error));
        }
      }, (data) => emit(UserLoaded(data)));
    });

    on<UpdateUser>((event, emit) async {
      _lastEvent = event;
      emit(UserLoading());
      final result = await UserService().updateUser(event.data, event.img);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(UserFailed(error));
        }
      }, (data) => emit(UserUpdated()));
    });

    on<LoadUser>((event, emit) {
      emit(UserLoaded(event.user));
    });

    on<LogoutUser>((event, emit) {
      emit(UserInitial());
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
