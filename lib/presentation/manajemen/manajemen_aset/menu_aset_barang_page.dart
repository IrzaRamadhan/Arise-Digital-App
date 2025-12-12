import 'package:arise/presentation/manajemen/manajemen_aset/aset_barang/asset_barang_unverif_page.dart';
import 'package:flutter/material.dart';

import '../../../helper/navigation_helper.dart';
import '../../../widgets/card_menu.dart';
import 'aset_barang/aset_barang_page.dart';

class MenuAsetBarangPage extends StatelessWidget {
  const MenuAsetBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen Aset Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu(
              title: 'Butuh Verifikasi',
              imgAsset: 'assets/images/ic_butuh_verifikasi.png',
              onTap: () {
                NavigationHelper.push(context, AssetBarangUnverifPage());
              },
            ),
            CardMenu(
              title: 'Semua Aset',
              imgAsset: 'assets/images/ic_aset_barang.png',
              onTap: () {
                NavigationHelper.push(
                  context,
                  AsetBarangPage(showAction: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
