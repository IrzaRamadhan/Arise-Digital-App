import 'package:arise/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/dinas/dinas_bloc.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/forms.dart';

Future<Map<String, dynamic>?> showLaporanFilterDialog({
  required BuildContext context,
  required DinasModel selectedDinas,
  required String? selectedStartDate,
  required String? selectedEndDate,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      String role = AuthService().getRole();
      DinasModel filterDinas = selectedDinas;
      final startController = TextEditingController(text: selectedStartDate);
      final endController = TextEditingController(text: selectedEndDate);
      return SafeArea(
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 32,
            constraints: const BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Filter', style: interHeadlineSemibold),
                  SizedBox(height: 24),
                  if (['Diskominfo', 'Auditor'].contains(role)) ...[
                    BlocBuilder<DinasBloc, DinasState>(
                      builder: (context, state) {
                        List<DinasModel> listDinas = [];

                        if (state is DinasLoaded) {
                          listDinas = [
                            DinasModel(id: 0, nama: 'Semua Dinas'),
                            ...state.listDinas.map((e) => e),
                          ];
                        }

                        return CustomDropdownGeneric<DinasModel>(
                          title: 'Dinas',
                          selectedItem: filterDinas,
                          onChanged: (value) {
                            if (value != null) {
                              filterDinas = value;
                            }
                          },

                          items: listDinas,
                          itemAsString: (d) => d.nama,
                          compareFn: (a, b) => a == b,
                          hintText: 'Pilih dinas',
                          validator: (p0) => null,
                        );
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                  CustomDateForm(
                    title: 'Tanggal Mulai',
                    placeholder: 'Pilih tanggal',
                    tanggalController: startController,
                  ),
                  SizedBox(height: 16),
                  CustomDateForm(
                    title: 'Tanggal Selesai',
                    placeholder: 'Pilih tanggal',
                    tanggalController: endController,
                  ),
                  SizedBox(height: 24),
                  CustomFilledButton(
                    title: 'Tampilkan',
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      NavigationHelper.pop(context, {
                        'newDinas': filterDinas,
                        'newStartDate': startController.text,
                        'newEndDate': endController.text,
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  CustomOutlineButton(
                    title: 'Reset',
                    textColor: Color(0xFFF22121),
                    onPressed: () async {
                      NavigationHelper.pop(context, {
                        'newDinas': DinasModel(id: 0, nama: 'Semua Dinas'),
                        'newStartDate': null,
                        'newEndDate': null,
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
