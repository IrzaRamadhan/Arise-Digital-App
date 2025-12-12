import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../helper/navigation_helper.dart';
import '../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/forms.dart';
import '../../widgets/snackbar.dart';
import 'success_reset_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String resetToken;
  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                Text('Buat Password Baru', style: interHeadlineSemibold),
                const SizedBox(height: 24),
                CustomOutlineForm(
                  controller: newPasswordController,
                  title: 'Password',
                  placeholder: 'Masukan password anda',
                  isPassword: true,
                  useTitle: false,
                ),
                const SizedBox(height: 16),
                CustomOutlineForm(
                  controller: confirmPasswordController,
                  title: 'Konfirmasi Password',
                  placeholder: 'Masukan password anda',
                  isPassword: true,
                  useTitle: false,
                ),

                Spacer(),
                BlocProvider(
                  create: (context) => ForgotPasswordBloc(),
                  child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state is ResetPasswordSuccess) {
                        context.loaderOverlay.hide();
                        NavigationHelper.pushAndRemoveUntil(
                          context,
                          SuccessResetPage(),
                        );
                        showCustomSnackbar(
                          context: context,
                          message: state.message,
                          isSuccess: true,
                        );
                      } else if (state is ResetPasswordFailed) {
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
                        title: 'Submit',
                        useCheckInternet: true,
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formKey.currentState!.validate()) {
                            context.loaderOverlay.show();
                            context.read<ForgotPasswordBloc>().add(
                              ResetPassword(
                                widget.email,
                                widget.resetToken,
                                newPasswordController.text,
                                confirmPasswordController.text,
                              ),
                            );
                          }
                        },
                      );
                    },
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
