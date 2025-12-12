import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/sasaran_risiko/sasaran_risiko_bloc.dart';
import '../../../../../data/models/sasaran_risiko_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class SasaranRisikoCard extends StatelessWidget {
  final BuildContext ctxSasaranRisiko;
  final SasaranRisikoModel sasaranRisiko;
  final VoidCallback onEdit;
  const SasaranRisikoCard({
    super.key,
    required this.ctxSasaranRisiko,
    required this.sasaranRisiko,
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
                  sasaranRisiko.sasaranUpr,
                  style: interBodySmallSemibold.copyWith(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                if (sasaranRisiko.sasaran != null) ...[
                  Text(
                    sasaranRisiko.sasaran!,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: List.generate(sasaranRisiko.indikatorTargets.length, (
                    index,
                  ) {
                    return Text(
                      '${sasaranRisiko.indikatorTargets[index].indikatorKinerja}: ${sasaranRisiko.indikatorTargets[index].targetKinerja}',
                      style: interBodySmallRegular.copyWith(
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    );
                  }),
                ),
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
                        (context) =>
                            SasaranRisikoBloc(useConnectivityListener: false),
                    child: BlocConsumer<SasaranRisikoBloc, SasaranRisikoState>(
                      listener: (context, state) {
                        if (state is SasaranRisikoDeleted) {
                          context.loaderOverlay.hide();
                          ctxSasaranRisiko.read<SasaranRisikoBloc>().add(
                            FetchSasaranRisiko(),
                          );
                        } else if (state is SasaranRisikoFailed) {
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
                                title: 'Hapus SasaranRisiko',
                                description:
                                    'Apakah anda yakin ingin menghapus sasaran_risiko ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<SasaranRisikoBloc>().add(
                                    DeleteSasaranRisiko(sasaranRisiko.id),
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
