import 'package:arise/helper/navigation_helper.dart';
import 'package:arise/presentation/login/login_page.dart';
import 'package:arise/shared/theme.dart';
import 'package:arise/widgets/buttons.dart';
import 'package:flutter/material.dart';

class SuccessResetPage extends StatelessWidget {
  const SuccessResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/success.png', width: 100),
                SizedBox(height: 16),
                Text(
                  'Kata Sandi Berhasil Diubah!',
                  style: interBodyMediumSemibold.copyWith(
                    color: Color(0xFF2B2929),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Kata sandi baru anda berhasil disimpan!',
                  style: interBodySmallRegular.copyWith(
                    color: Color(0xFF2B2929),
                  ),
                ),
                SizedBox(height: 32),
                CustomFilledButton(
                  title: 'Kembali ke Login',
                  onPressed: () {
                    NavigationHelper.pushAndRemoveUntil(context, LoginPage());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
