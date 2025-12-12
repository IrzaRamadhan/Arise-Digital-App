import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/calculate_model.dart';
import 'auth_service.dart';

class CalculateService {
  Future<Either<String, LikelihoodCalculateModel>> calculateLikelihood({
    required int jabatanId,
    required List<int> kompetensiIds,
  }) async {
    print(jabatanId);
    print(kompetensiIds);
    try {
      final token = AuthService().getToken();

      final res = await http
          .post(
            Uri.parse('$baseUrl/api/calculate-likelihood'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
            body: jsonEncode({
              'jabatan_id': jabatanId,
              'kompetensi_ids': kompetensiIds,
            }),
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (calculateLikelihood) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(LikelihoodCalculateModel.fromJson(jsonDecode(res.body)));
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, RiskCalculateModel>> calculateRisk({
    required String levelDampak,
    required String levelKemungkinan,
  }) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/calculate-risk'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
            body: {
              'level_dampak': levelDampak,
              'level_kemungkinan': levelKemungkinan,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (calculateRisk) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(RiskCalculateModel.fromJson(jsonDecode(res.body)));
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }
}
