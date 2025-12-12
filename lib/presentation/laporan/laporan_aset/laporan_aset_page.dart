import 'package:arise/presentation/laporan/laporan_aset/inventarisasi/inventarisasi_page.dart';
import 'package:arise/presentation/laporan/laporan_aset/laporan_insiden/laporan_insiden_page.dart';
import 'package:arise/presentation/laporan/laporan_aset/non_aktif/non_aktif_page.dart';
import 'package:arise/presentation/laporan/laporan_aset/rekap_nilai/rekap_nilai_page.dart';
import 'package:arise/presentation/laporan/laporan_aset/riwayat_pemeliharaan/riwayat_pemeliharaan_page.dart';
import 'package:flutter/material.dart';

import '../../../helper/navigation_helper.dart';
import '../../../widgets/card_menu.dart';

class LaporanAsetPage extends StatelessWidget {
  const LaporanAsetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Aset')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu2(
              title: 'Inventarisasi Aset Dinas',
              subtitle: 'Laporan daftar inventaris aset per dinas',
              imgAsset: 'assets/images/inventaris_aset.png',
              onTap: () {
                NavigationHelper.push(context, InventarisasiPage());
              },
            ),
            CardMenu2(
              title: 'Riwayat Pemeliharaan Aset',
              subtitle: 'History pemeliharaan aset barang',
              imgAsset: 'assets/images/inventaris_aset.png',
              onTap: () {
                NavigationHelper.push(context, RiwayatPemeliharaanPage());
              },
            ),
            CardMenu2(
              title: 'Laporan Insiden',
              subtitle: 'Laporan pemeliharaan insidental',
              imgAsset: 'assets/images/inventaris_aset.png',
              onTap: () {
                NavigationHelper.push(context, LaporanInsidenPage());
              },
            ),
            CardMenu2(
              title: 'Rekap Nilai Aset',
              subtitle: 'rekapitulasi nilai perolehan aset',
              imgAsset: 'assets/images/inventaris_aset.png',
              onTap: () {
                NavigationHelper.push(context, RekapNilaiPage());
              },
            ),
            CardMenu2(
              title: 'Aset Non Aktif & Dihapus',
              subtitle: 'Laporan aset yang non-aktif dan dihapus',
              imgAsset: 'assets/images/inventaris_aset.png',
              onTap: () {
                NavigationHelper.push(context, NonAktifPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
