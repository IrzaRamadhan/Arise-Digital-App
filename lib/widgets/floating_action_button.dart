import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import '../shared/theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;
  const CustomFloatingActionButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFB4BAE6),
              offset: const Offset(0, 8),
              blurRadius: 16,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(Hicons.addSquareBold, color: primary1, size: 40),
      ),
    );
  }
}
