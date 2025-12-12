part of 'faq_bloc.dart';

sealed class FaqState extends Equatable {
  const FaqState();

  @override
  List<Object> get props => [];
}

final class FaqInitial extends FaqState {}

final class FaqLoading extends FaqState {}

final class FaqFailed extends FaqState {
  final String message;
  const FaqFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class FaqLoaded extends FaqState {
  final List<FaqModel> faqs;
  const FaqLoaded(this.faqs);

  @override
  List<Object> get props => [faqs];
}

final class FaqCreated extends FaqState {}

final class FaqUpdated extends FaqState {}

final class FaqDeleted extends FaqState {}
