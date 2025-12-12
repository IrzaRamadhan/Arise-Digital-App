import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/account_create_form_model.dart';
import 'package:arise/data/models/account_model.dart';
import 'package:arise/data/models/account_update_form_model.dart';
import 'package:arise/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import 'auth_service.dart';

class AccountService {
  Future<Either<String, DashboardAccountModel>> getAccounts({
    required int page,
    String? search,
    String? role,
    String? status,
  }) async {
    try {
      String url = '$baseUrl/api/account-management?page=$page';
      if (search != null) {
        url += '&search=$search';
      }
      if (role != null) {
        url += '&role_id=${roleIds[role]}';
      }
      // if (status != null) {
      //   url += '&status=$status';
      // }

      final token = AuthService().getToken();

      final res = await http
          .get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (getAccounts : $page) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          DashboardAccountModel.fromJson(jsonDecode(res.body)['data']['users']),
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
      return const Left('Connection');
    }
  }

  Future<Either<String, AccountModel>> getAccount(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/account-management/$id'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (getAccount) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(AccountModel.fromJson(jsonDecode(res.body)['data']));
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else if (res.statusCode == 404) {
        return const Left('Not Found');
      } else {
        return const Left('Server Eror');
      }
    } on TimeoutException {
      return const Left('Connection');
    } catch (e) {
      return const Left('Connection');
    }
  }

  Future<Either<String, String>> createAccount(
    AccountCreateFormModel data,
  ) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/account-management'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (createAccount) : ${res.statusCode}');
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

  Future<Either<String, String>> deleteAccount(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .delete(
            Uri.parse('$baseUrl/api/account-management/$id'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (deleteAccount) : ${res.statusCode}');
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
}
