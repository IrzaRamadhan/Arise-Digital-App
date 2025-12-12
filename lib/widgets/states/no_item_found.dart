import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class NoItemsFoundIndicator extends StatelessWidget {
  const NoItemsFoundIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_data.png', width: 100),
          const SizedBox(height: 16),
          Text(
            'Tidak ada data',
            style: interBodySmallRegular.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
