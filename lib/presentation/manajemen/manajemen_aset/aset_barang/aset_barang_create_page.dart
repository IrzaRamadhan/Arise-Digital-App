import 'package:arise/data/models/asset_barang_form_model.dart';
import 'package:arise/data/models/level_dampak_model.dart';
import 'package:arise/data/models/penanggung_jawab_model.dart';
import 'package:arise/data/services/auth_service.dart';
import 'package:arise/presentation/master_data/lokasi/lokasi_create_page.dart';
import 'package:arise/presentation/master_data/vendor/vendor_create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../bloc/area_dampak/area_dampak_bloc.dart';
import '../../../../bloc/asset/asset_bloc.dart';
import '../../../../bloc/dinas/dinas_bloc.dart';
import '../../../../bloc/kategori_risiko/kategori_risiko_bloc.dart';
import '../../../../bloc/level_dampak/level_dampak_bloc.dart';
import '../../../../bloc/lokasi/lokasi_bloc.dart';
import '../../../../bloc/penanggung_jawab/penanggung_jawab_bloc.dart';
import '../../../../bloc/sub_kategori/sub_kategori_bloc.dart';
import '../../../../bloc/unit_kerja/unit_kerja_bloc.dart';
import '../../../../bloc/vendor/vendor_bloc.dart';
import '../../../../data/models/area_dampak_model.dart';
import '../../../../data/models/calculate_model.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../data/models/kategori_risiko_model.dart';
import '../../../../data/models/lokasi_model.dart';
import '../../../../data/models/sub_kategori_model.dart';
import '../../../../data/models/unit_kerja_model.dart';
import '../../../../data/models/vendor_model.dart';
import '../../../../data/services/calculate_service.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/shared_method.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/forms.dart';
import '../../../../widgets/snackbar.dart';
import '../../../../widgets/upload.dart';

class AsetBarangCreatePage extends StatefulWidget {
  const AsetBarangCreatePage({super.key});

  @override
  State<AsetBarangCreatePage> createState() => _AsetBarangCreatePageState();
}

class _AsetBarangCreatePageState extends State<AsetBarangCreatePage> {
  final _formKey = GlobalKey<FormState>();

  // Informasi Dasar Aset
  final namaController = TextEditingController();
  final kodeBMDController = TextEditingController();
  final nomorSeriController = TextEditingController();
  String? selectedKategori;
  int? selectedSubKategori;
  LokasiModel? selectedLokasiModel;

  // Informasi Detail Barang
  PenanggungJawabModel? selectedPenanggungJawab;
  final penanggungJawabController = TextEditingController();
  int? selectedDinas = AuthService().getDinasId();
  UnitKerjaModel? selectedUnitKerja;
  int? selectedVendor;
  String? selectedPeriodePemeliharaan;
  final tanggalPerolehanController = TextEditingController();
  final nilaiPerolehanController = TextEditingController();
  final lampiranFilecontroller = TextEditingController();
  final lampiranPathController = TextEditingController();
  final lampiranLinkController = TextEditingController();
  final keteranganController = TextEditingController();

  // Identifikasi Risiko
  String? selectedJenis;
  int? selectedKategoriRisiko;
  final kejadianController = TextEditingController();
  final penyebabController = TextEditingController();
  AreaDampakModel? selectedAreaDampak;
  LevelDampakModel? selectedLevelDampak;
  final levelKemungkinanController = TextEditingController(text: '1');
  final besaranRisikoController = TextEditingController();
  RiskCalculateModel? riskResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Aset Barang')),
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
                placeholder: 'cth. Laptop, TV, AC',
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Kode BMD
              CustomOutlineForm(
                controller: kodeBMDController,
                title: 'Kode BMD',
                placeholder: 'Masukkan kode BMD',
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Nomor Seri
              CustomOutlineForm(
                controller: nomorSeriController,
                title: 'Nomor Seri',
                placeholder: 'Masukkan nomor seri',
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
              // Sub-Kategori
              BlocBuilder<SubKategoriBloc, SubKategoriState>(
                builder: (context, state) {
                  List<SubKategoriModel> listSubKategori = [];
                  if (state is SubKategoriLoaded) {
                    listSubKategori = state.listSubKategori;
                  }

                  return CustomDropdownGeneric<SubKategoriModel>(
                    title: 'Sub-Kategori',
                    badgeRequired: true,
                    selectedItem:
                        selectedSubKategori != null
                            ? listSubKategori.firstWhere(
                              (d) => d.id == selectedSubKategori,
                              orElse: () => listSubKategori.first,
                            )
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        selectedSubKategori = value.id;
                      }
                    },
                    items: listSubKategori,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a.id == b.id,
                    hintText: 'Pilih sub-kategori',
                  );
                },
              ),
              SizedBox(height: 16),
              // Lokasi
              BlocBuilder<LokasiBloc, LokasiState>(
                builder: (context, state) {
                  List<LokasiModel> listLokasi = [];
                  if (state is LokasiLoaded) {
                    listLokasi = state.listLokasi;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdownGeneric<LokasiModel>(
                        title: 'Lokasi',
                        badgeRequired: true,
                        selectedItem: selectedLokasiModel,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedLokasiModel = value;
                            });
                          }
                        },
                        items: listLokasi,
                        itemAsString: (d) => d.nama,
                        compareFn: (a, b) => a.id == b.id,
                        hintText: 'Pilih lokasi',
                      ),

                      const SizedBox(height: 8),

                      if (selectedLokasiModel != null)
                        Container(
                          height: 200,
                          margin: EdgeInsets.only(bottom: 8),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                double.parse(selectedLokasiModel!.latitude),
                                double.parse(selectedLokasiModel!.longitude),
                              ),
                              zoom: 16,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('lokasi'),
                                position: LatLng(
                                  double.parse(selectedLokasiModel!.latitude),
                                  double.parse(selectedLokasiModel!.longitude),
                                ),
                                infoWindow: InfoWindow(
                                  title: selectedLokasiModel!.nama,
                                  snippet: selectedLokasiModel!.alamat,
                                ),
                              ),
                            },
                            zoomControlsEnabled: true,
                            myLocationButtonEnabled: false,
                          ),
                        ),
                    ],
                  );
                },
              ),
              CustomOutlineButton(
                title: 'Tambah lokasi baru',
                height: 32,
                width: 160,
                fontSize: 12,
                textColor: Color(0xFFF58612),
                onPressed: () {
                  NavigationHelper.push(context, LokasiCreatePage()).then((
                    result,
                  ) {
                    if (result && context.mounted) {
                      context.read<LokasiBloc>().add(FetchLokasi());
                    }
                  });
                },
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Informasi Detail Barang',
                style: interBodyMediumBold.copyWith(color: primary1),
              ),
              SizedBox(height: 16),

              BlocBuilder<PenanggungJawabBloc, PenanggungJawabState>(
                builder: (context, state) {
                  List<PenanggungJawabModel> listPenanggungJawab = [];

                  if (state is PenanggungJawabLoaded) {
                    listPenanggungJawab = [
                      PenanggungJawabModel(
                        id: 0,
                        name: 'Ketik nama baru',
                        dinasId: 0,
                      ),
                      ...state.listPenanggungJawab.map((e) => e),
                    ];
                  }

                  return CustomDropdownGeneric<PenanggungJawabModel>(
                    title: 'Penanggung Jawab',
                    selectedItem: selectedPenanggungJawab,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedPenanggungJawab = value;
                          if (value.name != 'Ketik nama baru') {
                            selectedDinas = value.dinasId;
                          } else {
                            selectedDinas = null;
                          }
                        });
                      }
                    },

                    items: listPenanggungJawab,
                    itemAsString: (d) => d.name,
                    compareFn: (a, b) => a == b,
                    hintText: 'Pilih penanggung jawab',
                    validator: (p0) => null,
                  );
                },
              ),
              if (selectedPenanggungJawab != null &&
                  selectedPenanggungJawab!.name == 'Ketik nama baru') ...[
                SizedBox(height: 8),
                CustomOutlineForm(
                  controller: penanggungJawabController,
                  title: '',
                  useTitle: false,
                  placeholder: 'Masukkan nama penanggung jawab',
                ),
              ],

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
              // Vendor
              BlocBuilder<VendorBloc, VendorState>(
                builder: (context, state) {
                  List<VendorModel> listVendor = [];
                  if (state is VendorLoaded) {
                    listVendor = state.listVendor;
                  }

                  return CustomDropdownGeneric<VendorModel>(
                    title: 'Vendor',
                    badgeRequired: true,
                    selectedItem:
                        selectedVendor != null
                            ? listVendor.firstWhere(
                              (d) => d.id == selectedVendor,
                              orElse: () => listVendor.first,
                            )
                            : null,
                    onChanged: (value) {
                      if (value != null) {
                        selectedVendor = value.id;
                      }
                    },
                    items: listVendor,
                    itemAsString: (d) => d.nama,
                    compareFn: (a, b) => a.id == b.id,
                    hintText: 'Vendor',
                  );
                },
              ),
              SizedBox(height: 8),
              CustomOutlineButton(
                title: 'Tambah vendor baru',
                height: 32,
                width: 160,
                fontSize: 12,
                textColor: Color(0xFFF58612),
                onPressed: () {
                  NavigationHelper.push(context, VendorCreatePage()).then((
                    result,
                  ) {
                    if (result && context.mounted) {
                      context.read<VendorBloc>().add(FetchVendor());
                    }
                  });
                },
              ),
              SizedBox(height: 16),

              // Periode Perolehan
              CustomDropdown(
                title: 'Periode Pemeliharaan',
                placeholder: 'Pilih periode pemeliharaan',
                listItem: ['3 Bulan', '6 Bulan', '12 Bulan'],
                badgeRequired: true,
                onChanged: (value) {
                  selectedPeriodePemeliharaan = value;
                },
              ),
              SizedBox(height: 16),
              // Tanggal Perolehan
              CustomDateForm(
                title: 'Tanggal Perolehan',
                placeholder: 'Pilih tanggal',
                tanggalController: tanggalPerolehanController,
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Nilai Perolehan
              CustomOutlineForm(
                controller: nilaiPerolehanController,
                title: 'Nilai perolehan',
                placeholder: 'Nilai perolehan',
                isNumber: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                badgeRequired: true,
              ),
              SizedBox(height: 16),
              // Lampiran
              FilePickerFormField(
                context: context,
                title: 'Lampiran File',
                placeholder: 'Lampiran file',
                controllerFile: lampiranFilecontroller,
                controllerPathFile: lampiranPathController,
                allowedExtensions: ['pdf'],
                validator: (value) => null,
              ),
              SizedBox(height: 16),
              // Lampiran Link
              CustomOutlineForm(
                controller: lampiranLinkController,
                title: 'Lampiran Link',
                placeholder: 'https://example.com',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }

                  final uri = Uri.tryParse(value);
                  if (uri == null ||
                      (!uri.isAbsolute) ||
                      (uri.scheme != 'http' && uri.scheme != 'https')) {
                    return 'Masukkan URL yang valid (http/https)';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),
              // Keterangan
              CustomOutlineForm(
                controller: keteranganController,
                title: 'Keterangan',
                placeholder: 'Masukkan keterangan tambahan',
                minLines: 3,
                maxLines: 3,
                badgeRequired: true,
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
                  'Identifikasi risiko yang mungkin terjadi pada aset ini, baik risiko positif (peluang) maupun risiko negatif (ancaman).',
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
                          levelKemungkinan: '1',
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
                placeholder: 'Default 1 (aset baru)',
                badgeRequired: true,
                readOnly: true,
              ),
              SizedBox(height: 4),
              Text(
                'Default: 1 (Aset Baru)',
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
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => AssetBloc(),
            child: BlocConsumer<AssetBloc, AssetState>(
              listener: (context, state) {
                if (state is AssetBarangCreated) {
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
                  title: 'Simpan Aset Barang',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate() &&
                        riskResult != null) {
                      context.loaderOverlay.show();
                      context.read<AssetBloc>().add(
                        CreateAssetBarang(
                          data: AssetBarangFormModel(
                            namaAsset: namaController.text,
                            kodeBmd: kodeBMDController.text,
                            nomorSeri: nomorSeriController.text,
                            kategori: selectedKategori!.toLowerCase(),
                            subKategoriId: selectedSubKategori,
                            lokasiId: selectedLokasiModel!.id,
                            penanggungJawab: selectedPenanggungJawab?.id,
                            penanggungJawabManual:
                                penanggungJawabController.text,
                            unitKerjaId: selectedUnitKerja!.id,
                            vendorId: selectedVendor,
                            periodePemeliharaan: selectedPeriodePemeliharaan!
                                .replaceAll(' Bulan', ''),
                            nilaiPerolehan: nilaiPerolehanController.text,
                            tanggalPerolehan: tanggalPerolehanController.text,
                            lampiranLink: lampiranLinkController.text,
                            keterangan: keteranganController.text,
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
                          lampiranFile:
                              lampiranPathController.text.isNotEmpty
                                  ? lampiranPathController.text
                                  : null,
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
