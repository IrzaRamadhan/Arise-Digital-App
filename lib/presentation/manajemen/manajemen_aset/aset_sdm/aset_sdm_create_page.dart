import 'package:arise/data/models/asset_sdm_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../bloc/area_dampak/area_dampak_bloc.dart';
import '../../../../bloc/asset/asset_bloc.dart';
import '../../../../bloc/dinas/dinas_bloc.dart';
import '../../../../bloc/jabatan/jabatan_bloc.dart';
import '../../../../bloc/kategori_risiko/kategori_risiko_bloc.dart';
import '../../../../bloc/kompetensi/kompetensi_bloc.dart';
import '../../../../bloc/level_dampak/level_dampak_bloc.dart';
import '../../../../bloc/unit_kerja/unit_kerja_bloc.dart';
import '../../../../data/models/area_dampak_model.dart';
import '../../../../data/models/calculate_model.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../data/models/jabatan_model.dart';
import '../../../../data/models/kategori_risiko_model.dart';
import '../../../../data/models/kompetensi_model.dart';
import '../../../../data/models/level_dampak_model.dart';
import '../../../../data/models/unit_kerja_model.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/services/calculate_service.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/shared_method.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/forms.dart';
import '../../../../widgets/snackbar.dart';
import '../../../../widgets/upload.dart';

class AsetSdmCreatePage extends StatefulWidget {
  const AsetSdmCreatePage({super.key});

  @override
  State<AsetSdmCreatePage> createState() => _AsetSdmCreatePageState();
}

class _AsetSdmCreatePageState extends State<AsetSdmCreatePage> {
  final _formKey = GlobalKey<FormState>();

  // Informasi Dasar Aset
  final namaController = TextEditingController();
  String? selectedKategori;
  int? selectedDinas = AuthService().getDinasId();
  UnitKerjaModel? selectedUnitKerja;
  String selectedPeriodePemeliharaan = '12 Bulan';

  // Informasi SDM
  final nipController = TextEditingController();
  int? selectedJabatan;
  final catatanController = TextEditingController();

  // Sertifikat SDM
  List<SertifikatFormData> sertifikatForms = [];

  // Identifikasi Risiko
  String? selectedJenis;
  int? selectedKategoriRisiko;
  final kejadianController = TextEditingController();
  final penyebabController = TextEditingController();
  AreaDampakModel? selectedAreaDampak;
  LevelDampakModel? selectedLevelDampak;
  final levelKemungkinanController = TextEditingController(text: '5');
  final besaranRisikoController = TextEditingController();
  LikelihoodCalculateModel? likelihoodResult;
  RiskCalculateModel? riskResult;

  @override
  void initState() {
    super.initState();
    sertifikatForms.add(SertifikatFormData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Aset SDM')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informasi Dasar Aset',
                style: interBodyMediumBold.copyWith(color: primary1),
              ),
              SizedBox(height: 16),
              // Nama Aset
              CustomOutlineForm(
                controller: namaController,
                title: 'Nama Aset',
                placeholder: 'Masukkan nama aset SDM',
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Kategori
              CustomDropdown(
                selectedValue: selectedKategori,
                title: 'Kategori',
                placeholder: 'Pilih kategori aset',
                listItem: ['TI', 'Non-TI'],
                badgeRequired: true,
                onChanged: (value) {
                  selectedKategori = value;
                },
              ),
              SizedBox(height: 16),
              // Dinas
              BlocBuilder<DinasBloc, DinasState>(
                builder: (context, state) {
                  List<DinasModel> listDinas = [];
                  if (state is DinasLoaded) {
                    listDinas = state.listDinas;
                  }
                  return CustomDropdownGeneric<DinasModel>(
                    title: 'Dinas',
                    badgeRequired: true,
                    enabled: AuthService().getDinasId() == null,
                    selectedItem:
                        selectedDinas != null
                            ? listDinas.firstWhere(
                              (d) => d.id == selectedDinas,
                              orElse: () => listDinas.first,
                            )
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDinas = value.id;
                          selectedUnitKerja = null;
                        });
                        context.read<UnitKerjaBloc>().add(
                          FetchUnitKerja(dinasId: value.id),
                        );
                      }
                    },
                    items: listDinas,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a.id == b.id,
                    hintText: 'Pilih dinas',
                  );
                },
              ),

              SizedBox(height: 16),
              // Unit Kerja
              BlocBuilder<UnitKerjaBloc, UnitKerjaState>(
                builder: (context, state) {
                  List<UnitKerjaModel> listUnitKerja = [];
                  if (state is UnitKerjaLoaded) {
                    listUnitKerja = state.listUnitKerja;
                  }
                  return CustomDropdownGeneric<UnitKerjaModel>(
                    key: ValueKey('unit_kerja_$selectedDinas'),
                    title: 'Unit Kerja',
                    badgeRequired: true,
                    selectedItem: selectedUnitKerja,
                    onChanged: (value) {
                      if (value != null) {
                        selectedUnitKerja = value;
                      }
                    },
                    items: listUnitKerja,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a.id == b.id,
                    hintText: 'Pilih unit kerja',
                  );
                },
              ),
              SizedBox(height: 16),

              // Periode Perolehan
              CustomDropdown(
                selectedValue: selectedPeriodePemeliharaan,
                title: 'Periode Pemeliharaan',
                placeholder: 'Pilih periode pemeliharaan',
                listItem: ['12 Bulan'],
                badgeRequired: true,
                readOnly: true,
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Informasi SDM',
                style: interBodyMediumBold.copyWith(color: primary1),
              ),
              SizedBox(height: 16),
              // NIP
              CustomOutlineForm(
                controller: nipController,
                title: 'NIP',
                placeholder: 'Masukkan NIP',
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Jabatan
              BlocBuilder<JabatanBloc, JabatanState>(
                builder: (context, state) {
                  List<JabatanModel> listJabatan = [];
                  if (state is JabatanLoaded) {
                    listJabatan = state.listJabatan;
                  }
                  return CustomDropdownGeneric<JabatanModel>(
                    title: 'Jabatan',
                    badgeRequired: true,
                    selectedItem:
                        selectedJabatan != null
                            ? listJabatan.firstWhere(
                              (d) => d.id == selectedJabatan,
                              orElse: () => listJabatan.first,
                            )
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedJabatan = value.id;
                        });
                      }
                    },
                    items: listJabatan,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a.id == b.id,
                    hintText: 'Pilih jabatan',
                  );
                },
              ),
              SizedBox(height: 16),
              // Catatan
              CustomOutlineForm(
                controller: catatanController,
                title: 'Catatan',
                placeholder: 'Masukkan catatan tambahan',
                minLines: 3,
                maxLines: 3,
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Sertifikat SDM',
                style: interBodyMediumBold.copyWith(color: primary1),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: info100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: info500),
                ),
                child: Text(
                  ' Tambahkan sertifikat yang dimiliki oleh SDM ini. Sertifikat akan membantu dalam identifikasi kompetensi dan penilaian risiko.',
                  style: interSmallMedium.copyWith(color: info500),
                ),
              ),
              SizedBox(height: 16),

              ...sertifikatForms.map((form) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEAE9EA)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
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
                            enabled: selectedJabatan != null,
                            selectedItem:
                                form.selectedKompetensi != null
                                    ? listKompetensi.firstWhere(
                                      (d) => d.id == form.selectedKompetensi,
                                      orElse: () => listKompetensi.first,
                                    )
                                    : null,
                            onChanged: (value) async {
                              if (value != null) {
                                form.selectedKompetensi = value.id;
                              }
                              final result = await CalculateService()
                                  .calculateLikelihood(
                                    jabatanId: selectedJabatan!,
                                    kompetensiIds:
                                        sertifikatForms
                                            .map((e) => e.selectedKompetensi!)
                                            .toList(),
                                  );

                              result.fold(
                                (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                },
                                (data) {
                                  setState(() {
                                    likelihoodResult = data;
                                    levelKemungkinanController.text =
                                        likelihoodResult!.likelihood.toString();
                                  });
                                },
                              );
                            },
                            items: listKompetensi,
                            itemAsString: (d) => d.nama,
                            compareFn: (a, b) => a.id == b.id,
                            hintText:
                                selectedJabatan == null
                                    ? 'Pilih jabatan dahulu'
                                    : 'Pilih kompetensi',
                          );
                        },
                      ),
                      SizedBox(height: 16),

                      // Nama Sertifikat
                      CustomOutlineForm(
                        controller: form.namaSertifController,
                        title: 'Nama Sertifikat',
                        placeholder: 'Misal: CompTIA Security+',
                        badgeRequired: true,
                      ),
                      SizedBox(height: 16),

                      // Lampiran
                      FilePickerFormField(
                        context: context,
                        title: 'Lampiran File',
                        placeholder: 'Lampiran file',
                        controllerFile: form.lampiranFileController,
                        controllerPathFile: form.lampiranPathController,
                        allowedExtensions: ['pdf'],
                        validator: (value) {
                          return null;
                        },
                      ),
                    ],
                  ),
                );
              }),
              CustomOutlineButton(
                title: 'Tambah sertifikat',
                height: 32,
                width: 160,
                fontSize: 12,
                textColor: Color(0xFFF58612),
                onPressed: () {
                  setState(() {
                    sertifikatForms.add(SertifikatFormData());
                  });
                },
              ),

              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Identifikasi Risiko',
                style: interBodyMediumBold.copyWith(color: primary1),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: info100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: info500),
                ),
                child: Text(
                  ' Identifikasi risiko yang mungkin terjadi pada asset SDM ini, baik risiko positif (peluang) maupun risiko negatif (ancaman).',
                  style: interSmallMedium.copyWith(color: info500),
                ),
              ),
              SizedBox(height: 16),
              // Jenis
              CustomDropdown(
                selectedValue: selectedJenis,
                title: 'Jenis',
                placeholder: 'Pilih jenis',
                listItem: ['Negatif (Ancaman)', 'Positif (Peluang)'],
                badgeRequired: true,
                onChanged: (value) {
                  selectedJenis = value;
                },
              ),
              SizedBox(height: 16),
              // Kategori Risiko
              BlocBuilder<KategoriRisikoBloc, KategoriRisikoState>(
                builder: (context, state) {
                  List<KategoriRisikoModel> listKategoriRisiko = [];
                  if (state is KategoriRisikoLoaded) {
                    listKategoriRisiko = state.listKategoriRisiko;
                  }

                  return CustomDropdownGeneric<KategoriRisikoModel>(
                    title: 'Kategori Risiko',
                    badgeRequired: true,
                    showSearchBox: false,
                    selectedItem:
                        selectedKategoriRisiko != null
                            ? listKategoriRisiko.firstWhere(
                              (d) => d.id == selectedKategoriRisiko,
                              orElse: () => listKategoriRisiko.first,
                            )
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        selectedKategoriRisiko = value.id;
                      }
                    },
                    items: listKategoriRisiko,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a.id == b.id,
                    hintText: 'Kategori risiko',
                  );
                },
              ),
              SizedBox(height: 16),
              // Kejadian
              CustomOutlineForm(
                controller: kejadianController,
                title: 'Kejadian',
                placeholder: 'Jelaskan potensi risiko yang mungkin terjadi',
                minLines: 3,
                maxLines: 3,
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Penyebab
              CustomOutlineForm(
                controller: penyebabController,
                title: 'Penyebab',
                placeholder: 'Jelaskan penyebab atau faktor pemicu risiko',
                minLines: 3,
                maxLines: 3,
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Area Dampak
              BlocBuilder<AreaDampakBloc, AreaDampakState>(
                builder: (context, state) {
                  List<AreaDampakModel> listAreaDampak = [];
                  if (state is AreaDampakLoaded) {
                    listAreaDampak = state.listAreaDampak;
                  }
                  return CustomDropdownGeneric<AreaDampakModel>(
                    title: 'Area Dampak',
                    badgeRequired: true,
                    showSearchBox: false,
                    selectedItem:
                        selectedAreaDampak != null
                            ? listAreaDampak.firstWhere(
                              (d) => d == selectedAreaDampak,
                              orElse: () => listAreaDampak.first,
                            )
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        selectedAreaDampak = value;
                      }
                    },
                    items: listAreaDampak,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a == b,
                    hintText: 'Pilih area dampak',
                  );
                },
              ),
              SizedBox(height: 16),
              // Level Dampak
              BlocBuilder<LevelDampakBloc, LevelDampakState>(
                builder: (context, state) {
                  List<LevelDampakModel> listLevelDampak = [];
                  if (state is LevelDampakLoaded) {
                    listLevelDampak = state.listLevelDampak;
                  }

                  return CustomDropdownGeneric<LevelDampakModel>(
                    title: 'Level Dampak',
                    badgeRequired: true,
                    showSearchBox: false,
                    selectedItem:
                        selectedLevelDampak != null
                            ? listLevelDampak.firstWhere(
                              (d) => d == selectedLevelDampak,
                              orElse: () => listLevelDampak.first,
                            )
                            : null,
                    onChanged: (value) async {
                      if (value != null) {
                        selectedLevelDampak = value;

                        final result = await CalculateService().calculateRisk(
                          levelDampak: value.nilai.toString(),
                          levelKemungkinan: levelKemungkinanController.text,
                        );

                        result.fold(
                          (error) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(error)));
                          },
                          (data) {
                            setState(() {
                              riskResult = data;
                              besaranRisikoController.text =
                                  data.besaranRisiko.toString();
                            });
                          },
                        );
                      }
                    },
                    items: listLevelDampak,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a == b,
                    hintText: 'Pilih level dampak',
                  );
                },
              ),
              SizedBox(height: 16),
              // Level Kemungkinan
              CustomOutlineForm(
                controller: levelKemungkinanController,
                title: 'Level Kemungkinan',
                placeholder: 'Default 1 (asset baru)',
                badgeRequired: true,
                readOnly: true,
              ),
              SizedBox(height: 4),
              Text(
                'Dihitung otomatis dari sertifikat kompetensi yang relevan dengan jabatan',
                style: interTinyRegular.copyWith(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              // Besaran Risiko
              Stack(
                children: [
                  CustomOutlineForm(
                    controller: besaranRisikoController,
                    title: 'Besaran Risiko (Otomatis)',
                    placeholder: 'Akan dihitung otomatis',
                    badgeRequired: true,
                    readOnly: true,
                  ),
                  if (riskResult != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: hexToColor(riskResult!.colorCode),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          riskResult!.klasifikasi,
                          style: interSmallSemibold.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Hasil perkalian kemungkinan × dampak',
                style: interTinyRegular.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
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
            create: (context) => AssetBloc(),
            child: BlocConsumer<AssetBloc, AssetState>(
              listener: (context, state) {
                if (state is AssetSdmCreated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is AssetFailed) {
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
                  title: 'Simpan Aset SDM',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();
                      context.read<AssetBloc>().add(
                        CreateAssetSdm(
                          data: AssetSdmFormModel(
                            namaAsset: namaController.text,
                            kategori: selectedKategori!.toLowerCase(),
                            unitKerjaId: selectedUnitKerja!.id,
                            periodePemeliharaan: 12,
                            nip: nipController.text,
                            jabatanId: selectedJabatan,
                            catatan: catatanController.text,
                            certificates:
                                sertifikatForms
                                    .map(
                                      (s) => Certificate(
                                        kompetensiId: s.selectedKompetensi,
                                        nama: s.namaSertifController.text,
                                        lampiran: s.lampiranPathController.text,
                                      ),
                                    )
                                    .toList(),
                            riskAssessments: [
                              RiskAssessment(
                                jenis:
                                    selectedJenis == 'Negatif (Ancaman)'
                                        ? 'negatif'
                                        : 'positif',
                                kategoriRisikoId: selectedKategoriRisiko,
                                kejadian: kejadianController.text,
                                penyebab: penyebabController.text,
                                areaDampakId: selectedAreaDampak!.id,
                                levelDampakId: selectedLevelDampak!.id,
                                levelKemungkinanId: int.parse(
                                  levelKemungkinanController.text,
                                ),
                                besaran: int.parse(
                                  besaranRisikoController.text,
                                ),
                                klasifikasi: riskResult!.klasifikasi,
                              ),
                            ],
                          ),
                        ),
                      );
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

class SertifikatFormData {
  int? selectedKompetensi;
  TextEditingController namaSertifController = TextEditingController();
  TextEditingController lampiranFileController = TextEditingController();
  TextEditingController lampiranPathController = TextEditingController();
}
