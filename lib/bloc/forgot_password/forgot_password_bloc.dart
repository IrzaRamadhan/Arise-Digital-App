import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/forgot_password_service.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ResendOtp>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await ForgotPasswordService().resendOtp(
        email: event.email,
      );
      result.fold(
        (error) => emit(ResendOtpFailed(error)),
        (data) => emit(ResendOtpSuccess(data)),
      );
    });

    on<VerifyOtp>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await ForgotPasswordService().verifyOtp(
        email: event.email,
        otp: event.otp,
      );
      result.fold(
        (error) => emit(VerifyOtpFailed(error)),
        (data) => emit(VerifyOtpSuccess(data)),
      );
    });

    on<ResetPassword>((event, emit) async {
      emit(ForgotPasswordLoading());
      final result = await ForgotPasswordService().resetPassword(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      );
      result.fold(
        (error) => emit(ResetPasswordFailed(error)),
        (data) => emit(ResetPasswordSuccess(data)),
      );
    });
  }
}
