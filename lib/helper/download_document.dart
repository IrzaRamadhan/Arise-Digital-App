import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/services/auth_service.dart';
import '../shared/shared_method.dart';
import '../shared/shared_values.dart';

class LaporanService {
  final String urlApi;
  final int? dinasId;
  final String? startDate;
  final String? endDate;

  LaporanService({
    required this.urlApi,
    required this.dinasId,
    required this.startDate,
    required this.endDate,
  });

  Future<bool> _downloadFile(String fileUrl, String fileName) async {
    try {
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode != 200) {
        return false;
      }

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

  Future<bool> exportLaporanFile() async {
    try {
      final token = AuthService().getToken();

      String url = '$baseUrl$urlApi?';

      if (dinasId != null) {
        url += '&dinas_id=$dinasId';
      }
      if (startDate != null && startDate != '') {
        url += '&start_date=${dmyToYmd(startDate!)}';
      }
      if (endDate != null && endDate != '') {
        url += '&end_date=${dmyToYmd(endDate!)}';
      }

      print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json', 'Authorization': token},
      );
      print(response.body);

      if (response.statusCode != 200) {
        return false;
      }

      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] != true) {
        return false;
      }

      final downloadUrl = jsonData['data']['download_url'] as String;
      final fileName = jsonData['data']['file_name'] as String;

      return await _downloadFile(downloadUrl, fileName);
    } catch (e) {
      return false;
    }
  }
}
