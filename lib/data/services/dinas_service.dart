import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/dinas_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import 'auth_service.dart';

class DinasService {
  Future<Either<String, List<DinasModel>>> getDinas() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/dinas'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getDinas) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<DinasModel>.from(
            jsonDecode(
              res.body,
            )['data'].map((question) => DinasModel.fromJson(question)),
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
}
