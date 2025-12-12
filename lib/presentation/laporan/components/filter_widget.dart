import 'package:arise/data/models/dinas_model.dart';
import 'package:arise/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import '../../../helper/download_document.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/snackbar.dart';

class LaporanFilterWidget extends StatelessWidget {
  final DinasModel selectedDinas;
  final String? selectedStartDate;
  final String? selectedEndDate;
  final VoidCallback onTapFilter;
  final String urlApi; //main only
  const LaporanFilterWidget({
    super.key,
    required this.selectedDinas,
    this.selectedStartDate,
    this.selectedEndDate,
    required this.onTapFilter,
    required this.urlApi,
  });

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Column(
      spacing: 16,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Expanded(
              child: Column(
                children: [
                  if (['Diskominfo', 'Auditor'].contains(role))
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 54,
                          child: Text('Dinas', style: interBodySmallRegular),
                        ),
                        Text(' : ', style: interBodySmallMedium),
                        Expanded(
                          child: Text(
                            selectedDinas.nama,
                            style: interBodySmallMedium,
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      SizedBox(
                        width: 54,
                        child: Text('Periode', style: interBodySmallRegular),
                      ),
                      Text(' : ', style: interBodySmallMedium),
                      Expanded(
                        child: Text(
                          '${(selectedStartDate?.isNotEmpty ?? false) ? selectedStartDate : '-'}'
                          ' s/d '
                          '${(selectedEndDate?.isNotEmpty ?? false) ? selectedEndDate : '-'}',
                          style: interBodySmallMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: onTapFilter,
              child: Container(
                height: 44,
                width: 44,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEAE9EA)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Hicons.filter5Bold, color: Color(0xFFF58612)),
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomFilledButton(
              title: 'EXCEL',
              height: 40,
              width: 100,
              icon: Hicons.downloadBold,
              backgroundColor: success600,
              reverse: true,
              onPressed: () async {
                final service = LaporanService(
                  urlApi: '/api/laporan/$urlApi/export-excel',
                  dinasId: selectedDinas.id == 0 ? null : selectedDinas.id,
                  startDate: selectedStartDate,
                  endDate: selectedEndDate,
                );
                final success = await service.exportLaporanFile();

                if (context.mounted) {
                  if (success) {
                    showCustomSnackbar(
                      context: context,
                      message: 'File berhasil diunduh ke folder Downloads!',
                      isSuccess: true,
                    );
                  } else {
                    showCustomSnackbar(
                      context: context,
                      message: 'Gagal mengunduh file.',
                      isSuccess: false,
                    );
                  }
                }
              },
            ),
            CustomFilledButton(
              title: 'PDF',
              height: 40,
              width: 100,
              icon: Hicons.downloadBold,
              backgroundColor: danger600,
              reverse: true,
              onPressed: () async {
                final service = LaporanService(
                  urlApi: '/api/laporan/$urlApi/export-pdf',
                  dinasId: selectedDinas.id == 0 ? null : selectedDinas.id,
                  startDate: selectedStartDate,
                  endDate: selectedEndDate,
                );
                final success = await service.exportLaporanFile();

                if (context.mounted) {
                  if (success) {
                    showCustomSnackbar(
                      context: context,
                      message: 'File berhasil diunduh ke folder Downloads!',
                      isSuccess: true,
                    );
                  } else {
                    showCustomSnackbar(
                      context: context,
                      message: 'Gagal mengunduh file.',
                      isSuccess: false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
