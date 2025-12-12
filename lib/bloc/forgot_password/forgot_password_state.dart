part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ResendOtpSuccess extends ForgotPasswordState {
  final String message;
  const ResendOtpSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class ResendOtpFailed extends ForgotPasswordState {
  final String message;
  const ResendOtpFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class VerifyOtpSuccess extends ForgotPasswordState {
  final String resetToken;
  const VerifyOtpSuccess(this.resetToken);

  @override
  List<Object> get props => [resetToken];
}

final class VerifyOtpFailed extends ForgotPasswordState {
  final String message;
  const VerifyOtpFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class ResetPasswordSuccess extends ForgotPasswordState {
  final String message;
  const ResetPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class ResetPasswordFailed extends ForgotPasswordState {
  final String message;
  const ResetPasswordFailed(this.message);

  @override
  List<Object> get props => [message];
}
