import 'package:flutter/material.dart';

import '../../../shared/theme.dart';
import '../helper/cek_internet_helper.dart';
import 'buttons.dart';
import 'snackbar.dart';

Future<void> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  required Future<void> Function() onConfirm,
  VoidCallback? onCancel,
  String confirmText = 'Ya, saya yakin',
  String cancelText = 'Batal',
  bool useCheckInternet = true,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(dialogContext).size.width - 32,
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: interBodyMediumMedium),
              const SizedBox(height: 8),
              Text(
                description,
                style: interBodySmallRegular.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              CustomFilledButton(
                title: confirmText,
                height: 37,
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  if (!useCheckInternet) {
                    await onConfirm();
                    return;
                  }
                  bool isConnected = await hasInternetConnection();
                  if (!isConnected) {
                    if (context.mounted) {
                      showCustomSnackbar(
                        context: context,
                        message: 'Periksa Koneksi Internet Anda',
                        isSuccess: false,
                      );
                    }
                    return;
                  }
                  if (context.mounted) {
                    await onConfirm();
                  }
                },
              ),
              const SizedBox(height: 8),
              CustomFilledButton(
                title: cancelText,
                height: 37,
                backgroundColor: Colors.white,
                textColor: primary1,
                onPressed:
                    onCancel ??
                    () {
                      Navigator.of(dialogContext).pop();
                    },
              ),
            ],
          ),
        ),
      );
    },
  );
}
