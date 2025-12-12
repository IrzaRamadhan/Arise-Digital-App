import 'package:arise/data/services/auth_service.dart';
import 'package:arise/presentation/base/base_page.dart';
import 'package:arise/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../helper/navigation_helper.dart';
import '../login/login_page.dart';
import '../onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    final credBox = Hive.box('credentials');
    final isFirstInstall = credBox.get('isFirstInstall', defaultValue: true);

    if (mounted) {
      if (isFirstInstall) {
        NavigationHelper.pushAndRemoveUntil(context, const OrboardingPage());
      } else {
        String token = AuthService().getToken();
        if (token != '') {
          NavigationHelper.pushAndRemoveUntil(context, const BasePage());
        } else {
          NavigationHelper.pushAndRemoveUntil(context, const LoginPage());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary1,
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/images/logo_white.png', width: 180),
        ),
      ),
    );
  }
}
