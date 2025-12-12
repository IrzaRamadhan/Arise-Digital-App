import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../data/models/dinas_model.dart';
import '../data/models/inventarisasi_model.dart';
import '../data/services/inventarisasi_service.dart';

class InventarisasiController {
  final PagingController<int, InventarisasiModel> pagingController =
      PagingController(firstPageKey: 1);

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  DinasModel dinas = DinasModel(id: 0, nama: 'Semua Dinas');
  String? startDate;
  String? endDate;

  InventarisasiController() {
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
    final result = await InventarisasiService().getInventarisasi(
      page: pageKey,
      dinasId: dinas.id == 0 ? null : dinas.id,
      startDate: startDate,
      endDate: endDate,
    );

    result.fold(
      (error) {
        pagingController.error = error;
      },
      (data) {
        final isLastPage = data.currentPage >= data.lastPage;
        final newItems = data.listInventarisasi;

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      },
    );
  }

  void updateFilter({
    required DinasModel newDinas,
    required String? newStartDate,
    required String? newEndDate,
  }) {
    dinas = newDinas;
    startDate = newStartDate;
    endDate = newEndDate;
    pagingController.refresh();
  }

  void resetFilter() {
    dinas = DinasModel(id: 0, nama: 'Semua Dinas');
    startDate = null;
    endDate = null;
    pagingController.refresh();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    pagingController.dispose();
  }
}
