import 'forms.dart';
import 'package:flutter_hicons/flutter_hicons.dart';

import 'buttons.dart';
import 'dropdowns.dart';
import 'package:flutter/material.dart';

import '../../../shared/theme.dart';

Future<void> showConfirmationDisposalDialog({
  required BuildContext context,
  required Future<void> Function(String inputText, String method) onConfirm,
}) {
  final inputController = TextEditingController();
  String? selectedMethod;
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
                  Text('Ajukan Disposal', style: interBodyMediumMedium),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: danger100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      spacing: 8,
                      children: [
                        Icon(Hicons.dangerCircleBold, color: danger600),
                        Expanded(
                          child: Text(
                            'Pengajuan disposal akan menghapus asset dari sistem setelah disetujui verifikator. Proses ini tidak dapat dibatalkan.',
                            style: poppinsSmallMedium.copyWith(
                              color: danger600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomOutlineForm(
                    controller: inputController,
                    title: 'Alasan Disposal',
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
                  CustomDropdown(
                    selectedValue: selectedMethod,
                    title: 'Metode Disposal',
                    placeholder: 'Pilih metode disposal',
                    listItem: [
                      'Dijual',
                      'Dihibahkan',
                      'Dimusnahkan',
                      'Lainnya',
                    ],
                    onChanged: (value) {
                      selectedMethod = value;
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
                        await onConfirm(inputValue, selectedMethod!);
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
