part of 'dinas_bloc.dart';

sealed class DinasEvent extends Equatable {
  const DinasEvent();

  @override
  List<Object> get props => [];
}

class FetchDinas extends DinasEvent {}
