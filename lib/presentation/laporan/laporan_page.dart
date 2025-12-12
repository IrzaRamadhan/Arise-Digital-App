import 'package:arise/presentation/laporan/laporan_aset/laporan_aset_page.dart';
import 'package:flutter/material.dart';

import '../../helper/navigation_helper.dart';
import '../../widgets/card_menu.dart';
import 'laporan_risiko/laporan_risiko_page.dart';

class LaporanMenuPage extends StatelessWidget {
  const LaporanMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu(
              title: 'Laporan Aset',
              imgAsset: 'assets/images/ic_laporan_aset.png',
              onTap: () {
                NavigationHelper.push(context, LaporanAsetPage());
              },
            ),
            CardMenu(
              title: 'Laporan Risiko',
              imgAsset: 'assets/images/ic_laporan_risiko.png',
              onTap: () {
                NavigationHelper.push(context, LaporanRisikoPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
