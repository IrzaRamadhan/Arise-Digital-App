import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/riwayat_pemeliharaan_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_method.dart';
import '../../shared/shared_values.dart';
import 'auth_service.dart';

class RiwayatPemeliharaanService {
  Future<Either<String, DashboardRiwayatPemeliharaanModel>>
  getRiwayatPemeliharaan({
    required int page,
    int? dinasId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url = '$baseUrl/api/laporan/asset/riwayat-pemeliharaan?page=$page';
      if (dinasId != null) {
        url += '&dinas_id=$dinasId';
      }
      if (startDate != null) {
        url += '&start_date=${dmyToYmd(startDate)}';
      }
      if (endDate != null) {
        url += '&end_date=${dmyToYmd(endDate)}';
      }
      final token = AuthService().getToken();

      final res = await http
          .get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (getRiwayatPemeliharaan : $page) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          DashboardRiwayatPemeliharaanModel.fromJson(
            jsonDecode(res.body)['data'],
          ),
        );
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else {
        return const Left('Server Eror');
      }
    } on TimeoutException {
      return const Left('Connection');
    } catch (e) {
      return const Left('Connection');
    }
  }
}
