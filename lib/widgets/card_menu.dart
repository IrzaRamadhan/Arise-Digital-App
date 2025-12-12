import 'package:flutter/material.dart';

import '../shared/theme.dart';

class CardMenu extends StatelessWidget {
  final String title;
  final String imgAsset;
  final VoidCallback onTap;
  const CardMenu({
    super.key,
    required this.title,
    required this.imgAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE4E4E4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              offset: const Offset(0, 4),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          spacing: 4,
          children: [
            Image.asset(imgAsset, width: 32),
            Text(title, style: interSmallRegular, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class CardMenu2 extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imgAsset;
  final VoidCallback onTap;
  const CardMenu2({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imgAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xFFE4E4E4)),
          boxShadow: listShadow2,
        ),
        child: Row(
          spacing: 16,
          children: [
            Image.asset(imgAsset, width: 32),
            Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: interBodyMediumSemibold),
                Text(
                  subtitle,
                  style: interSmallRegular.copyWith(color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
