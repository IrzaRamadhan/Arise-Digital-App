import 'package:arise/controllers/asset_controller.dart';
import 'package:arise/data/services/auth_service.dart';
import 'package:arise/helper/navigation_helper.dart';
import 'package:arise/presentation/manajemen/manajemen_aset/aset_lifecycle/asset_lifecycle_page.dart';
import 'package:arise/presentation/manajemen/manajemen_aset/pemeliharaan/selesaikan_pemeliharaan_page.dart';
import 'package:arise/shared/shared_values.dart';
import 'package:arise/widgets/confirmation_decommission.dart';
import 'package:arise/widgets/confirmation_disposal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../bloc/asset/asset_bloc.dart';
import '../../../../bloc/asset_barang/asset_barang_bloc.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../shared/shared_method.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/badge.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/confirmation_dialog.dart';
import '../../../../widgets/snackbar.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../components/detail_link_item.dart';
import '../components/detail_text_item.dart';

class AsetBarangDetailPage extends StatelessWidget {
  final int id;
  final bool? showAction;
  const AsetBarangDetailPage({
    super.key,
    required this.id,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              AssetBloc()..add(FetchAssetDetail(id: id, type: 'barang')),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Aset Barang'),
          actions: [
            IconButton(
              onPressed: () {
                NavigationHelper.push(context, AssetLifecyclePage(id: id));
              },
              icon: Icon(Icons.history, color: primary1),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: BlocBuilder<AssetBloc, AssetState>(
          builder: (context, state) {
            if (state is AssetDetailLoaded) {
              AssetModel asset = state.asset;
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  if (asset.status == 'pending') ...[
                    if (asset.pendingVerif != null)
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFBF5D6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            Icon(
                              Hicons.dangerCircleBold,
                              color: Color(0xFFFAB368),
                            ),
                            Expanded(
                              child: Text(
                                'Aset Baru Menunggu Verifikasi',
                                style: poppinsSmallMedium.copyWith(
                                  color: Color(0xFFFAB368),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],

                  if (asset.status == 'pemeliharaan')
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFBF5D6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Hicons.dangerCircleBold,
                            color: Color(0xFFFAB368),
                          ),
                          Expanded(
                            child: Text(
                              'Aset sedang dalam pemeliharaan.\nSilakan lengkapi form pemeliharaan untuk menyelesaikan.',
                              style: poppinsSmallMedium.copyWith(
                                color: Color(0xFFFAB368),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (asset.status == 'non_aktif')
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(Hicons.dangerCircleBold, color: Colors.blue),
                          Expanded(
                            child: Text(
                              'Aset ini telah di-decommission dan dapat diajukan untuk disposal (pembuangan).',
                              style: poppinsSmallMedium.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Container(
                    padding: EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color(0xFF2B3791).withValues(alpha: 0.2),
                      ),
                      boxShadow: listShadow2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          'Informasi Dasar Aset',
                          style: interBodyMediumBold.copyWith(color: primary1),
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 16,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailTextItem(
                                    title: 'Nama Aset',
                                    value: asset.namaAsset,
                                  ),
                                  DetailTextItem(
                                    title: 'Kode BMD',
                                    value: asset.kodeBmd ?? '-',
                                  ),
                                  DetailTextItem(
                                    title: 'Nomor Seri',
                                    value: asset.nomorSeri ?? '-',
                                  ),
                                  DetailTextItem(
                                    title: 'Kategori',
                                    value: asset.kategori,
                                  ),
                                  DetailTextItem(
                                    title: 'Kondisi',
                                    value: asset.assetBarang!.kondisi,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailTextItem(
                                    title: 'Dinas',
                                    value: asset.unitKerja!.dinas.nama,
                                  ),
                                  DetailTextItem(
                                    title: 'Lokasi',
                                    value:
                                        asset.assetBarang!.lokasi != null
                                            ? asset.assetBarang!.lokasi!.nama
                                            : '-',
                                  ),
                                  DetailTextItem(
                                    title: 'Penanggung Jawab',
                                    value: asset.penanggungJawab ?? '-',
                                  ),
                                  DetailTextItem(
                                    title: 'Vendor',
                                    value:
                                        asset.assetBarang!.vendor != null
                                            ? asset.assetBarang!.vendor!.nama
                                            : '-',
                                  ),
                                  DetailTextItem(
                                    title: 'Dibuat',
                                    value: DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(DateTime.parse(asset.createdAt)),
                                  ),
                                  DetailTextItem(
                                    title: 'Diupdate',
                                    value: DateFormat(
                                      'dd/MM/yyyy HH:mm',
                                    ).format(DateTime.parse(asset.updatedAt)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Text(
                          'Informasi Detail Barang',
                          style: interBodyMediumBold.copyWith(color: primary1),
                        ),
                        SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 16,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailTextItem(
                                    title: 'Nilai Perolehan',
                                    value:
                                        asset.assetBarang!.nilaiPerolehan !=
                                                null
                                            ? toRupiah(
                                              int.parse(
                                                asset
                                                    .assetBarang!
                                                    .nilaiPerolehan!
                                                    .split('.')
                                                    .first,
                                              ),
                                            )
                                            : '-',
                                  ),
                                  DetailTextItem(
                                    title: 'Tanggal Perolehan',
                                    value:
                                        asset.assetBarang!.tanggalPerolehan !=
                                                null
                                            ? DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                asset
                                                    .assetBarang!
                                                    .tanggalPerolehan!,
                                              ),
                                            )
                                            : '-',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DetailLinkItem(
                                    title: 'Lampiran File',
                                    url:
                                        '$baseUrl/storage/${asset.assetBarang!.lampiranFile}',
                                  ),
                                  DetailLinkItem(
                                    title: 'Lampiran Link',
                                    url: asset.assetBarang!.lampiranLink,
                                  ),
                                  DetailTextItem(
                                    title: 'Keterangan',
                                    value:
                                        asset.assetBarang!.keterangan != null
                                            ? asset.assetBarang!.keterangan!
                                            : '-',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: listShadow,
                            ),
                            child: QrImageView(
                              data: '${asset.id}-${asset.jenis}',
                              version: 1,
                              size: 200.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Status:',
                              style: interSmallRegular.copyWith(
                                color: Color(0xFF312F2F),
                              ),
                            ),
                            StatusBadge1(status: asset.status),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is AssetFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<AssetBloc>().add(
                        FetchAssetDetail(id: id, type: 'barang'),
                      );
                    },
                    errorType: state.message,
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: SafeArea(
          child: BlocBuilder<AssetBloc, AssetState>(
            builder: (context, state) {
              if (state is AssetDetailLoaded && showAction == true) {
                AssetModel asset = state.asset;
                return _buildBottomButtons(asset, context);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(AssetModel asset, BuildContext context) {
    String role = AuthService().getRole();

    switch (asset.status) {
      case 'pending':
        if (role == 'Verifikator') {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: listShadow,
            ),
            child: Row(
              spacing: 16,
              children: [
                Flexible(
                  child: BlocProvider(
                    create: (context) => AssetBarangBloc(),
                    child: BlocConsumer<AssetBarangBloc, AssetBarangState>(
                      listener: (context, state) {
                        if (state is AssetBarangRejected) {
                          context.loaderOverlay.hide();
                          refreshAssetBarangNotifier.value = true;
                          context.read<AssetBloc>().add(
                            FetchAssetDetail(id: id, type: 'barang'),
                          );
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
                        return CustomOutlineButton(
                          title: 'Tolak',
                          onPressed: () {
                            showConfirmationDialog(
                              context: context,
                              title: 'Tolak Aset',
                              description:
                                  'Apakah anda yakin ingin menolak aset ini?',
                              onConfirm: () async {
                                context.loaderOverlay.show();
                                context.read<AssetBarangBloc>().add(
                                  RejectAssetBarang(id),
                                );
                              },
                            );
                          },
                          textColor: danger600,
                          showIconReject: true,
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: BlocProvider(
                    create: (context) => AssetBarangBloc(),
                    child: BlocConsumer<AssetBarangBloc, AssetBarangState>(
                      listener: (context, state) {
                        if (state is AssetBarangApproved) {
                          context.loaderOverlay.hide();
                          refreshAssetBarangNotifier.value = true;
                          context.read<AssetBloc>().add(
                            FetchAssetDetail(id: id, type: 'barang'),
                          );
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
                          title: 'Terima',
                          onPressed: () {
                            showConfirmationDialog(
                              context: context,
                              title: 'Terima Aset',
                              description:
                                  'Apakah anda yakin ingin terima aset ini?',
                              onConfirm: () async {
                                context.loaderOverlay.show();
                                context.read<AssetBarangBloc>().add(
                                  ApproveAssetBarang(id),
                                );
                              },
                            );
                          },
                          showIconAccept: true,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return SizedBox.shrink();
        }

      case 'aktif':
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: Row(
            spacing: 16,
            children: [
              Flexible(
                child: BlocProvider(
                  create: (context) => AssetBarangBloc(),
                  child: BlocConsumer<AssetBarangBloc, AssetBarangState>(
                    listener: (context, state) {
                      if (state is AssetBarangDecommissionProposed) {
                        context.loaderOverlay.hide();
                        refreshAssetBarangNotifier.value = true;
                        context.read<AssetBloc>().add(
                          FetchAssetDetail(id: id, type: 'barang'),
                        );
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
                      return CustomOutlineButton(
                        title: 'Nonaktifkan',
                        onPressed: () {
                          showConfirmationDecommissionDialog(
                            context: context,
                            onConfirm: (input) async {
                              context.loaderOverlay.show();
                              context.read<AssetBarangBloc>().add(
                                DecommissionProposeAssetBarang(id),
                              );
                            },
                          );
                        },
                        textColor: danger600,
                      );
                    },
                  ),
                ),
              ),
              Flexible(
                child: BlocProvider(
                  create: (context) => AssetBarangBloc(),
                  child: BlocConsumer<AssetBarangBloc, AssetBarangState>(
                    listener: (context, state) {
                      if (state is AssetBarangMaintenanceStarted) {
                        context.loaderOverlay.hide();
                        refreshAssetBarangNotifier.value = true;
                        context.read<AssetBloc>().add(
                          FetchAssetDetail(id: id, type: 'barang'),
                        );
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
                        title: 'Maintenance',
                        onPressed: () {
                          showConfirmationDialog(
                            context: context,
                            title: 'Maintenance',
                            description:
                                'Apakah anda yakin ingin melakukan maintanance aset ini?',
                            onConfirm: () async {
                              context.loaderOverlay.show();
                              context.read<AssetBarangBloc>().add(
                                MaintenanceStartAssetBarang(id),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );

      case 'pemeliharaan':
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: CustomFilledButton(
            title: 'Selesaikan Pemeliharaan',
            onPressed: () {
              NavigationHelper.push(
                context,
                SelesaikanPemeliharaanPage(asset: asset),
              );
            },
            showIconAccept: true,
          ),
        );

      case 'non_aktif':
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => AssetBarangBloc(),
            child: BlocConsumer<AssetBarangBloc, AssetBarangState>(
              listener: (context, state) {
                if (state is AssetBarangDisposalProposed) {
                  context.loaderOverlay.hide();
                  refreshAssetBarangNotifier.value = true;
                  context.read<AssetBloc>().add(
                    FetchAssetDetail(id: id, type: 'barang'),
                  );
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
                  title: 'Usulkan Pembuangan',
                  onPressed: () {
                    showConfirmationDisposalDialog(
                      context: context,
                      onConfirm: (input, method) async {
                        context.loaderOverlay.show();
                        context.read<AssetBarangBloc>().add(
                          DisposalProposeAssetBarang(
                            id: id,
                            reason: input,
                            method: method.toLowerCase(),
                          ),
                        );
                      },
                    );
                  },
                  textColor: Colors.white,
                  backgroundColor: danger600,
                );
              },
            ),
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }
}
