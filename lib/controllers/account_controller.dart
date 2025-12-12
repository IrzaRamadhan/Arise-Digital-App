import 'dart:async';

import 'package:arise/data/models/account_model.dart';
import 'package:arise/data/services/account_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final ValueNotifier<bool> refreshAccountNotifier = ValueNotifier(false);

class AccountController {
  final PagingController<int, AccountModel> pagingController = PagingController(
    firstPageKey: 1,
  );

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  String? search;
  String? role;
  String? status;

  AccountController() {
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
    final result = await AccountService().getAccounts(
      page: pageKey,
      search: search,
      role: role,
      status: status,
    );

    result.fold(
      (error) {
        pagingController.error = error;
      },
      (data) {
        final isLastPage = data.currentPage >= data.lastPage;
        final newItems = data.accounts;

        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, pageKey + 1);
        }
      },
    );
  }

  void initFilter({required String initStatus}) {
    status = initStatus;
    pagingController.refresh();
  }

  void updateSearch(String value) {
    search = value;
    pagingController.refresh();
  }

  void updateFilter({required String? newRole}) {
    role = newRole;
    pagingController.refresh();
  }

  void resetFilter() {
    role = null;
    pagingController.refresh();
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    pagingController.dispose();
  }
}
