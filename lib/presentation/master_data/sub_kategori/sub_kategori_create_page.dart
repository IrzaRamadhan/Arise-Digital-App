import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/sub_kategori/sub_kategori_bloc.dart';
import '../../../data/models/sub_kategori_form_model.dart';
import '../../../helper/cek_internet_helper.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/forms.dart';
import '../../../widgets/snackbar.dart';

class SubKategoriCreatePage extends StatefulWidget {
  const SubKategoriCreatePage({super.key});

  @override
  State<SubKategoriCreatePage> createState() => _SubKategoriCreatePageState();
}

class _SubKategoriCreatePageState extends State<SubKategoriCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Sub Kategori')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama Sub Kategori',
              placeholder: 'Contoh: PT Laptop',
              badgeRequired: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => SubKategoriBloc(),
            child: BlocConsumer<SubKategoriBloc, SubKategoriState>(
              listener: (context, state) {
                if (state is SubKategoriCreated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is SubKategoriFailed) {
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
                  title: 'Simpan Sub Kategori',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      bool isConnected = await hasInternetConnection();
                      if (isConnected) {
                        if (context.mounted) {
                          context.loaderOverlay.show();
                          context.read<SubKategoriBloc>().add(
                            CreateSubKategori(
                              SubKategoriFormModel(nama: namaController.text),
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
        ),
      ),
    );
  }
}
