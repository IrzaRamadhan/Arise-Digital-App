import 'package:arise/data/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../helper/navigation_helper.dart';
import '../../widgets/card_menu.dart';
import 'bantuan/bantuan_page.dart';
import 'manajemen_akun/manajemen_akun_page.dart';
import 'manajemen_aset/menu_aset_page.dart';
import '../master_data/master_data_page.dart';
import 'manajemen_risiko/manajemen_risiko_page.dart';

class ManajemenMenuPage extends StatelessWidget {
  const ManajemenMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen')),
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
            title: 'Manajemen\nAset',
            imgAsset: 'assets/images/inventaris_aset.png',
            onTap: () {
              NavigationHelper.push(context, MenuAsetPage());
            },
          ),
          CardMenu(
            title: 'Manajemen\nRisiko',
            imgAsset: 'assets/images/laporan_aset.png',
            onTap: () {
              NavigationHelper.push(context, ManajemenRisikoPage());
            },
          ),
          CardMenu(
            title: 'FAQ & \nBantuan',
            imgAsset: 'assets/images/manajemen_bantuan.png',
            onTap: () {
              NavigationHelper.push(context, BantuanPage());
            },
          ),
          if (role == 'Diskominfo')
            CardMenu(
              title: 'Manajemen\nAkun',
              imgAsset: 'assets/images/manajemen_akun.png',
              onTap: () {
                NavigationHelper.push(context, ManajemenAkunPage());
              },
            ),
          if (role == 'Diskominfo')
            CardMenu(
              title: 'Master\nData',
              imgAsset: 'assets/images/ic_master_data.png',
              onTap: () {
                NavigationHelper.push(context, MasterDataPage());
              },
            ),
        ],
      ),
    );
  }
}
