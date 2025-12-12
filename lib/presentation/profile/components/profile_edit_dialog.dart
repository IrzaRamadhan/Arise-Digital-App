import '../../../data/models/user_form_model.dart';
import '../../../data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/user/user_bloc.dart';
import '../../../helper/cek_internet_helper.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/forms.dart';
import '../../../widgets/snackbar.dart';

Future<bool?> showProfilEditDialog({
  required BuildContext context,
  required UserModel user,
}) {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: user.name);
  final usernameController = TextEditingController(text: user.username);
  final emailController = TextEditingController(text: user.email);
  return showDialog(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Edit Akun', style: interHeadlineSemibold),
                    SizedBox(height: 24),
                    CustomOutlineForm(
                      controller: nameController,
                      title: 'Nama lengkap',
                      placeholder: 'Masukkan nama lengkap',
                    ),
                    SizedBox(height: 16),
                    CustomOutlineForm(
                      controller: usernameController,
                      title: 'Username',
                      useTitle: true,
                      placeholder: 'Masukkan username',
                    ),
                    SizedBox(height: 16),
                    CustomOutlineForm(
                      controller: emailController,
                      title: 'Email',
                      placeholder: 'Masukkan e-mail',
                    ),
                    SizedBox(height: 16),
                    // CustomDropdown(
                    //   title: 'Dinas',
                    //   placeholder: 'Pilih dinas',
                    //   listItem: ['Dinas 1', 'Dinas 2', 'Dinas 3', 'Dinas 4'],
                    //   useTitle: false,
                    //   validator: (value) {
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 24),
                    BlocProvider(
                      create: (context) => UserBloc(),
                      child: BlocConsumer<UserBloc, UserState>(
                        listener: (context, state) {
                          if (state is UserUpdated) {
                            context.loaderOverlay.hide();
                            NavigationHelper.pop(context, true);
                          } else if (state is UserFailed) {
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
                            title: 'Simpan Perubahan',
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              if (formKey.currentState!.validate()) {
                                bool isConnected =
                                    await hasInternetConnection();
                                if (isConnected) {
                                  print(nameController.text);
                                  if (context.mounted) {
                                    context.loaderOverlay.show();
                                    context.read<UserBloc>().add(
                                      UpdateUser(
                                        UserFormModel(
                                          name: nameController.text,
                                          email: emailController.text,
                                          username: usernameController.text,
                                        ),
                                        null,
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    showCustomSnackbar(
                                      context: context,
                                      message: 'Periksa Koneksi Internet Anda',
                                      isSuccess: false,
                                    );
                                  }
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    CustomOutlineButton(
                      title: 'Batalkan Perubahan',
                      textColor: Color(0xFFF22121),
                      onPressed: () {
                        NavigationHelper.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
