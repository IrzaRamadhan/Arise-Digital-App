import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/level_kemungkinan_form_model.dart';
import '../models/level_kemungkinan_model.dart';
import 'auth_service.dart';

class LevelKemungkinanService {
  Future<Either<String, List<LevelKemungkinanModel>>>
  getLevelKemungkinan() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/penetapan-konteks/level-kemungkinan'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getLevelKemungkinan) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<LevelKemungkinanModel>.from(
            jsonDecode(res.body)['data'].map(
              (question) => LevelKemungkinanModel.fromJson(question),
            ),
          ).toList(),
        );
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else {
        return const Left('Server Error');
      }
    } on TimeoutException {
      return const Left('Connection');
    } catch (e) {
      return const Left('Connection');
    }
  }

  Future<Either<String, String>> createLevelKemungkinan(
    LevelKemungkinanFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/penetapan-konteks/level-kemungkinan'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (createLevelKemungkinan) : ${res.statusCode}');
      print(res.body);
      if (res.statusCode == 201) {
        return Right('success');
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

  Future<Either<String, String>> updateLevelKemungkinan(
    int id,
    LevelKemungkinanFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .put(
            Uri.parse('$baseUrl/api/penetapan-konteks/level-kemungkinan/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (updateLevelKemungkinan) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else if (res.statusCode == 404) {
        return const Left('Area dampak ini telah dihapus');
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, String>> deleteLevelKemungkinan(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .delete(
            Uri.parse('$baseUrl/api/penetapan-konteks/level-kemungkinan/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (deleteLevelKemungkinan) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        return const Left('Unauthenticated');
      } else if (res.statusCode == 404) {
        return const Left('Area dampak ini telah dihapus');
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
