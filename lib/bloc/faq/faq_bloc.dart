import 'dart:async';

import 'package:arise/data/models/faq_form_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/faq_model.dart';
import '../../data/services/faq_service.dart';

part 'faq_event.dart';
part 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  FaqEvent? _lastEvent;
  FaqBloc({bool useConnectivityListener = true}) : super(FaqInitial()) {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none) {
        if (state is FaqFailed &&
            (state as FaqFailed).message == 'Connection' &&
            _lastEvent != null) {
          add(_lastEvent!);
        }
      }
    });

    on<FetchFaq>((event, emit) async {
      _lastEvent = event;
      emit(FaqLoading());
      final result = await FaqService().getFaqs();
      result.fold(
        (error) {
          if (error == 'Try Again') {
            add(_lastEvent!);
          } else {
            emit(FaqFailed(error));
          }
        },
        (data) {
          emit(FaqLoaded(data));
          _connectivitySubscription?.cancel();
          _connectivitySubscription = null;
        },
      );
    });

    on<CreateFaq>((event, emit) async {
      _lastEvent = event;
      emit(FaqLoading());
      final result = await FaqService().createFaq(event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(FaqFailed(error));
        }
      }, (success) async => emit(FaqCreated()));
    });

    on<UpdateFaq>((event, emit) async {
      _lastEvent = event;
      emit(FaqLoading());
      final result = await FaqService().updateFaq(event.id, event.data);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(FaqFailed(error));
        }
      }, (success) async => emit(FaqUpdated()));
    });

    on<DeleteFaq>((event, emit) async {
      emit(FaqLoading());
      final result = await FaqService().deleteFaq(event.id);
      result.fold((error) {
        if (error == 'Try Again') {
          add(_lastEvent!);
        } else {
          emit(FaqFailed(error));
        }
      }, (success) async => emit(FaqDeleted()));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
