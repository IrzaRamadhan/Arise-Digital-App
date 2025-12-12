import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/kompetensi/kompetensi_bloc.dart';
import '../../../../data/models/kompetensi_model.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/forms.dart';
import '../../../../widgets/upload.dart';

Future<bool?> showSertifikatAddDialog({required BuildContext context}) {
  final formKey = GlobalKey<FormState>();
  int? selectedKompetensi;
  final namaSertifController = TextEditingController();
  final fileController = TextEditingController();
  final pathController = TextEditingController();
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
                    Text(
                      'Upload Sertifikat Kompetensi',
                      style: interHeadlineSemibold,
                    ),
                    SizedBox(height: 24),
                    // Kompetensi
                    BlocBuilder<KompetensiBloc, KompetensiState>(
                      builder: (context, state) {
                        List<KompetensiModel> listKompetensi = [];
                        if (state is KompetensiLoaded) {
                          listKompetensi = state.listKompetensi;
                        }
                        return CustomDropdownGeneric<KompetensiModel>(
                          title: 'Kompetensi',
                          badgeRequired: true,
                          selectedItem:
                              selectedKompetensi != null
                                  ? listKompetensi.firstWhere(
                                    (d) => d.id == selectedKompetensi,
                                    orElse: () => listKompetensi.first,
                                  )
                                  : null,
                          onChanged: (value) async {
                            if (value != null) {
                              selectedKompetensi = value.id;
                            }
                          },
                          items: listKompetensi,
                          itemAsString: (d) => d.nama,
                          compareFn: (a, b) => a.id == b.id,
                          hintText: 'Pilih kompetensi',
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    // Nama Sertifikat
                    CustomOutlineForm(
                      controller: namaSertifController,
                      title: 'Nama Sertifikat',
                      placeholder: 'Misal: CompTIA Security+',
                      badgeRequired: true,
                    ),
                    SizedBox(height: 16),

                    // Lampiran
                    FilePickerFormField(
                      context: context,
                      title: 'File Sertifikat',
                      placeholder: 'File Sertifikat',
                      controllerFile: fileController,
                      controllerPathFile: pathController,
                      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    // BlocProvider(
                    //   create: (context) => UserBloc(),
                    //   child: BlocConsumer<UserBloc, UserState>(
                    //     listener: (context, state) {
                    //       if (state is UserUpdated) {
                    //         context.loaderOverlay.hide();
                    //         NavigationHelper.pop(context, true);
                    //       } else if (state is UserFailed) {
                    //         context.loaderOverlay.hide();
                    //         showCustomSnackbar(
                    //           context: context,
                    //           message: state.message,
                    //           isSuccess: false,
                    //         );
                    //       }
                    //     },
                    //     builder: (context, state) {
                    //       return CustomFilledButton(
                    //         title: 'Simpan Perubahan',
                    //         onPressed: () async {
                    //           FocusScope.of(context).requestFocus(FocusNode());
                    //           if (formKey.currentState!.validate()) {
                    //             bool isConnected =
                    //                 await hasInternetConnection();
                    //             if (isConnected) {
                    //               print(nameController.text);
                    //               if (context.mounted) {
                    //                 context.loaderOverlay.show();
                    //                 context.read<UserBloc>().add(
                    //                   UpdateUser(
                    //                     UserFormModel(
                    //                       name: nameController.text,
                    //                       email: emailController.text,
                    //                       username: usernameController.text,
                    //                     ),
                    //                     null,
                    //                   ),
                    //                 );
                    //               }
                    //             } else {
                    //               if (context.mounted) {
                    //                 showCustomSnackbar(
                    //                   context: context,
                    //                   message: 'Periksa Koneksi Internet Anda',
                    //                   isSuccess: false,
                    //                 );
                    //               }
                    //             }
                    //           }
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                    CustomFilledButton(
                      title: 'Upload Sertifikat',
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (formKey.currentState!.validate()) {}
                      },
                    ),
                    SizedBox(height: 16),
                    CustomOutlineButton(
                      title: 'Batal',
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
