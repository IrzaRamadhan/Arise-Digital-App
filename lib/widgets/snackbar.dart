import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:solar_icon_pack/solar_icon_pack.dart';

import '../shared/theme.dart';

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  required bool isSuccess,
}) {
  Flushbar(
    messageText: Row(
      children: [
        Icon(
          isSuccess
              ? SolarBoldIcons.checkCircle
              : SolarBoldIcons.dangerTriangle,
          color: isSuccess ? success600 : danger600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: interBodySmallMedium.copyWith(
              color: isSuccess ? success600 : danger600,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(21),
    padding: const EdgeInsets.all(10),
    backgroundColor: isSuccess ? success100 : danger100,
    borderRadius: BorderRadius.circular(8),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
  ).show(context);
}
