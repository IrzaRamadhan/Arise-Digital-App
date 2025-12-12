import 'package:flutter/material.dart';

import '../../../helper/navigation_helper.dart';
import '../../../widgets/card_menu.dart';
import 'aset_sdm/aset_sdm_page.dart';
import 'aset_sdm/asset_sdm_unverif_page.dart';

class MenuAsetSdmPage extends StatelessWidget {
  const MenuAsetSdmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen Aset Sdm')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu(
              title: 'Butuh Verifikasi',
              imgAsset: 'assets/images/ic_butuh_verifikasi.png',
              onTap: () {
                NavigationHelper.push(context, AssetSdmUnverifPage());
              },
            ),
            CardMenu(
              title: 'Semua Aset',
              imgAsset: 'assets/images/ic_aset_sdm.png',
              onTap: () {
                NavigationHelper.push(context, AsetSdmPage(showAction: false));
              },
            ),
          ],
        ),
      ),
    );
  }
}
