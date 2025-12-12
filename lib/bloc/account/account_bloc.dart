import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/account_create_form_model.dart';
import '../../data/models/account_model.dart';
import '../../data/models/account_update_form_model.dart';
import '../../data/services/account_service.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  AccountEvent? _lastEvent;
  AccountBloc({bool useConnectivityListener = true}) : super(AccountInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is AccountFailed &&
            (state as AccountFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchAccount>((event, emit) async {
      _lastEvent = event;
      emit(AccountLoading());
      final result = await AccountService().getAccount(event.id);
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(AccountFailed(error));
          }
        },
        (data) {
          emit(AccountLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateAccount>((event, emit) async {
      _lastEvent = event;
      emit(AccountLoading());
      final result = await AccountService().createAccount(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AccountFailed(error));
        }
      }, (success) => emit(AccountCreated()));
    });

    on<UpdateAccount>((event, emit) async {
      _lastEvent = event;
      emit(AccountLoading());
      final result = await AccountService().updateAccount(event.id, event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AccountFailed(error));
        }
      }, (success) => emit(AccountUpdated()));
    });

    on<DeleteAccount>((event, emit) async {
      emit(AccountLoading());
      final result = await AccountService().deleteAccount(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(AccountFailed(error));
        }
      }, (success) => emit(AccountDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
