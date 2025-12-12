import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import '../models/penanggung_jawab_model.dart';
import 'auth_service.dart';

class PenanggungJawabService {
  Future<Either<String, List<PenanggungJawabModel>>>
  getPenanggungJawab() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/account-management/penanggung-jawab'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getPenanggungJawab) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<PenanggungJawabModel>.from(
            jsonDecode(res.body)['data'].map(
              (question) => PenanggungJawabModel.fromJson(question),
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
      print(e);
      return const Left('Connection');
    }
  }
}
