import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/kategori_risiko/kategori_risiko_bloc.dart';
import '../../../../../data/models/kategori_risiko_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/badge.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class KategoriRisikoCard extends StatelessWidget {
  final BuildContext ctxKategoriRisiko;
  final KategoriRisikoModel kategoriRisiko;
  final VoidCallback onEdit;
  const KategoriRisikoCard({
    super.key,
    required this.ctxKategoriRisiko,
    required this.kategoriRisiko,
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
                  kategoriRisiko.nama,
                  style: interBodySmallSemibold.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  kategoriRisiko.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: interBodySmallRegular.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Selera Positif : ${kategoriRisiko.seleraPositif}',
                        style: interSmallRegular.copyWith(
                          color: Colors.green.shade600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.red.shade300,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Selera Negatif : ${kategoriRisiko.seleraNegatif}',
                        style: interSmallRegular.copyWith(
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 32, color: Colors.grey.shade200),
            Row(
              children: [
                StatusBadge3(isActive: kategoriRisiko.isActive),
                if (role == 'Diskominfo') ...[
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
                            KategoriRisikoBloc(useConnectivityListener: false),
                    child: BlocConsumer<
                      KategoriRisikoBloc,
                      KategoriRisikoState
                    >(
                      listener: (context, state) {
                        if (state is KategoriRisikoDeleted) {
                          context.loaderOverlay.hide();
                          ctxKategoriRisiko.read<KategoriRisikoBloc>().add(
                            FetchKategoriRisiko(),
                          );
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
                        return SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            onPressed: () async {
                              showConfirmationDialog(
                                context: context,
                                title: 'Hapus Kategori Risiko',
                                description:
                                    'Apakah anda yakin ingin menghapus kategori risiko ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<KategoriRisikoBloc>().add(
                                    DeleteKategoriRisiko(kategoriRisiko.id),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
