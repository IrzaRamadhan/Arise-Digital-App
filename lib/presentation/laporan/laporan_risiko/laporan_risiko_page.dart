import 'package:arise/presentation/laporan/laporan_risiko/nilai_risiko/nilai_risiko_page.dart';
import 'package:flutter/material.dart';

import '../../../helper/navigation_helper.dart';
import '../../../widgets/card_menu.dart';

class LaporanRisikoPage extends StatelessWidget {
  const LaporanRisikoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan Risiko')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu2(
              title: 'Nilai Risiko Aset',
              subtitle: 'Laporan penilaian risiko aset SPBE',
              imgAsset: 'assets/images/ic_nilai_risiko.png',
              onTap: () {
                NavigationHelper.push(context, NilaiRisikoPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
