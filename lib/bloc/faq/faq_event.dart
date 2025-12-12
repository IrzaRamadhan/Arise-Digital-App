part of 'faq_bloc.dart';

sealed class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}

class FetchFaq extends FaqEvent {}

class CreateFaq extends FaqEvent {
  final FaqFormModel data;
  const CreateFaq(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateFaq extends FaqEvent {
  final int id;
  final FaqFormModel data;
  const UpdateFaq({required this.id, required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteFaq extends FaqEvent {
  final int id;
  const DeleteFaq(this.id);

  @override
  List<Object> get props => [id];
}
