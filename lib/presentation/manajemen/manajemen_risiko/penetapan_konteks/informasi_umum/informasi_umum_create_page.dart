import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/informasi_umum/informasi_umum_bloc.dart';
import '../../../../../data/models/informasi_umum_form_model.dart';
import '../../../../../helper/cek_internet_helper.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class InformasiUmumCreatePage extends StatefulWidget {
  const InformasiUmumCreatePage({super.key});

  @override
  State<InformasiUmumCreatePage> createState() =>
      _InformasiUmumCreatePageState();
}

class _InformasiUmumCreatePageState extends State<InformasiUmumCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final tugasController = TextEditingController();
  final fungsiController = TextEditingController();
  final periodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Informasi Umum')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama UPR',
              placeholder: 'Masukkan nama UPR',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: tugasController,
              title: 'Tugas UPR',
              placeholder: 'Masukkan tugas UPR',
              minLines: 3,
              maxLines: 5,
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: fungsiController,
              title: 'Fungsi UPR',
              placeholder: 'Masukkan fungsi UPR',
              minLines: 3,
              maxLines: 5,
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: periodeController,
              title: 'Priode Waktu',
              placeholder: 'Masukkan periode waktu.',
              minLines: 3,
              maxLines: 5,
              badgeRequired: true,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => InformasiUmumBloc(),
            child: BlocConsumer<InformasiUmumBloc, InformasiUmumState>(
              listener: (context, state) {
                if (state is InformasiUmumCreated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is InformasiUmumFailed) {
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
                  title: 'Simpan',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      bool isConnected = await hasInternetConnection();
                      if (isConnected) {
                        if (context.mounted) {
                          context.loaderOverlay.show();
                          context.read<InformasiUmumBloc>().add(
                            CreateInformasiUmum(
                              InformasiUmumFormModel(
                                namaUprSpbe: namaController.text,
                                tugasUprSpbe: tugasController.text,
                                fungsiUprSpbe: fungsiController.text,
                                periodeWaktu: periodeController.text,
                              ),
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
