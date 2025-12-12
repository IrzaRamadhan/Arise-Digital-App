import 'package:flutter/material.dart';

import '../../../../helper/cek_internet_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/snackbar.dart';

Future<Map<String, dynamic>?> showAsetBarangSorterDialog({
  required BuildContext context,
  required String selectedSortField,
  required String selectedSortOrder,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      String sortField = selectedSortField;
      String sortOrder = selectedSortOrder;

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
                  Text('Urutkan', style: interHeadlineSemibold),
                  SizedBox(height: 24),

                  // PILIH FIELD SORTING
                  CustomDropdown(
                    selectedValue: sortField,
                    title: 'Urutkan Berdasarkan',
                    placeholder: 'Pilih Field',
                    listItem: [
                      'kode_bmd',
                      'nama_asset',
                      'kategori',
                      'status',
                      'created_at',
                    ],
                    onChanged: (value) {
                      if (value != null) sortField = value;
                    },
                  ),

                  SizedBox(height: 16),

                  // PILIH ORDER
                  CustomDropdown(
                    selectedValue: sortOrder,
                    title: 'Urutan',
                    placeholder: 'Pilih Urutan',
                    listItem: ['asc', 'desc'],
                    onChanged: (value) {
                      if (value != null) sortOrder = value;
                    },
                  ),

                  SizedBox(height: 24),

                  CustomFilledButton(
                    title: 'Tampilkan',
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      bool isConnected = await hasInternetConnection();

                      if (isConnected) {
                        if (context.mounted) {
                          Navigator.pop(context, {
                            'sort': sortField,
                            'order': sortOrder,
                          });
                        }
                      } else {
                        if (context.mounted) {
                          showCustomSnackbar(
                            context: context,
                            message: 'Periksa Koneksi Internet Anda',
                            isSuccess: false,
                          );
                        }
                      }
                    },
                  ),

                  SizedBox(height: 16),

                  CustomOutlineButton(
                    title: 'Reset',
                    textColor: const Color(0xFFF22121),
                    onPressed: () async {
                      bool isConnected = await hasInternetConnection();

                      if (isConnected) {
                        if (context.mounted) {
                          Navigator.pop(context, {
                            'sort': 'created_at',
                            'order': 'desc',
                          });
                        }
                      } else {
                        if (context.mounted) {
                          showCustomSnackbar(
                            context: context,
                            message: 'Periksa Koneksi Internet Anda',
                            isSuccess: false,
                          );
                        }
                      }
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
