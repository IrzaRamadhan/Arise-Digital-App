import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // pastikan sudah ditambahkan

// import 'package:flutter_downloader/flutter_downloader.dart';

import '../widgets/snackbar.dart';

// import '../components/snackbar.dart';

class FileHelper {
  /// Membuka PDF dari URL
  static Future<void> openPdf(
    BuildContext context,
    String url,
    String nameFile,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$nameFile.pdf');

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        OpenFile.open(file.path);
      } else {
        if (context.mounted) {
          showCustomSnackbar(
            context: context,
            message: 'Gagal membuka file PDF.',
            isSuccess: false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: 'Periksa Koneksi Internet Anda',
          isSuccess: false,
        );
      }
    }
  }

  Future<bool> startDownloadFile(String fileUrl) async {
    try {
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode != 200) {
        return false;
      }

      // Generate file name based on current datetime
      final now = DateTime.now();
      final formatted = DateFormat('yyyyMMdd_HHmmss').format(now);
      final fileName = '$formatted.pdf'; // ubah ekstensi jika perlu

      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      final file = File('${downloadsDir.path}/$fileName');

      await file.writeAsBytes(response.bodyBytes);

      return true;
    } catch (e) {
      return false;
    }
  }

  // /// Mengecek permission storage
  // static Future<bool> _checkPermission() async {
  //   if (Platform.isAndroid) {
  //     if (await Permission.manageExternalStorage.isGranted) return true;

  //     if (await Permission.manageExternalStorage.request().isGranted) {
  //       return true;
  //     }
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
