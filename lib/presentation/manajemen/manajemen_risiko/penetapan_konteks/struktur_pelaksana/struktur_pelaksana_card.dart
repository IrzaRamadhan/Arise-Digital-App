import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/struktur_pelaksana/struktur_pelaksana_bloc.dart';
import '../../../../../data/models/struktur_pelaksana_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class StrukturPelaksanaCard extends StatelessWidget {
  final BuildContext ctxStrukturPelaksana;
  final StrukturPelaksanaModel strukturPelaksana;
  final VoidCallback onEdit;
  const StrukturPelaksanaCard({
    super.key,
    required this.ctxStrukturPelaksana,
    required this.strukturPelaksana,
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
                Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.person, color: primary1),
                    Text(
                      strukturPelaksana.peran,
                      style: interBodyMediumSemibold.copyWith(color: primary1),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  strukturPelaksana.nama,
                  style: interBodySmallSemibold.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                if (strukturPelaksana.jabatan != null) ...[
                  Text(
                    strukturPelaksana.jabatan!,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ],
            ),
            if (role == 'Diskominfo') ...[
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
                        (context) => StrukturPelaksanaBloc(
                          useConnectivityListener: false,
                        ),
                    child: BlocConsumer<
                      StrukturPelaksanaBloc,
                      StrukturPelaksanaState
                    >(
                      listener: (context, state) {
                        if (state is StrukturPelaksanaDeleted) {
                          context.loaderOverlay.hide();
                          ctxStrukturPelaksana
                              .read<StrukturPelaksanaBloc>()
                              .add(FetchStrukturPelaksana());
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
                        return SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            onPressed: () async {
                              showConfirmationDialog(
                                context: context,
                                title: 'Hapus StrukturPelaksana',
                                description:
                                    'Apakah anda yakin ingin menghapus struktur_pelaksana ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<StrukturPelaksanaBloc>().add(
                                    DeleteStrukturPelaksana(
                                      strukturPelaksana.id,
                                    ),
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
