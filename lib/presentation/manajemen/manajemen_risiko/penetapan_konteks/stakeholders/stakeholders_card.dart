import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/stakeholders/stakeholders_bloc.dart';
import '../../../../../data/models/stakeholders_model.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';

class StakeholdersCard extends StatelessWidget {
  final BuildContext ctxStakeholders;
  final StakeholdersModel stakeholders;
  final VoidCallback onEdit;
  const StakeholdersCard({
    super.key,
    required this.ctxStakeholders,
    required this.stakeholders,
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
                if (stakeholders.unitOrganisasi != null) ...[
                  Row(
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.apartment,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                      Text(
                        stakeholders.unitOrganisasi!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: interBodySmallRegular.copyWith(
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
                if (stakeholders.email != null) ...[
                  Text(
                    stakeholders.email!,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
                if (stakeholders.telepon != null) ...[
                  Text(
                    stakeholders.telepon!,
                    style: interBodySmallRegular.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                ],
                if (stakeholders.tanggungJawab != null)
                  Text(
                    stakeholders.tanggungJawab!,
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
                            StakeholdersBloc(useConnectivityListener: false),
                    child: BlocConsumer<StakeholdersBloc, StakeholdersState>(
                      listener: (context, state) {
                        if (state is StakeholdersDeleted) {
                          context.loaderOverlay.hide();
                          ctxStakeholders.read<StakeholdersBloc>().add(
                            FetchStakeholders(),
                          );
                        } else if (state is StakeholdersFailed) {
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
                                title: 'Hapus Stakeholders',
                                description:
                                    'Apakah anda yakin ingin menghapus stakeholders ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<StakeholdersBloc>().add(
                                    DeleteStakeholders(stakeholders.id),
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
