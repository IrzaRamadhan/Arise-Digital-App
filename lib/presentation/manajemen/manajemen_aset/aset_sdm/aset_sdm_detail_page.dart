import 'package:arise/presentation/manajemen/manajemen_aset/components/sertifikat_add_dialog.dart';
import 'package:arise/shared/shared_values.dart';
import 'package:arise/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../bloc/asset/asset_bloc.dart';
import '../../../../bloc/asset_sdm/asset_sdm_bloc.dart';
import '../../../../controllers/asset_controller.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../helper/file_helper.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/badge.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/confirmation_decommission.dart';
import '../../../../widgets/confirmation_dialog.dart';
import '../../../../widgets/confirmation_disposal_dialog.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../aset_lifecycle/asset_lifecycle_page.dart';
import '../components/detail_text_item.dart';

class AsetSdmDetailPage extends StatelessWidget {
  final int id;
  final bool? showAction;
  const AsetSdmDetailPage({
    super.key,
    required this.id,
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AssetBloc()..add(FetchAssetDetail(id: id, type: 'sdm')),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Aset SDM'),
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
                                    title: 'Kategori',
                                    value: asset.kategori.toUpperCase(),
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
                                    title: 'Unit Kerja',
                                    value: asset.unitKerja!.nama,
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
                          'Informasi SDM',
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
                                    title: 'NIP',
                                    value: asset.assetSdm!.nip,
                                  ),
                                  DetailTextItem(
                                    title: 'Jabatan',
                                    value: asset.assetSdm!.jabatan!.nama,
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
                                    title: 'Catatan',
                                    value: asset.assetSdm!.catatan ?? '-',
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
                  SizedBox(height: 24),
                  Row(
                    spacing: 16,
                    children: [
                      Flexible(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pemeliharaan Terakhir',
                              style: poppinsBodySmallSemibold,
                            ),
                            Text(
                              'Belum ada',
                              style: interSmallRegular.copyWith(
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pemeliharaan Berikutnya',
                              style: poppinsBodySmallSemibold,
                            ),
                            Text(
                              'Belum ada',
                              style: interSmallRegular.copyWith(
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Sertifikat',
                        style: poppinsBodyMediumSemibold,
                      ),
                      if (state.asset.status == 'pemeliharaan')
                        CustomOutlineButton(
                          title: 'Tambah',
                          height: 32,
                          width: 80,
                          fontSize: 12,
                          textColor: primary1,
                          onPressed: () {
                            showSertifikatAddDialog(context: context);
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (asset.assetSdm!.sertifikats.isNotEmpty) ...[
                    Column(
                      spacing: 4,
                      children: List.generate(
                        asset.assetSdm!.sertifikats.length,
                        (index) {
                          return Column(
                            children: [
                              Row(
                                spacing: 8,
                                children: [
                                  Image.asset(
                                    'assets/images/grafis_sdm.png',
                                    width: 32,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          asset
                                              .assetSdm!
                                              .sertifikats[index]
                                              .nama,
                                          style: interSmallSemibold.copyWith(
                                            color: primary1,
                                          ),
                                        ),
                                        Text(
                                          asset
                                              .assetSdm!
                                              .sertifikats[index]
                                              .kompetensi
                                              .nama,
                                          style: interSmallRegular.copyWith(
                                            color: primary1,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('d MMMM y HH:mm').format(
                                            asset
                                                .assetSdm!
                                                .sertifikats[index]
                                                .createdAt,
                                          ),
                                          style: interTinyRegular.copyWith(
                                            color: Colors.grey[40],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final result = await FileHelper()
                                          .startDownloadFile(
                                            '$baseUrl/storage/${asset.assetSdm!.sertifikats[0].lampiran}',
                                          );

                                      if (context.mounted) {
                                        if (result) {
                                          showCustomSnackbar(
                                            context: context,
                                            message:
                                                'Berhasil mengunduh sertifikat',
                                            isSuccess: true,
                                          );
                                        } else {
                                          showCustomSnackbar(
                                            context: context,
                                            message:
                                                'Gagal mengunduh sertifikat',
                                            isSuccess: false,
                                          );
                                        }
                                      }
                                    },
                                    icon: Icon(
                                      Hicons.downloadLightOutline,
                                      color: primary1,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Belum ada sertifikat'),
                      ),
                    ),
                  ],
                  SizedBox(height: 36),
                ],
              );
            } else if (state is AssetFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<AssetBloc>().add(
                        FetchAssetDetail(id: id, type: 'sdm'),
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
                    create: (context) => AssetSdmBloc(),
                    child: BlocConsumer<AssetSdmBloc, AssetSdmState>(
                      listener: (context, state) {
                        if (state is AssetSdmRejected) {
                          context.loaderOverlay.hide();
                          refreshAssetSdmNotifier.value = true;
                          context.read<AssetBloc>().add(
                            FetchAssetDetail(id: id, type: 'sdm'),
                          );
                        } else if (state is AssetSdmFailed) {
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
                                context.read<AssetSdmBloc>().add(
                                  RejectAssetSdm(id),
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
                    create: (context) => AssetSdmBloc(),
                    child: BlocConsumer<AssetSdmBloc, AssetSdmState>(
                      listener: (context, state) {
                        if (state is AssetSdmApproved) {
                          context.loaderOverlay.hide();
                          refreshAssetSdmNotifier.value = true;
                          context.read<AssetBloc>().add(
                            FetchAssetDetail(id: id, type: 'sdm'),
                          );
                        } else if (state is AssetSdmFailed) {
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
                                context.read<AssetSdmBloc>().add(
                                  ApproveAssetSdm(id),
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
                  create: (context) => AssetSdmBloc(),
                  child: BlocConsumer<AssetSdmBloc, AssetSdmState>(
                    listener: (context, state) {
                      if (state is AssetSdmDecommissionProposed) {
                        context.loaderOverlay.hide();
                        refreshAssetSdmNotifier.value = true;
                        context.read<AssetBloc>().add(
                          FetchAssetDetail(id: id, type: 'sdm'),
                        );
                      } else if (state is AssetSdmFailed) {
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
                              context.read<AssetSdmBloc>().add(
                                DecommissionProposeAssetSdm(id),
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
                  create: (context) => AssetSdmBloc(),
                  child: BlocConsumer<AssetSdmBloc, AssetSdmState>(
                    listener: (context, state) {
                      if (state is AssetSdmMaintenanceStarted) {
                        context.loaderOverlay.hide();
                        refreshAssetSdmNotifier.value = true;
                        context.read<AssetBloc>().add(
                          FetchAssetDetail(id: id, type: 'sdm'),
                        );
                      } else if (state is AssetSdmFailed) {
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
                              context.read<AssetSdmBloc>().add(
                                MaintenanceStartAssetSdm(id),
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
          child: BlocProvider(
            create: (context) => AssetSdmBloc(),
            child: BlocConsumer<AssetSdmBloc, AssetSdmState>(
              listener: (context, state) {
                if (state is AssetSdmMaintenanceCompleted) {
                  context.loaderOverlay.hide();
                  refreshAssetSdmNotifier.value = true;
                  context.read<AssetBloc>().add(
                    FetchAssetDetail(id: id, type: 'sdm'),
                  );
                } else if (state is AssetSdmFailed) {
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
                  onPressed: () {
                    showConfirmationDialog(
                      context: context,
                      title: 'Selesaikan Pemeliharaan',
                      description:
                          'Apakah anda yakin ingin menyelesaikan maintanance aset ini?',
                      onConfirm: () async {
                        context.loaderOverlay.show();
                        context.read<AssetSdmBloc>().add(
                          MaintenanceCompleteAssetSdm(id),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );

      case 'non_aktif':
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => AssetSdmBloc(),
            child: BlocConsumer<AssetSdmBloc, AssetSdmState>(
              listener: (context, state) {
                if (state is AssetSdmDisposalProposed) {
                  context.loaderOverlay.hide();
                  refreshAssetSdmNotifier.value = true;
                  context.read<AssetBloc>().add(
                    FetchAssetDetail(id: id, type: 'sdm'),
                  );
                } else if (state is AssetSdmFailed) {
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
                        context.read<AssetSdmBloc>().add(
                          DisposalProposeAssetSdm(
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
