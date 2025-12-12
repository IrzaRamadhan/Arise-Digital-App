import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/level_dampak/level_dampak_bloc.dart';
import '../../../../../data/models/level_dampak_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class LevelDampakCard extends StatelessWidget {
  final BuildContext ctxLevelDampak;
  final LevelDampakModel levelDampak;
  final VoidCallback onEdit;
  const LevelDampakCard({
    super.key,
    required this.ctxLevelDampak,
    required this.levelDampak,
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
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFFFEF1EA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300, width: 1.5),
              ),
              child: Text(
                levelDampak.nilai.toString(),
                style: interBodySmallSemibold.copyWith(
                  color: Colors.orange.shade300,
                ),
              ),
            ),
            Expanded(
              child: Text(
                levelDampak.nama,
                style: interBodySmallSemibold.copyWith(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            if (role == 'Diskominfo') ...[
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
                        LevelDampakBloc(useConnectivityListener: false),
                child: BlocConsumer<LevelDampakBloc, LevelDampakState>(
                  listener: (context, state) {
                    if (state is LevelDampakDeleted) {
                      context.loaderOverlay.hide();
                      ctxLevelDampak.read<LevelDampakBloc>().add(
                        FetchLevelDampak(),
                      );
                    } else if (state is LevelDampakFailed) {
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
                            title: 'Hapus Level Dampak',
                            description:
                                'Apakah anda yakin ingin menghapus level dampak ini?',
                            onConfirm: () async {
                              context.loaderOverlay.show();
                              context.read<LevelDampakBloc>().add(
                                DeleteLevelDampak(levelDampak.id),
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
      ),
    );
  }
}
