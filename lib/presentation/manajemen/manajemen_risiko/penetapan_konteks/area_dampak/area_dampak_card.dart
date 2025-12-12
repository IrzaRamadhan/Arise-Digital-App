import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/area_dampak/area_dampak_bloc.dart';
import '../../../../../data/models/area_dampak_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/badge.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class AreaDampakCard extends StatelessWidget {
  final BuildContext ctxAreaDampak;
  final AreaDampakModel areaDampak;
  final VoidCallback onEdit;
  const AreaDampakCard({
    super.key,
    required this.ctxAreaDampak,
    required this.areaDampak,
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
                  areaDampak.nama,
                  style: interBodySmallSemibold.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  areaDampak.deskripsi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: interBodySmallRegular.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),

            Divider(height: 32, color: Colors.grey.shade200),
            Row(
              children: [
                StatusBadge3(isActive: areaDampak.isActive),
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
                            AreaDampakBloc(useConnectivityListener: false),
                    child: BlocConsumer<AreaDampakBloc, AreaDampakState>(
                      listener: (context, state) {
                        if (state is AreaDampakDeleted) {
                          context.loaderOverlay.hide();
                          ctxAreaDampak.read<AreaDampakBloc>().add(
                            FetchAreaDampak(),
                          );
                        } else if (state is AreaDampakFailed) {
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
                                title: 'Hapus Area Dampak',
                                description:
                                    'Apakah anda yakin ingin menghapus area dampak ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<AreaDampakBloc>().add(
                                    DeleteAreaDampak(areaDampak.id),
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
