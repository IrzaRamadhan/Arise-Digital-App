import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pinput/pinput.dart';

import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../helper/navigation_helper.dart';
import '../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/snackbar.dart';
import 'reset_password_page.dart';

class VerifikasiOtpPage extends StatefulWidget {
  final String email;
  const VerifikasiOtpPage({super.key, required this.email});

  @override
  State<VerifikasiOtpPage> createState() => _VerifikasiOtpPageState();
}

class _VerifikasiOtpPageState extends State<VerifikasiOtpPage> {
  late Timer _timer;
  int _remainingTime = 60;
  bool _canResend = false;
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _remainingTime = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 42,
      height: 42,
      textStyle: interBodyMediumMedium,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Color(0xFFC9C4C4), width: 1),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo_color_text.png',
                  width: 150,
                ),
              ),
              SizedBox(height: 46),
              Text('Masukkan Kode OTP', style: interHeadlineSemibold),
              SizedBox(height: 6),
              Text(
                'Kode OTP telah dikirimkan ke e-mail',
                style: interSmallRegular.copyWith(color: Color(0xFF6B6969)),
              ),
              Text(
                widget.email,
                style: interSmallSemibold.copyWith(color: Color(0xFF6B6969)),
              ),
              SizedBox(height: 24),
              BlocProvider(
                create: (context) => ForgotPasswordBloc(),
                child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is VerifyOtpSuccess) {
                      context.loaderOverlay.hide();
                      NavigationHelper.pushReplacement(
                        context,
                        ResetPasswordPage(
                          email: widget.email,
                          resetToken: state.resetToken,
                        ),
                      );
                    } else if (state is VerifyOtpFailed) {
                      context.loaderOverlay.hide();
                      showCustomSnackbar(
                        context: context,
                        message: state.message,
                        isSuccess: false,
                      );
                      otpController.clear();
                    }
                  },
                  builder: (context, state) {
                    return Pinput(
                      controller: otpController,
                      length: 6,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: primary1),
                        ),
                      ),
                      onCompleted: (pin) {
                        context.loaderOverlay.show();
                        context.read<ForgotPasswordBloc>().add(
                          VerifyOtp(widget.email, otpController.text),
                        );
                      },
                      autofillHints: const [],
                    );
                  },
                ),
              ),
              Spacer(),
              BlocProvider(
                create: (context) => ForgotPasswordBloc(),
                child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (context, state) {
                    if (state is ResendOtpSuccess) {
                      context.loaderOverlay.hide();
                      _startCountdown();
                      showCustomSnackbar(
                        context: context,
                        message: state.message,
                        isSuccess: true,
                      );
                    } else if (state is ResendOtpFailed) {
                      context.loaderOverlay.hide();
                      showCustomSnackbar(
                        context: context,
                        message: state.message,
                        isSuccess: false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomFilledButton(
                      title:
                          _canResend
                              ? 'Kirim Ulang'
                              : 'Kirim Ulang (${_remainingTime}s)',
                      useCheckInternet: true,
                      onPressed:
                          _canResend
                              ? () async {
                                context.loaderOverlay.show();
                                context.read<ForgotPasswordBloc>().add(
                                  ResendOtp(widget.email),
                                );
                              }
                              : () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
