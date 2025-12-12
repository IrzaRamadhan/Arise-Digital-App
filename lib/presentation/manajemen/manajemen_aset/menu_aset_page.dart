import 'package:flutter/material.dart';

import '../../../data/services/auth_service.dart';
import '../../../helper/navigation_helper.dart';
import '../../../widgets/card_menu.dart';
import 'aset_barang/aset_barang_page.dart';
import 'aset_sdm/aset_sdm_page.dart';
import 'menu_aset_barang_page.dart';
import 'menu_aset_sdm_page.dart';

class MenuAsetPage extends StatelessWidget {
  const MenuAsetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen Aset')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu(
              title: 'Aset Barang',
              imgAsset: 'assets/images/ic_aset_barang.png',
              onTap: () {
                if (role == 'Verifikator') {
                  NavigationHelper.push(context, MenuAsetBarangPage());
                } else {
                  NavigationHelper.push(context, AsetBarangPage());
                }
              },
            ),
            CardMenu(
              title: 'Aset SDM',
              imgAsset: 'assets/images/ic_aset_sdm.png',
              onTap: () {
                if (role == 'Verifikator') {
                  NavigationHelper.push(context, MenuAsetSdmPage());
                } else {
                  NavigationHelper.push(context, AsetSdmPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
