import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/account_update_form_model.dart';
import 'package:arise/data/models/asset_form_model.dart';
import 'package:arise/data/models/penilaian_risiko_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import '../models/asset_model.dart';
import 'auth_service.dart';

class PenilainRisikoService {
  Future<Either<String, DashboardPenilaianRisikoModel>> getPenilainRisiko({
    required int page,
  }) async {
    try {
      final token = AuthService().getToken();

      final res = await http
          .get(
            Uri.parse('$baseUrl/api/risk-assessments'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (getPenilainRisiko : $page) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          DashboardPenilaianRisikoModel.fromJson(jsonDecode(res.body)['data']),
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
      print(e);
      return const Left('Connection');
    }
  }

  Future<Either<String, AssetModel>> showAsset(int id, String type) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/risk-assessments/$id'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (showAsset) : ${res.statusCode}');

      if (res.statusCode == 200) {
        return Right(AssetModel.fromJson(jsonDecode(res.body)['data']));
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

  Future<Either<String, String>> createAsset({
    required AssetFormModel data,
    required String? file,
  }) async {
    try {
      final token = AuthService().getToken();
      var boundary = '------${DateTime.now().millisecondsSinceEpoch}------';
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data; boundary=$boundary',
        'Authorization': token,
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/assets'),
      );
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath('lampiran_file', file),
        );
      }
      request.headers.addAll(headers);
      request.fields.addAll(
        data.toJson().map((key, value) {
          if (value == null) return MapEntry(key, '');
          return MapEntry(key, value.toString());
        }),
      );
      http.StreamedResponse res = await request.send();
      print('Status Code (createAsset) : ${res.statusCode}');

      final body = await res.stream.bytesToString();
      print('Status Code (createAsset) : ${res.statusCode}');
      print('Body (createAsset) : $body');
      if (res.statusCode == 201) {
        return const Right('Success');
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

  Future<Either<String, String>> updateAccount(
    int id,
    AccountUpdateFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .put(
            Uri.parse('$baseUrl/api/account-management/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (updateAccount) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else if (res.statusCode == 404) {
        return const Left('Akun ini telah dihapus');
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, String>> deleteAsset(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .delete(
            Uri.parse('$baseUrl/api/assets/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print(res.body);
      print('Status Code (deleteAsset) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else if (res.statusCode == 404) {
        return const Left('Aset ini telah dihapus');
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
