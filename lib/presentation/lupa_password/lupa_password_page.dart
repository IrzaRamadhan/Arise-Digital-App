import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../helper/navigation_helper.dart';
import '../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/forms.dart';
import '../../widgets/snackbar.dart';
import 'verifikasi_otp_page.dart';

class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                Text('Lupa Password', style: interHeadlineSemibold),
                SizedBox(height: 6),
                Text(
                  'Masukkan email Anda untuk menerima kode OTP',
                  style: interSmallRegular.copyWith(color: Color(0xFF6B6969)),
                ),
                SizedBox(height: 24),
                CustomOutlineForm(
                  controller: emailController,
                  title: 'Email',
                  placeholder: 'Masukkan e-mail',
                  useTitle: false,
                ),
                Spacer(),
                BlocProvider(
                  create: (context) => ForgotPasswordBloc(),
                  child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ResendOtpSuccess) {
                        context.loaderOverlay.hide();
                        context.loaderOverlay.hide();
                        NavigationHelper.pushReplacement(
                          context,
                          VerifikasiOtpPage(email: emailController.text),
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
                        title: 'Kirim Kode OTP',
                        useCheckInternet: true,
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formKey.currentState!.validate()) {
                            context.loaderOverlay.show();
                            context.read<ForgotPasswordBloc>().add(
                              ResendOtp(emailController.text),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: 'Ingat kata sandi kamu? ',
                      style: interBodySmallRegular.copyWith(
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Kembali Login',
                          style: interBodySmallSemibold.copyWith(
                            color: Color(0xFFE21B1B),
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  NavigationHelper.pop(context);
                                },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
