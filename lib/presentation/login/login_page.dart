import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../helper/navigation_helper.dart';
import '../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/forms.dart';
import '../../widgets/snackbar.dart';
import '../base/base_page.dart';
import '../lupa_password/lupa_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
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
                Text('Masuk', style: interHeadlineSemibold),
                SizedBox(height: 6),
                Text(
                  'Transparansi Aset untuk Pemerintahan yang Akuntabel.',
                  style: interSmallRegular.copyWith(color: Color(0xFF6B6969)),
                ),
                SizedBox(height: 24),
                CustomOutlineForm(
                  controller: usernameController,
                  title: 'Username',
                  placeholder: 'Masukkan Username',
                  useTitle: false,
                ),
                SizedBox(height: 16),
                CustomOutlineForm(
                  controller: passwordController,
                  title: 'Kata Sandi',
                  placeholder: 'Masukkan Kata Sandi',
                  isPassword: true,
                  useTitle: false,
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      NavigationHelper.push(context, LupaPasswordPage());
                    },
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: interSmallMedium.copyWith(
                        color: Color(0xFF2F3031),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      context.loaderOverlay.hide();
                      NavigationHelper.pushAndRemoveUntil(
                        context,
                        BlocProvider.value(
                          value: context.read<AuthBloc>(),
                          child: BasePage(),
                        ),
                      );
                    } else if (state is AuthFailed) {
                      context.loaderOverlay.hide();
                      showCustomSnackbar(
                        context: context,
                        message: state.e,
                        isSuccess: false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomFilledButton(
                      title: 'Masuk',
                      useCheckInternet: true,
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState!.validate()) {
                          context.loaderOverlay.show();
                          context.read<AuthBloc>().add(
                            AuthLogin(
                              email: usernameController.text,
                              password: passwordController.text,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
