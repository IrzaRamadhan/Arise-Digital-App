import 'dart:math';

import 'package:arise/helper/navigation_helper.dart';
import 'package:arise/presentation/login/login_page.dart';
import 'package:arise/shared/theme.dart';
import 'package:arise/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OrboardingPage extends StatefulWidget {
  const OrboardingPage({super.key});

  @override
  State<OrboardingPage> createState() => _OrboardingPageState();
}

class _OrboardingPageState extends State<OrboardingPage> {
  final _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    var box = Hive.box('credentials');
    box.put('isFirstInstall', false);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool smallDevice =
        (screenWidth <= 320 && screenHeight < 600) ||
        (screenWidth > 320 && screenWidth < 412 && screenHeight < 650) ||
        (screenWidth >= 412 && screenHeight < 732);

    final imageWidth = min(screenWidth - 72, 360.0);
    final aspectRatio = 344 / 374;
    final imageHeight = imageWidth / aspectRatio;
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(toolbarHeight: 0),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: imageHeight,
                    child: PageView.builder(
                      controller: _controller,
                      onPageChanged: (index) => _indexNotifier.value = index,
                      itemCount: 3,
                      itemBuilder:
                          (context, index) => Image.asset(
                            'assets/images/onboarding_${index + 1}.png',
                            width: imageWidth,
                            height: imageHeight,
                            fit: BoxFit.contain,
                          ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ValueListenableBuilder<int>(
                    valueListenable: _indexNotifier,
                    builder: (context, index, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (dotIndex) {
                          bool isActive = dotIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: isActive ? 32 : 8,
                            decoration: BoxDecoration(
                              color: Color(0xFFF58612),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: listShadow,
              ),
              child: Column(
                children: [
                  if (!smallDevice) ...[
                    Image.asset('assets/images/logo_color.png', width: 65),
                    SizedBox(height: 8),
                  ],
                  SizedBox(height: 16),
                  ValueListenableBuilder<int>(
                    valueListenable: _indexNotifier,
                    builder: (context, index, _) {
                      return Text(
                        index == 0
                            ? 'Kelola Aset dengan Efektif, Transparan, dan Terintegrasi'
                            : index == 1
                            ? 'Semua data aset tercatat dengan rapi, akurat, dan dapat diakses kapan pun.'
                            : 'Optimalkan operasional dengan fitur lengkap mempermudah pengelolaan aset Anda.',
                        style: interBodyLargeSemibold.copyWith(
                          color: Color(0xFF3B3B3B),
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  CustomFilledButton(
                    title: 'Masuk',
                    onPressed: () {
                      NavigationHelper.pushAndRemoveUntil(context, LoginPage());
                    },
                  ),
                  SizedBox(height: 24),
                  // CustomOutlineButton(title: 'Daftar', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
