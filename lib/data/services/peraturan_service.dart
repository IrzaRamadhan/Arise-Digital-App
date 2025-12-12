import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/peraturan_form_model.dart';
import '../models/peraturan_model.dart';
import 'auth_service.dart';

class PeraturanService {
  Future<Either<String, List<PeraturanModel>>> getPeraturan() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/penetapan-konteks/peraturan'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getPeraturan) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<PeraturanModel>.from(
            jsonDecode(
              res.body,
            )['data'].map((question) => PeraturanModel.fromJson(question)),
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

  Future<Either<String, String>> createPeraturan(
    PeraturanFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/penetapan-konteks/peraturan'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (createPeraturan) : ${res.statusCode}');
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

  Future<Either<String, String>> updatePeraturan(
    int id,
    PeraturanFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .put(
            Uri.parse('$baseUrl/api/penetapan-konteks/peraturan/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (updatePeraturan) : ${res.statusCode}');
      if (res.statusCode == 200) {
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

  Future<Either<String, String>> deletePeraturan(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .delete(
            Uri.parse('$baseUrl/api/penetapan-konteks/peraturan/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (deletePeraturan) : ${res.statusCode}');
      if (res.statusCode == 200) {
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
}
