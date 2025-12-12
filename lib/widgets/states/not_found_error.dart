import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class NotFoundError extends StatelessWidget {
  const NotFoundError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset('assets/images/not_found.webp', width: 184),
          // const SizedBox(height: 16),
          Text(
            'Data sudah dihapus atau\ntidak tersedia.',
            style: interBodySmallRegular.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
