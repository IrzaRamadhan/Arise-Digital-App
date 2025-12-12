import 'forms.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import 'buttons.dart';
import 'package:flutter/material.dart';

import '../../../shared/theme.dart';

Future<void> showConfirmationDecommissionDialog({
  required BuildContext context,
  required Future<void> Function(String inputText) onConfirm,
  VoidCallback? onCancel,
}) {
  final inputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(dialogContext).size.width - 32,
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ajukan Decommission', style: interBodyMediumMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1), // warning soft
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(
                          Hicons.dangerCircleBold,
                          color: const Color(0xFFF57C00),
                        ),
                        Expanded(
                          child: Text(
                            'Pengajuan decommission akan menghentikan operasional aset setelah disetujui verifikator.',
                            style: poppinsSmallMedium.copyWith(
                              color: const Color(0xFFF57C00),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomOutlineForm(
                    controller: inputController,
                    title: 'Alasan Decommission',
                    placeholder: 'Masukkan alasan',
                    badgeRequired: true,
                    minLines: 3,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Alasan wajib diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  CustomFilledButton(
                    title: 'Konfirmasi',
                    height: 37,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final inputValue = inputController.text.trim();
                      Navigator.of(dialogContext).pop();

                      if (context.mounted) {
                        await onConfirm(inputValue);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomFilledButton(
                    title: 'Batal',
                    height: 37,
                    backgroundColor: Colors.white,
                    textColor: primary1,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
