import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/struktur_pelaksana_form_model.dart';
import '../models/struktur_pelaksana_model.dart';
import 'auth_service.dart';

class StrukturPelaksanaService {
  Future<Either<String, List<StrukturPelaksanaModel>>>
  getStrukturPelaksana() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/penetapan-konteks/struktur-pelaksana'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getStrukturPelaksana) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<StrukturPelaksanaModel>.from(
            jsonDecode(res.body)['data'].map(
              (question) => StrukturPelaksanaModel.fromJson(question),
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

  Future<Either<String, String>> createStrukturPelaksana(
    StrukturPelaksanaFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/penetapan-konteks/struktur-pelaksana'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (createStrukturPelaksana) : ${res.statusCode}');
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

  Future<Either<String, String>> updateStrukturPelaksana(
    int id,
    StrukturPelaksanaFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .put(
            Uri.parse('$baseUrl/api/penetapan-konteks/struktur-pelaksana/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (updateStrukturPelaksana) : ${res.statusCode}');
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

  Future<Either<String, String>> deleteStrukturPelaksana(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .delete(
            Uri.parse('$baseUrl/api/penetapan-konteks/struktur-pelaksana/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (deleteStrukturPelaksana) : ${res.statusCode}');
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
