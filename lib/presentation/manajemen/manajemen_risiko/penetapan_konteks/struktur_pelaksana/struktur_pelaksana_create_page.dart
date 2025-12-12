import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/struktur_pelaksana/struktur_pelaksana_bloc.dart';
import '../../../../../data/models/struktur_pelaksana_form_model.dart';
import '../../../../../helper/cek_internet_helper.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/dropdowns.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class StrukturPelaksanaCreatePage extends StatefulWidget {
  const StrukturPelaksanaCreatePage({super.key});

  @override
  State<StrukturPelaksanaCreatePage> createState() =>
      _StrukturPelaksanaCreatePageState();
}

class _StrukturPelaksanaCreatePageState
    extends State<StrukturPelaksanaCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final jabatanController = TextEditingController();
  String? selectedPeran;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Struktur Pelaksana')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama',
              placeholder: 'Masukkan nama',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomDropdown(
              selectedValue: selectedPeran,
              title: 'Peran',
              placeholder: 'Pilih peran',
              listItem: [
                'Pemilik Risiko',
                'Pengelola Risiko',
                'Tim Manajemen Risiko',
                'Auditor Internal',
              ],
              onChanged: (value) {
                selectedPeran = value;
              },
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: jabatanController,
              title: 'Jabatan',
              placeholder: 'Masukkan jabatan',
              badgeRequired: true,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text('Aktif', style: interBodySmallMedium),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => StrukturPelaksanaBloc(),
            child: BlocConsumer<StrukturPelaksanaBloc, StrukturPelaksanaState>(
              listener: (context, state) {
                if (state is StrukturPelaksanaCreated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is StrukturPelaksanaFailed) {
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
                          context.read<StrukturPelaksanaBloc>().add(
                            CreateStrukturPelaksana(
                              StrukturPelaksanaFormModel(
                                nama: namaController.text,
                                peran: selectedPeran!,
                                jabatan: jabatanController.text,
                                isActive: isChecked,
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
