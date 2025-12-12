import 'package:arise/shared/theme.dart';
import 'package:arise/widgets/snackbar.dart';
import 'package:flutter/material.dart';

import '../helper/cek_internet_helper.dart';

class CustomFilledButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool reverse;
  final double fontSize;
  final bool showIconAccept;
  final bool useCheckInternet;

  const CustomFilledButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 53,
    this.backgroundColor = const Color(0xff033E8A),
    this.textColor = const Color(0xffFBFBFB),
    required this.onPressed,
    this.icon,
    this.reverse = false,
    this.fontSize = 14,
    this.showIconAccept = false,
    this.useCheckInternet = false,
  });

  Future<void> _handleTap(BuildContext context) async {
    bool isConnected = await hasInternetConnection();
    if (isConnected) {
      if (context.mounted) {
        onPressed();
      }
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
      height: height,
      width: width,
      child: FilledButton(
        onPressed: () async {
          if (useCheckInternet) {
            _handleTap(context);
          } else {
            onPressed();
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: reverse ? TextDirection.rtl : null,
            children: [
              if (showIconAccept)
                Image.asset('assets/images/terima.png', width: 24),
              Text(
                title,
                style: poppinsBodySmallSemibold.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                ),
              ),
              if (icon != null) Icon(icon, color: textColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool reverse;
  final double fontSize;
  final IconData? icon;
  final bool showIconReject;
  final bool useCheckInternet;

  const CustomOutlineButton({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.height = 53,
    this.backgroundColor = const Color(0xffFBFBFB),
    this.textColor = const Color(0xff033E8A),
    required this.onPressed,
    this.reverse = false,
    this.fontSize = 14,
    this.icon,
    this.showIconReject = false,
    this.useCheckInternet = false,
  });

  Future<void> _handleTap(BuildContext context) async {
    bool isConnected = await hasInternetConnection();
    if (isConnected) {
      if (context.mounted) {
        onPressed();
      }
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
      height: height,
      width: width,
      child: FilledButton(
        onPressed: () async {
          if (useCheckInternet) {
            _handleTap(context);
          } else {
            onPressed();
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: textColor),
          ),
        ),
        child: Center(
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: reverse ? TextDirection.rtl : null,
            children: [
              if (showIconReject)
                Image.asset('assets/images/tolak.png', width: 24),
              Text(
                title,
                style: poppinsBodySmallSemibold.copyWith(
                  color: textColor,
                  fontSize: fontSize,
                ),
              ),
              if (icon != null) Icon(icon, color: textColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
