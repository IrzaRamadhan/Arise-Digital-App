import 'package:arise/data/models/kategori_risiko_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/kategori_risiko/kategori_risiko_bloc.dart';
import '../../../../../data/models/kategori_risiko_form_model.dart';
import '../../../../../helper/cek_internet_helper.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class KategoriRisikoEditPage extends StatefulWidget {
  final KategoriRisikoModel kategoriRisiko;
  const KategoriRisikoEditPage({super.key, required this.kategoriRisiko});

  @override
  State<KategoriRisikoEditPage> createState() => _KategoriRisikoEditPageState();
}

class _KategoriRisikoEditPageState extends State<KategoriRisikoEditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final seleraPositifController = TextEditingController();
  final seleraNegatifController = TextEditingController();
  final deskripsiController = TextEditingController();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    namaController.text = widget.kategoriRisiko.nama;
    seleraPositifController.text =
        widget.kategoriRisiko.seleraPositif.toString();
    seleraNegatifController.text =
        widget.kategoriRisiko.seleraNegatif.toString();
    deskripsiController.text = widget.kategoriRisiko.deskripsi;
    isChecked = widget.kategoriRisiko.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Kategori Risiko')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama Kategori',
              placeholder: 'Masukkan nama kategori',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: seleraPositifController,
              title: 'Selera Positif',
              placeholder: 'Masukkan selera positif',
              isNumber: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: seleraNegatifController,
              title: 'Selera Negatif',
              placeholder: 'Masukkan selera negatif',
              isNumber: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: deskripsiController,
              title: 'Deskripsi',
              placeholder: 'Masukkan deskripsi',
              minLines: 3,
              maxLines: 5,
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
                Text('Status Aktif', style: interBodySmallMedium),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, -8),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: BlocProvider(
            create:
                (context) => KategoriRisikoBloc(useConnectivityListener: false),
            child: BlocConsumer<KategoriRisikoBloc, KategoriRisikoState>(
              listener: (context, state) {
                if (state is KategoriRisikoUpdated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is KategoriRisikoFailed) {
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
                          context.read<KategoriRisikoBloc>().add(
                            UpdateKategoriRisiko(
                              id: widget.kategoriRisiko.id,
                              data: KategoriRisikoFormModel(
                                nama: namaController.text,
                                deskripsi: deskripsiController.text,
                                seleraPositif: int.parse(
                                  seleraPositifController.text,
                                ),
                                seleraNegatif: int.parse(
                                  seleraPositifController.text,
                                ),
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
