import 'package:arise/data/models/informasi_umum_model.dart';
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

class InformasiUmumEditPage extends StatefulWidget {
  final InformasiUmumModel informasiUmum;
  const InformasiUmumEditPage({super.key, required this.informasiUmum});

  @override
  State<InformasiUmumEditPage> createState() => _InformasiUmumEditPageState();
}

class _InformasiUmumEditPageState extends State<InformasiUmumEditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final tugasController = TextEditingController();
  final fungsiController = TextEditingController();
  final periodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaController.text = widget.informasiUmum.namaUprSpbe;
    tugasController.text = widget.informasiUmum.tugasUprSpbe ?? '';
    fungsiController.text = widget.informasiUmum.fungsiUprSpbe ?? '';
    periodeController.text = widget.informasiUmum.periodeWaktu ?? '';
  }

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
                if (state is InformasiUmumUpdated) {
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
                            UpdateInformasiUmum(
                              id: widget.informasiUmum.id,
                              data: InformasiUmumFormModel(
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
