part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResendOtp extends ForgotPasswordEvent {
  final String email;
  const ResendOtp(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyOtp extends ForgotPasswordEvent {
  final String email;
  final String otp;
  const VerifyOtp(this.email, this.otp);

  @override
  List<Object> get props => [email, otp];
}

class ResetPassword extends ForgotPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  const ResetPassword(
    this.email,
    this.otp,
    this.newPassword,
    this.confirmPassword,
  );

  @override
  List<Object> get props => [email, otp, newPassword, confirmPassword];
}
