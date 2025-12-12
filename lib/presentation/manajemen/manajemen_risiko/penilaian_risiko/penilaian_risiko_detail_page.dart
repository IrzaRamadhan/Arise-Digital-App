import 'package:arise/controllers/asset_controller.dart';
import 'package:arise/controllers/penilaian_risiko_controller.dart';
import 'package:arise/data/models/penilaian_risiko_model.dart';
import 'package:arise/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../bloc/asset/asset_bloc.dart';
import '../../../../../bloc/asset_barang/asset_barang_bloc.dart';
import '../../../../../data/models/asset_model.dart';
import '../../../../../shared/shared_method.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/badge.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/confirmation_dialog.dart';
import '../../../../../widgets/snackbar.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../manajemen_aset/components/detail_link_item.dart';
import '../../manajemen_aset/components/detail_text_item.dart';

class PenilaianRisikoDetailPage extends StatelessWidget {
  final PenilaianRisikoModel risiko;
  const PenilaianRisikoDetailPage({super.key, required this.risiko});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Penilaian Risiko')),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xFF2B3791).withValues(alpha: 0.2),
                ),
                boxShadow: listShadow2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(risiko.judulRisiko ?? '-', style: interBodyMediumBold),
                  Divider(),
                  Text(
                    'Informasi Dasar',
                    style: interBodyMediumBold.copyWith(color: primary1),
                  ),
                  SizedBox(height: 4),
                  DetailTextItem(
                    title: 'Dinas',
                    value: risiko.asset.unitKerja!.dinas.nama,
                  ),
                  DetailTextItem(
                    title: 'Dibuat oleh',
                    value: risiko.asset.unitKerja!.dinas.nama,
                  ),
                  DetailTextItem(
                    title: 'Aset Terkait',
                    value: risiko.asset.namaAsset,
                  ),
                  DetailTextItem(
                    title: 'Deskripsi Risiko',
                    value: risiko.deskripsiRisiko ?? '-',
                  ),

                  Divider(),
                  Text(
                    'Analisis Risiko',
                    style: interBodyMediumBold.copyWith(color: primary1),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetailTextItem(
                              title: 'Area Dampak',
                              value: risiko.areaDampak.nama,
                            ),
                            DetailTextItem(
                              title: 'Level Kemungkinan',
                              value: risiko.levelKemungkinan.nama,
                            ),
                            DetailTextItem(
                              title: 'Level Dampak',
                              value: risiko.levelDampak.nama,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Besaran Risiko', style: interSmallRegular),
                            SizedBox(height: 4),
                            StatusBadge5(status: risiko.nilaiResiko ?? '-'),
                            SizedBox(height: 12),
                            Text('Kategori Risiko', style: interSmallRegular),
                            SizedBox(height: 4),
                            StatusBadge6(
                              status: risiko.labelKlasifikasi ?? '-',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Text(
                    'Detail Risiko',
                    style: interBodyMediumBold.copyWith(color: primary1),
                  ),
                  SizedBox(height: 4),
                  DetailTextItem(
                    title: 'Dinas',
                    value: risiko.asset.unitKerja!.dinas.nama,
                  ),
                  DetailTextItem(
                    title: 'Penyebab Risiko',
                    value: risiko.penyebabRisiko ?? '-',
                  ),
                  Divider(),
                  Text(
                    'Mitigasi & Rencana Tindak Lanjut',
                    style: interBodyMediumBold.copyWith(color: primary1),
                  ),
                  SizedBox(height: 4),
                  DetailTextItem(
                    title: 'Strategi Mitigasi Risiko',
                    value: risiko.mitigasiRisiko ?? '-',
                  ),
                  DetailTextItem(
                    title: 'Rencana Tindak Lanjut',
                    value: risiko.rencanaTindakLanjut ?? '-',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
