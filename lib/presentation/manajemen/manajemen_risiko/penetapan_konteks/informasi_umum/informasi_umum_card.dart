import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/informasi_umum/informasi_umum_bloc.dart';
import '../../../../../data/models/informasi_umum_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class InformasiUmumCard extends StatelessWidget {
  final BuildContext ctxInformasiUmum;
  final InformasiUmumModel informasiUmum;
  final VoidCallback onEdit;
  const InformasiUmumCard({
    super.key,
    required this.ctxInformasiUmum,
    required this.informasiUmum,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  informasiUmum.namaUprSpbe,
                  style: interBodySmallSemibold.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                if (informasiUmum.tugasUprSpbe != null) ...[
                  Text(
                    informasiUmum.tugasUprSpbe!,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
                if (informasiUmum.fungsiUprSpbe != null) ...[
                  Text(
                    informasiUmum.fungsiUprSpbe!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                if (informasiUmum.periodeWaktu != null)
                  Text(
                    informasiUmum.periodeWaktu!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
            if (role == 'Diskominfo') ...[
              Divider(height: 32, color: Colors.grey.shade200),
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      onPressed: onEdit,
                      icon: Icon(
                        Hicons.editSquareLightOutline,
                        size: 24,
                        color: primary1,
                      ),
                    ),
                  ),
                  BlocProvider(
                    create:
                        (context) =>
                            InformasiUmumBloc(useConnectivityListener: false),
                    child: BlocConsumer<InformasiUmumBloc, InformasiUmumState>(
                      listener: (context, state) {
                        if (state is InformasiUmumDeleted) {
                          context.loaderOverlay.hide();
                          ctxInformasiUmum.read<InformasiUmumBloc>().add(
                            FetchInformasiUmum(),
                          );
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
                        return SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            onPressed: () async {
                              showConfirmationDialog(
                                context: context,
                                title: 'Hapus InformasiUmum',
                                description:
                                    'Apakah anda yakin ingin menghapus informasi_umum ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<InformasiUmumBloc>().add(
                                    DeleteInformasiUmum(informasiUmum.id),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Hicons.delete2LightOutline,
                              size: 24,
                              color: danger600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
