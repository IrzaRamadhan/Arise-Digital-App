import 'package:arise/helper/navigation_helper.dart';
import 'package:arise/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../helper/cek_internet_helper.dart';
import '../../shared/theme.dart';
import '../snackbar.dart';

class ErrorStateWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String errorType; // "Not Found" / "Connection" / "Server Error"

  const ErrorStateWidget({
    super.key,
    required this.onTap,
    required this.errorType,
  });

  Future<void> _handleTap(BuildContext context) async {
    bool isConnected = await hasInternetConnection();
    if (isConnected) {
      if (context.mounted) {
        onTap();
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
    String message;
    String subMessage;
    String assetImage;
    if (errorType == 'Not Found') {
      message = 'Belum Ada Data yang Tersedia';
      subMessage =
          'Sepertinya belum ada data yang bisa ditampilkan saat ini. Coba periksa kembali atau tambahkan data baru.';
      assetImage = 'assets/images/no_data.png';
    } else if (errorType == 'Connection') {
      message = 'Koneksi Anda Terputus!';
      subMessage =
          'Kami tidak dapat terhubung ke server.\nPastikan perangkatmu terhubung ke internet dan coba lagi';
      assetImage = 'assets/images/connection_error.png';
    } else {
      message = 'Terjadi Kesalahan Pada Server!';
      subMessage =
          'Ups! Ada kendala di sisi server kami.\nTim sedang berusaha memperbaikinya. Silakan coba beberapa saat lagi.';
      assetImage = 'assets/images/server_error.png';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(assetImage, width: 100),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 320,
            child: Center(
              child: Column(
                spacing: 8,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: interBodyMediumSemibold.copyWith(
                      color: Color(0xFF2B2929),
                    ),
                  ),
                  Text(
                    subMessage,
                    textAlign: TextAlign.center,
                    style: interSmallRegular.copyWith(color: Color(0xFF939597)),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (errorType != 'Not Found') ...[
          CustomFilledButton(
            title: errorType == 'Connection' ? 'Coba Lagi' : 'Kembali',
            onPressed: () async {
              if (errorType == 'Connection') {
                _handleTap(context);
              } else {
                NavigationHelper.pop(context);
              }
            },
          ),
        ],
      ],
    );
  }
}

// class ErrorStateWithoutImageWidget extends StatelessWidget {
//   final VoidCallback onTap;
//   final String errorType; // "Connection" / "Server Error"
//   const ErrorStateWithoutImageWidget({
//     super.key,
//     required this.onTap,
//     required this.errorType,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           border: Border.all(color: dangerDefaultColor),
//           borderRadius: BorderRadius.circular(4),
//         ),
//         child: Center(
//           child: Text(
//             errorType == 'Connection'
//                 ? 'Periksa Koneksi Internet Anda'
//                 : 'Server Error, Muat Ulang',
//             style: bodySmallRegular.copyWith(color: dangerDefaultColor),
//           ),
//         ),
//       ),
//     );
//   }
// }
