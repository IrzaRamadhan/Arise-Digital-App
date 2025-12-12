import 'package:arise/data/models/sasaran_risiko_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/sasaran_risiko/sasaran_risiko_bloc.dart';
import '../../../../../data/models/sasaran_risiko_form_model.dart';
import '../../../../../helper/cek_internet_helper.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class SasaranRisikoEditPage extends StatefulWidget {
  final SasaranRisikoModel sasaranRisiko;
  const SasaranRisikoEditPage({super.key, required this.sasaranRisiko});

  @override
  State<SasaranRisikoEditPage> createState() => _SasaranRisikoEditPageState();
}

class _SasaranRisikoEditPageState extends State<SasaranRisikoEditPage> {
  final _formKey = GlobalKey<FormState>();
  final sasaranUprController = TextEditingController();
  final sasaranController = TextEditingController();

  List<IndikatorTargetKinerjaFormData> indikatorTargerForms = [];

  @override
  void initState() {
    super.initState();
    sasaranUprController.text = widget.sasaranRisiko.sasaranUpr;
    sasaranController.text = widget.sasaranRisiko.sasaran ?? '';

    for (var item in widget.sasaranRisiko.indikatorTargets) {
      final formData = IndikatorTargetKinerjaFormData();

      formData.indikatorController.text = item.indikatorKinerja;
      formData.targetController.text = item.targetKinerja;

      indikatorTargerForms.add(formData);
    }

    if (indikatorTargerForms.isEmpty) {
      indikatorTargerForms.add(IndikatorTargetKinerjaFormData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Sasaran Risiko')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: sasaranUprController,
              title: 'Sasaran UPR',
              placeholder: 'masukkan sasaran UPR',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: sasaranController,
              title: 'Sasaran',
              placeholder: 'Masukkan sasaran risiko',
              minLines: 3,
              maxLines: 5,
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Indikator & Target Kinerja',
              style: interBodyMediumBold.copyWith(color: primary1),
            ),
            SizedBox(height: 16),
            ...indikatorTargerForms.asMap().entries.map((entry) {
              final index = entry.key;
              final form = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEAE9EA)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomOutlineForm(
                      controller: form.indikatorController,
                      title: 'Indikator Kinerja',
                      placeholder: 'Contoh: Indeks Nasional',
                      badgeRequired: true,
                    ),
                    CustomOutlineForm(
                      controller: form.targetController,
                      title: 'Target Kinerja',
                      placeholder: 'Contoh: 2,1',
                      badgeRequired: true,
                    ),
                    if (indikatorTargerForms.length > 1)
                      CustomFilledButton(
                        title: 'Hapus',
                        width: 80,
                        height: 40,
                        backgroundColor: danger600,
                        onPressed: () {
                          setState(() {
                            indikatorTargerForms.removeAt(index);
                          });
                        },
                      ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomOutlineButton(
                title: 'Tambah indikator & target kinerja',
                height: 32,
                width: 230,
                fontSize: 12,
                textColor: Color(0xFFF58612),
                onPressed: () {
                  setState(() {
                    indikatorTargerForms.add(IndikatorTargetKinerjaFormData());
                  });
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => SasaranRisikoBloc(),
            child: BlocConsumer<SasaranRisikoBloc, SasaranRisikoState>(
              listener: (context, state) {
                if (state is SasaranRisikoUpdated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is SasaranRisikoFailed) {
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
                          List<SasaranIndikatorFormModel> sasaranIndikatorList =
                              indikatorTargerForms.map((item) {
                                return SasaranIndikatorFormModel(
                                  indikatorKinerja:
                                      item.indikatorController.text,
                                  targetKinerja: item.targetController.text,
                                );
                              }).toList();

                          context.read<SasaranRisikoBloc>().add(
                            UpdateSasaranRisiko(
                              id: widget.sasaranRisiko.id,
                              data: SasaranRisikoFormModel(
                                sasaranUpr: sasaranUprController.text,
                                sasaran: sasaranController.text,
                                indikatorTargets: sasaranIndikatorList,
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

class IndikatorTargetKinerjaFormData {
  TextEditingController indikatorController = TextEditingController();
  TextEditingController targetController = TextEditingController();
}
