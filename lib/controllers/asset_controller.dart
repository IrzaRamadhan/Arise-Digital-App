import 'dart:async';

import 'package:arise/data/models/asset_model.dart';
import 'package:arise/data/services/asset_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final ValueNotifier<bool> refreshAssetBarangNotifier = ValueNotifier(false);
final ValueNotifier<bool> refreshAssetSdmNotifier = ValueNotifier(false);

class AssetController {
  final PagingController<int, AssetModel> pagingController = PagingController(
    firstPageKey: 1,
  );

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  String? type;
  String? verifType;
  String? search;
  String? kategori;
  String? status;

  AssetController() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      if (result != ConnectivityResult.none &&
          pagingController.error == 'Connection') {
        if ((pagingController.itemList?.isNotEmpty ?? false)) {
          pagingController.retryLastFailedRequest();
        } else {
          pagingController.refresh();
        }
      }
    });
  }

  Future<void> fetchPage(int pageKey) async {
    final kategoriValue = switch (kategori) {
      'TI' => 'ti',
      'Non-TI' => 'non-ti',
      _ => null,
    };

    final statusValue = switch (status) {
      'Pending' => 'pending',
      'Aktif' => 'aktif',
      'Non-Aktif' => 'non_aktif',
      'Pemeliharaan' => 'pemeliharaan',
      'Dihapus' => 'dihapus',
      _ => null,
    };

    final result = await AssetService().getAssets(
      page: pageKey,
      type: type!,
      verifType: verifType,
      search: search,
      kategori: kategoriValue,
      status: statusValue,
    );

    result.fold(
      (error) {
        pagingController.error = error;
      },
      (data) {
        final isLastPage = data.currentPage >= data.lastPage;
        final newItems = data.assets;

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      },
    );
  }

  void initFilter({required String initType, String? initVerifType}) {
    type = initType;
    verifType = initVerifType;
    pagingController.refresh();
  }

  void updateSearch(String value) {
    search = value;
    pagingController.refresh();
  }

  void updateFilter({
    required String? newKategori,
    required String? newStatus,
  }) {
    kategori = newKategori;
    status = newStatus;
    pagingController.refresh();
  }

  void resetFilter() {
    kategori = null;
    status = null;
    pagingController.refresh();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    pagingController.dispose();
  }
}
