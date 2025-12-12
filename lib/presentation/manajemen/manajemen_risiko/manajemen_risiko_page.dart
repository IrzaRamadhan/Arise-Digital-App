import 'package:arise/data/services/auth_service.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penilaian_risiko/penilaian_risiko_page.dart';
import 'package:flutter/material.dart';

import '../../../helper/navigation_helper.dart';
import '../../../widgets/card_menu.dart';
import 'penetapan_konteks/penetapan_konteks_page.dart';

class ManajemenRisikoPage extends StatelessWidget {
  const ManajemenRisikoPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen Risiko')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            CardMenu(
              title: 'Penetapan konteks',
              imgAsset: 'assets/images/ic_penetapan_konteks.png',
              onTap: () {
                NavigationHelper.push(context, PenetapanKonteksPage());
              },
            ),
            if (['Diskominfo'].contains(role))
              CardMenu(
                title: 'Penilaian Risiko',
                imgAsset: 'assets/images/ic_penilaian_risiko.png',
                onTap: () {
                  NavigationHelper.push(context, PenilaianRisikoPage());
                },
              ),
          ],
        ),
      ),
    );
  }
}
