import 'package:arise/presentation/master_data/sub_kategori/sub_kategori_page.dart';
import 'package:arise/presentation/master_data/vendor/vendor_page.dart';
import 'package:flutter/material.dart';

import '../../helper/navigation_helper.dart';
import '../../widgets/card_menu.dart';
import 'lokasi/lokasi_page.dart';

class MasterDataPage extends StatelessWidget {
  const MasterDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Master Data')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu(
              title: 'Lokasi',
              imgAsset: 'assets/images/ic_lokasi.png',
              onTap: () {
                NavigationHelper.push(context, LokasiPage());
              },
            ),
            CardMenu(
              title: 'Vendor',
              imgAsset: 'assets/images/ic_vendor.png',
              onTap: () {
                NavigationHelper.push(context, VendorPage());
              },
            ),
            CardMenu(
              title: 'Sub Kategori',
              imgAsset: 'assets/images/ic_subkategori.png',
              onTap: () {
                NavigationHelper.push(context, SubKategoriPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
