import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/unit_kerja_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import 'auth_service.dart';

class UnitKerjaService {
  Future<Either<String, List<UnitKerjaModel>>> getUnitKerja(
    int? dinasId,
  ) async {
    try {
      final token = AuthService().getToken();
      String url = '$baseUrl/api/unit-kerja';
      if (dinasId != null) {
        url = '$url?dinas_id=$dinasId';
      }
      final res = await http
          .get(
            Uri.parse(url),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getUnitKerja) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<UnitKerjaModel>.from(
            jsonDecode(
              res.body,
            )['data'].map((question) => UnitKerjaModel.fromJson(question)),
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
      print(e);
      return const Left('Connection');
    }
  }
}
