import 'package:flutter/material.dart';

import '../../../../helper/cek_internet_helper.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/snackbar.dart';

Future<Map<String, dynamic>?> showAsetBarangFilterDialog({
  required BuildContext context,
  required String selectedKategori,
  required String selectedStatus,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      String filterKategori = selectedKategori;
      String filterStatus = selectedStatus;
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
                  CustomDropdown(
                    selectedValue: filterKategori,
                    title: 'Kategori',
                    placeholder: 'Pilih Kategori',
                    listItem: ['Semua Kategori', 'TI', 'Non-TI'],
                    onChanged: (value) {
                      if (value != null) {
                        filterKategori = value;
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  CustomDropdown(
                    selectedValue: filterStatus,
                    title: 'Status',
                    placeholder: 'Pilih Status',
                    listItem: [
                      'Semua Status',
                      'Pending',
                      'Aktif',
                      'Non-Aktif',
                      'Pemeliharaan',
                      'Ditolak',
                      'Dihapus',
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        filterStatus = value;
                      }
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
                          NavigationHelper.pop(context, {
                            'newKategori': filterKategori,
                            'newStatus': filterStatus,
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
                    textColor: Color(0xFFF22121),
                    onPressed: () async {
                      bool isConnected = await hasInternetConnection();
                      if (isConnected) {
                        if (context.mounted) {
                          NavigationHelper.pop(context, {
                            'newKategori': 'Semua Kategori',
                            'newStatus': 'Semua Kategori',
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
