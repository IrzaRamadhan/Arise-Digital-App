import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../shared/theme.dart';
import '../../../../widgets/confirmation_dialog.dart';
import '../../../../widgets/snackbar.dart';
import '../../../bloc/sub_kategori/sub_kategori_bloc.dart';
import '../../../data/models/sub_kategori_model.dart';
import '../../../data/services/auth_service.dart';

class SubKategoriCard extends StatelessWidget {
  final BuildContext ctxSubKategori;
  final SubKategoriModel vendor;
  final VoidCallback onEdit;
  const SubKategoriCard({
    super.key,
    required this.ctxSubKategori,
    required this.vendor,
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
            Row(
              children: [
                Expanded(
                  child: Text(vendor.nama, style: interBodySmallRegular),
                ),
                if (role == 'Diskominfo') ...[
                  SizedBox(width: 16),
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
                            SubKategoriBloc(useConnectivityListener: false),
                    child: BlocConsumer<SubKategoriBloc, SubKategoriState>(
                      listener: (context, state) {
                        if (state is SubKategoriDeleted) {
                          context.loaderOverlay.hide();
                          ctxSubKategori.read<SubKategoriBloc>().add(
                            FetchSubKategori(),
                          );
                        } else if (state is SubKategoriFailed) {
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
                                title: 'Hapus SubKategori',
                                description:
                                    'Apakah anda yakin ingin menghapus vendor ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<SubKategoriBloc>().add(
                                    DeleteSubKategori(vendor.id),
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
