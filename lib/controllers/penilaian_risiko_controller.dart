import 'dart:async';

import 'package:arise/data/models/penilaian_risiko_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../data/services/penilain_risiko_service.dart';

class PenilaianRisikoController {
  final PagingController<int, PenilaianRisikoModel> pagingController =
      PagingController(firstPageKey: 1);

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  PenilaianRisikoController() {
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
    final result = await PenilainRisikoService().getPenilainRisiko(
      page: pageKey,
    );

    result.fold(
      (error) {
        pagingController.error = error;
      },
      (data) {
        final isLastPage = data.currentPage >= data.lastPage;
        final newItems = data.penilaianRisikos;

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      },
    );
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    pagingController.dispose();
  }
}
