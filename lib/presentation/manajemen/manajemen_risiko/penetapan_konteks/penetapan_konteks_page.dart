import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/area_dampak/area_dampak_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/informasi_umum/informasi_umum_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/kategori_risiko/kategori_risiko_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/level_dampak/level_dampak_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/level_kemungkinan/level_kemungkinan_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/matriks_risiko/matriks_risiko_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/peraturan/peraturan_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/sasaran_risiko/sasaran_risiko_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/stakeholders/stakeholders_page.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penetapan_konteks/struktur_pelaksana/struktur_pelaksana_page.dart';
import 'package:flutter/material.dart';

import '../../../../helper/navigation_helper.dart';
import '../../../../widgets/card_menu.dart';

class PenetapanKonteksPage extends StatelessWidget {
  const PenetapanKonteksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Penetapan konteks')),
      body: GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        childAspectRatio: 169 / 102,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CardMenu(
            title: 'Informasi\nUmum',
            imgAsset: 'assets/images/ic_informasi_umum.png',
            onTap: () {
              NavigationHelper.push(context, InformasiUmumPage());
            },
          ),
          CardMenu(
            title: 'Sasaran\nRisiko',
            imgAsset: 'assets/images/ic_sasaran_risiko.png',
            onTap: () {
              NavigationHelper.push(context, SasaranRisikoPage());
            },
          ),
          CardMenu(
            title: 'Peraturan\n& Regulasi',
            imgAsset: 'assets/images/ic_pengaturan_regulasi.png',
            onTap: () {
              NavigationHelper.push(context, PeraturanPage());
            },
          ),
          CardMenu(
            title: 'Struktur\nPelaksana',
            imgAsset: 'assets/images/ic_struktur_pelaksana.png',
            onTap: () {
              NavigationHelper.push(context, StrukturPelaksanaPage());
            },
          ),
          CardMenu(
            title: 'Pemangku\nKebijakan',
            imgAsset: 'assets/images/ic_pemangku_kebijakan.png',
            onTap: () {
              NavigationHelper.push(context, StakeholdersPage());
            },
          ),
          CardMenu(
            title: 'Kategori\nRisiko',
            imgAsset: 'assets/images/ic_kategori_risiko.png',
            onTap: () {
              NavigationHelper.push(context, KategoriRisikoPage());
            },
          ),
          CardMenu(
            title: 'Area\nDampak',
            imgAsset: 'assets/images/ic_area_dampak.png',
            onTap: () {
              NavigationHelper.push(context, AreaDampakPage());
            },
          ),
          CardMenu(
            title: 'Level\nKemungkinan',
            imgAsset: 'assets/images/ic_level_kemungkinan.png',
            onTap: () {
              NavigationHelper.push(context, LevelKemungkinanPage());
            },
          ),
          CardMenu(
            title: 'Level\nDampak',
            imgAsset: 'assets/images/ic_level_dampak.png',
            onTap: () {
              NavigationHelper.push(context, LevelDampakPage());
            },
          ),
          CardMenu(
            title: 'Matriks\nRisiko',
            imgAsset: 'assets/images/ic_matriks_risiko.png',
            onTap: () {
              NavigationHelper.push(context, MatriksRisikoPage());
            },
          ),
        ],
      ),
    );
  }
}
