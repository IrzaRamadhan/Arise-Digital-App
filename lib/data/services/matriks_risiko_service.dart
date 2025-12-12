import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/matriks_risiko_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import 'auth_service.dart';

class MatriksRisikoService {
  Future<Either<String, List<MatriksRisikoModel>>> getMatrixGrid() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/penetapan-konteks/matrix'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getMatrixGrid) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<MatriksRisikoModel>.from(
            jsonDecode(res.body)['data']['matrixGrid'].map(
              (question) => MatriksRisikoModel.fromJson(question),
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
