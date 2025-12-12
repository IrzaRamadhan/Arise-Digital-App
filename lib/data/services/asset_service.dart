import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arise/data/models/asset_lifecycle_model.dart';

import '../models/asset_barang_form_model.dart';
import '../models/asset_sdm_form_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import '../models/asset_model.dart';
import 'auth_service.dart';

class AssetService {
  Future<Either<String, DashboardAssetModel>> getAssets({
    required int page,
    required String type, //barang || sdm
    String? verifType, // asset_baru, penonaktifan, penghapusan
    String? search,
    String? kategori,
    String? status,
  }) async {
    try {
      String url = '$baseUrl/api/asset-$type?page=$page';
      if (search != null) {
        url += '&search=$search';
      }
      if (verifType != null) {
        url += '&verification_type=$verifType';
      }
      if (kategori != null) {
        url += '&kategori=$kategori';
      }
      if (status != null) {
        url += '&status=$status';
      }
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
      print('Status Code (getAssets : $page) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          DashboardAssetModel.fromJson(jsonDecode(res.body)['data']),
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
            Uri.parse('$baseUrl/api/asset-$type/$id'),
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

  Future<Either<String, AssetLifecycleModel>> showAssetLifecyle(int id) async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/assets/$id/lifecycle/history'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (showAssetLifecyle) : ${res.statusCode}');

      if (res.statusCode == 200) {
        return Right(
          AssetLifecycleModel.fromJson(jsonDecode(res.body)['data']),
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

  Future<Either<String, String>> createAssetBarang({
    required AssetBarangFormModel data,
    required String? file,
  }) async {
    try {
      final token = AuthService().getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/asset-barang'),
      );

      // Authorization header
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': token,
      });

      // Upload file jika ada
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath('lampiran_file', file),
        );
      }

      // Convert field biasa
      final json = data.toJson();

      json.forEach((key, value) {
        if (key == 'risk_assessments') return; // skip (akan dihandle manual)
        request.fields[key] = value?.toString() ?? '';
      });

      // Flatten array risk_assessments
      if (data.riskAssessments != null) {
        for (int i = 0; i < data.riskAssessments!.length; i++) {
          final r = data.riskAssessments![i].toJson();
          r.forEach((key, value) {
            request.fields['risk_assessments[$i][$key]'] =
                value?.toString() ?? '';
          });
        }
      }

      // SEND
      http.StreamedResponse res = await request.send();
      final body = await res.stream.bytesToString();

      print('Status Code (createAssetBarang): ${res.statusCode}');
      print('Body: $body');

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
      print("Error createAssetBarang => $e");
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, String>> createAssetSdm({
    required AssetSdmFormModel data,
  }) async {
    try {
      final token = AuthService().getToken();
      var headers = {'Accept': 'application/json', 'Authorization': token};

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/asset-sdm'),
      );

      // ✅ 1. Tambahkan field biasa (gunakan toFormFields)
      data.toFormFields().forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // ✅ 2. Handle certificates (nested array + file upload)
      if (data.certificates != null && data.certificates!.isNotEmpty) {
        for (int i = 0; i < data.certificates!.length; i++) {
          final cert = data.certificates![i];

          print('--- Certificate $i ---');
          print('kompetensi_id: ${cert.kompetensiId}');
          print('nama: ${cert.nama}');
          print('lampiran: ${cert.lampiran}');

          if (cert.kompetensiId != null) {
            request.fields['certificates[$i][kompetensi_id]'] =
                cert.kompetensiId.toString();
          }

          if (cert.nama != null) {
            request.fields['certificates[$i][nama]'] = cert.nama!;
          }

          // Upload file jika ada
          if (cert.lampiran != null && cert.lampiran!.isNotEmpty) {
            final file = File(cert.lampiran!);
            if (await file.exists()) {
              request.files.add(
                await http.MultipartFile.fromPath(
                  'certificates[$i][lampiran]',
                  cert.lampiran!,
                ),
              );
              print('File added: ${cert.lampiran}');
            } else {
              print('WARNING: File not found: ${cert.lampiran}');
            }
          }
        }
      }

      // ✅ 3. Handle risk_assessments (nested array)
      if (data.riskAssessments != null && data.riskAssessments!.isNotEmpty) {
        for (int i = 0; i < data.riskAssessments!.length; i++) {
          final risk = data.riskAssessments![i];

          if (risk.jenis != null) {
            request.fields['risk_assessments[$i][jenis]'] = risk.jenis!;
          }
          if (risk.kategoriRisikoId != null) {
            request.fields['risk_assessments[$i][kategori_risiko_id]'] =
                risk.kategoriRisikoId.toString();
          }
          if (risk.kejadian != null) {
            request.fields['risk_assessments[$i][kejadian]'] = risk.kejadian!;
          }
          if (risk.penyebab != null) {
            request.fields['risk_assessments[$i][penyebab]'] = risk.penyebab!;
          }
          if (risk.areaDampakId != null) {
            request.fields['risk_assessments[$i][area_dampak_id]'] =
                risk.areaDampakId.toString();
          }
          if (risk.levelDampakId != null) {
            request.fields['risk_assessments[$i][level_dampak_id]'] =
                risk.levelDampakId.toString();
          }
          if (risk.levelKemungkinanId != null) {
            request.fields['risk_assessments[$i][level_kemungkinan_id]'] =
                risk.levelKemungkinanId.toString();
          }
          if (risk.besaran != null) {
            request.fields['risk_assessments[$i][besaran]'] =
                risk.besaran.toString();
          }
          if (risk.klasifikasi != null) {
            request.fields['risk_assessments[$i][klasifikasi]'] =
                risk.klasifikasi!;
          }
        }
      }

      request.headers.addAll(headers);

      // Debug: Print semua fields
      print('=== ALL REQUEST FIELDS ===');
      request.fields.forEach((key, value) {
        print('$key: $value');
      });

      print('=== ALL REQUEST FILES ===');
      request.files.forEach((file) {
        print('${file.field}: ${file.filename}');
      });

      // Kirim request
      http.StreamedResponse res = await request.send();
      final body = await res.stream.bytesToString();

      print('Status Code: ${res.statusCode}');
      print('Response Body: $body');

      if (res.statusCode == 201) {
        return const Right('Success');
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else {
        return Left('Terjadi Kesalahan Pada Server: ${res.statusCode}');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      print('Error createAssetSdm: $e');
      return const Left('Periksa Koneksi Internet Anda');
    }
  }
}
