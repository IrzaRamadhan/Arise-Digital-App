import 'package:arise/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import '../../helper/cek_internet_helper.dart';
import '../snackbar.dart';

class NewPageErrorIndicator extends StatelessWidget {
  final VoidCallback onRetry;

  const NewPageErrorIndicator({super.key, required this.onRetry});

  Future<void> _handleRetry(BuildContext context) async {
    bool isConnected = await hasInternetConnection();
    if (isConnected) {
      onRetry();
    } else {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Periksa Koneksi Internet Anda',
          isSuccess: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: IconButton(
          icon: Icon(Hicons.refresh1LightOutline, color: primary1),
          onPressed: () => _handleRetry(context),
        ),
      ),
    );
  }
}
