import 'package:arise/data/models/level_dampak_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/level_dampak/level_dampak_bloc.dart';
import '../../../../../data/models/level_dampak_form_model.dart';
import '../../../../../helper/cek_internet_helper.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/dropdowns.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class LevelDampakEditPage extends StatefulWidget {
  final LevelDampakModel levelDampak;
  const LevelDampakEditPage({super.key, required this.levelDampak});

  @override
  State<LevelDampakEditPage> createState() => _LevelDampakEditPageState();
}

class _LevelDampakEditPageState extends State<LevelDampakEditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  String? selectedNilai;
  final deskripsiController = TextEditingController();
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    namaController.text = widget.levelDampak.nama;
    selectedNilai = widget.levelDampak.nilai.toString();
    deskripsiController.text = widget.levelDampak.deskripsi;
    isChecked = widget.levelDampak.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Level Dampak')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama Level',
              placeholder: 'Masukkan nama level',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomDropdown(
              selectedValue: selectedNilai,
              title: 'Nilai',
              placeholder: 'Pilih nilai',
              listItem: ['1', '2', '3', '4', '5'],
              onChanged: (value) {
                selectedNilai = value;
              },
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: deskripsiController,
              title: 'Deskripsi',
              placeholder: 'Deskripsi deskripsi',
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
                (context) => LevelDampakBloc(useConnectivityListener: false),
            child: BlocConsumer<LevelDampakBloc, LevelDampakState>(
              listener: (context, state) {
                if (state is LevelDampakUpdated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is LevelDampakFailed) {
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
                          context.read<LevelDampakBloc>().add(
                            UpdateLevelDampak(
                              id: widget.levelDampak.id,
                              data: LevelDampakFormModel(
                                nama: namaController.text,
                                deskripsi: deskripsiController.text,
                                nilai: int.parse(selectedNilai!),
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
