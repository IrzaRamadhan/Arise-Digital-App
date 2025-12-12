import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/kategori_risiko_form_model.dart';
import 'package:arise/data/models/kategori_risiko_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import 'auth_service.dart';

class KategoriRisikoService {
  Future<Either<String, List<KategoriRisikoModel>>> getKategoriRisiko() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/penetapan-konteks/kategori-risiko'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getKategoriRisiko) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<KategoriRisikoModel>.from(
            jsonDecode(
              res.body,
            )['data'].map((question) => KategoriRisikoModel.fromJson(question)),
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

  Future<Either<String, String>> createKategoriRisiko(
    KategoriRisikoFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/penetapan-konteks/kategori'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (createKategoriRisiko) : ${res.statusCode}');
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

  Future<Either<String, String>> updateKategoriRisiko(
    int id,
    KategoriRisikoFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .put(
            Uri.parse('$baseUrl/api/penetapan-konteks/kategori/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (updateKategoriRisiko) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else if (res.statusCode == 404) {
        return const Left('Kategori risiko ini telah dihapus');
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, String>> deleteKategoriRisiko(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .delete(
            Uri.parse('$baseUrl/api/penetapan-konteks/kategori/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (deleteKategoriRisiko) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        return const Left('Unauthenticated');
      } else if (res.statusCode == 404) {
        return const Left('Kategori risiko ini telah dihapus');
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
