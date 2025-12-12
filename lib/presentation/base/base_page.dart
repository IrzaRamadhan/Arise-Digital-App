import 'package:arise/presentation/laporan/laporan_page.dart';
import 'package:arise/presentation/manajemen/manajemen_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import '../../data/services/auth_service.dart';
import '../../shared/theme.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';
import '../scan_qr_code/scan_qr_code_page.dart';

class BasePage extends StatefulWidget {
  final int index;
  const BasePage({super.key, this.index = 0});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int currentIndex = 0;
  String token = AuthService().getToken();
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(),
      ManajemenMenuPage(),
      ScanQrCodePage(),
      LaporanMenuPage(),
      ProfilePage(),
    ];
    currentIndex = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeScreen(int selectedIndex) {
    setState(() {
      currentIndex = selectedIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          boxShadow: listShadow,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: currentIndex,
            onTap: changeScreen,
            selectedLabelStyle: interSmallRegular,
            unselectedLabelStyle: interSmallRegular.copyWith(
              color: Colors.grey[500],
            ),
            iconSize: 32,
            selectedItemColor: primary1,
            unselectedItemColor: Colors.grey[500],
            showUnselectedLabels: true,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Hicons.home2LightOutline),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Hicons.menuCandyBoxBold),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Hicons.scan2LightOutline),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Hicons.documentAlignCenter2LightOutline),
                label: 'Laporan',
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Hicons.profile1LightOutline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
