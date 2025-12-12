import 'package:flutter/material.dart';

import '../../../../shared/theme.dart';

class BantuanHeaderItem extends StatelessWidget {
  const BantuanHeaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      color: primary1,
      child: Row(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset('assets/images/bantuan.png', width: 130),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bantuan Aplikasi ARISE!',
                  style: interBodyLargeBold.copyWith(color: Colors.white),
                ),
                Text(
                  'Temukan panduan, jawaban, dan dukungan untuk memudahkan Anda dalam mengelola aset TI maupun non-TI.',
                  style: interBodySmallRegular.copyWith(
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
