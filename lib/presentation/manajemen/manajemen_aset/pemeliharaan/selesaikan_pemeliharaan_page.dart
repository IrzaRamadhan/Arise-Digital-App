import 'package:arise/data/models/maintenance_complete_form_model.dart';
import 'package:arise/shared/shared_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../bloc/asset_barang/asset_barang_bloc.dart';
import '../../../../bloc/vendor/vendor_bloc.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../data/models/vendor_model.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/forms.dart';
import '../../../../widgets/snackbar.dart';
import '../../../../widgets/upload.dart';

class SelesaikanPemeliharaanPage extends StatefulWidget {
  final AssetModel asset;
  const SelesaikanPemeliharaanPage({super.key, required this.asset});

  @override
  State<SelesaikanPemeliharaanPage> createState() =>
      _SelesaikanPemeliharaanPageState();
}

class _SelesaikanPemeliharaanPageState
    extends State<SelesaikanPemeliharaanPage> {
  final _formKey = GlobalKey<FormState>();

  // Dasar Aset
  final namaController = TextEditingController();
  final kodeBMDController = TextEditingController();
  final nomorSeriController = TextEditingController();
  final periodePemeliharaanController = TextEditingController();

  // Riwayat Pemeliharaan
  final tanggalRealisasiController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );
  String? selectedJenisPemeliharaan;
  int? selectedVendor;
  final biayaPemeliharaanController = TextEditingController(text: '0');
  final buktiFilecontroller = TextEditingController();
  final buktiPathController = TextEditingController();
  final catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaController.text = widget.asset.namaAsset;
    kodeBMDController.text = widget.asset.kodeBmd ?? '';
    nomorSeriController.text = widget.asset.nomorSeri ?? '';
    periodePemeliharaanController.text =
        widget.asset.periodePemeliharaan.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selesaikan Pemeliharaan')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Aset',
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
              // Periode Pemeliharaan
              CustomOutlineForm(
                controller: periodePemeliharaanController,
                title: 'Periode Pemeliharaan (Bulan)',
                placeholder: 'Masukkan periode pemeliharaan',
                badgeRequired: true,
                isNumber: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 16),

              Divider(),
              SizedBox(height: 16),
              Text(
                'Riwayat Pemeliharaan',
                style: interBodyMediumBold.copyWith(color: primary1),
              ),
              SizedBox(height: 16),
              CustomOutlineForm(
                controller: tanggalRealisasiController,
                title: 'Tanggal Realisasi',
                placeholder: 'Masukkan nomor seri',
                badgeRequired: true,
                readOnly: true,
              ),
              SizedBox(height: 4),
              Text(
                'Otomatis terisi dengan tanggal hari ini',
                style: interTinyRegular.copyWith(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              CustomDropdown(
                selectedValue: selectedJenisPemeliharaan,
                title: 'Jenis Pemeliharaan',
                placeholder: 'Pilih jenis pemeliharaan',
                listItem: [
                  'Terjadwal (Rutin/Preventif)',
                  'Insidental (Mendadak/Darurat)',
                ],
                badgeRequired: true,
                onChanged: (value) {
                  selectedJenisPemeliharaan = value;
                },
              ),
              SizedBox(height: 16),
              BlocBuilder<VendorBloc, VendorState>(
                builder: (context, state) {
                  List<VendorModel> listVendor = [];
                  if (state is VendorLoaded) {
                    listVendor = state.listVendor;
                  }

                  return CustomDropdownGeneric<VendorModel>(
                    title: 'Vendor',
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
                    validator: (p0) => null,
                    hintText: 'Pilih Vendor',
                  );
                },
              ),
              SizedBox(height: 4),
              Text(
                'Kosongkan jika dikerjakan internal',
                style: interTinyRegular.copyWith(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              CustomOutlineForm(
                controller: biayaPemeliharaanController,
                title: 'Biaya Pemeliharaan',
                placeholder: 'Masukkan biaya pemeliharaan',
                isNumber: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => null,
              ),
              SizedBox(height: 4),
              Text(
                'Kosongkan jika tidak ada biaya',
                style: interTinyRegular.copyWith(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              FilePickerFormField(
                context: context,
                title: 'Bukti Pemeliharaan (File)',
                placeholder: 'Bukti Pemeliharaan file',
                controllerFile: buktiFilecontroller,
                controllerPathFile: buktiPathController,
                allowedExtensions: ['pdf', 'jpg', 'png'],
                validator: (value) => null,
              ),
              SizedBox(height: 16),
              CustomOutlineForm(
                controller: catatanController,
                title: 'Catatan Teknis Pemeliharaan ',
                placeholder: 'Jelaskan detail pemeliharaan yang dilakukan',
                minLines: 3,
                maxLines: 3,
                badgeRequired: true,
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
            create: (context) => AssetBarangBloc(),
            child: BlocConsumer<AssetBarangBloc, AssetBarangState>(
              listener: (context, state) {
                if (state is AssetBarangMaintenanceCompleted) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is AssetBarangFailed) {
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
                  title: 'Selesaikan Pemeliharaan',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();
                      context.read<AssetBarangBloc>().add(
                        MaintenanceCompleteAssetBarang(
                          id: widget.asset.id,
                          data: MaintenanceCompleteFormModel(
                            namaAsset: namaController.text,
                            kodeBmd: kodeBMDController.text,
                            nomorSeri: nomorSeriController.text,
                            periodePemeliharaan:
                                periodePemeliharaanController.text,
                            tanggalRealisasiPemeliharaan: dmyToYmd(
                              tanggalRealisasiController.text,
                            ),
                            jenisPemeliharaan:
                                selectedJenisPemeliharaan ==
                                        'Terjadwal (Rutin/Preventif)'
                                    ? 'terjadwal'
                                    : 'insidental',
                            vendorId: selectedVendor,
                            biayaPemeliharaan: biayaPemeliharaanController.text,
                            buktiPemeliharaan: buktiPathController.text,
                            catatanTeknisPemeliharaan: catatanController.text,
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
