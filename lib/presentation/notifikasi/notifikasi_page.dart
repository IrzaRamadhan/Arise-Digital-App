import 'package:arise/shared/theme.dart';
import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(title: Text('Notifikasi')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            color: const Color.fromRGBO(255, 255, 255, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Color(0xFF90CDF4),
                    border: Border.all(color: Color(0xFF4299E1)),
                    shape: BoxShape.circle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/ic_aset.png', width: 32),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengajuan Penghentian Asset',
                              style: interBodySmallSemibold,
                            ),
                            Text(
                              'Baru saja',
                              style: interSmallRegular.copyWith(
                                color: Color(0xFFA5ACB8),
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFE1E1E1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Pengajuan decommission asset oleh Admin Dinas Kesehatan',
                                style: interSmallRegular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
