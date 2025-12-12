import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/peraturan/peraturan_bloc.dart';
import '../../../../../data/models/peraturan_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class PeraturanCard extends StatelessWidget {
  final BuildContext ctxPeraturan;
  final PeraturanModel peraturan;
  final VoidCallback onEdit;
  const PeraturanCard({
    super.key,
    required this.ctxPeraturan,
    required this.peraturan,
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
            Text(
              peraturan.nama,
              style: interBodySmallSemibold.copyWith(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            if (peraturan.amanat != null) ...[
              SizedBox(height: 8),
              Text(
                peraturan.amanat!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: interBodySmallRegular.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
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
                        (context) =>
                            PeraturanBloc(useConnectivityListener: false),
                    child: BlocConsumer<PeraturanBloc, PeraturanState>(
                      listener: (context, state) {
                        if (state is PeraturanDeleted) {
                          context.loaderOverlay.hide();
                          ctxPeraturan.read<PeraturanBloc>().add(
                            FetchPeraturan(),
                          );
                        } else if (state is PeraturanFailed) {
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
                                title: 'Hapus Peraturan',
                                description:
                                    'Apakah anda yakin ingin menghapus sasaran_risiko ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<PeraturanBloc>().add(
                                    DeletePeraturan(peraturan.id),
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
