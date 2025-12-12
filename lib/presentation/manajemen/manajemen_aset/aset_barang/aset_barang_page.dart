import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../widgets/filter.dart';
import '../../../../widgets/floating_action_button.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../../../login/login_page.dart';
import '../components/aset_barang_card.dart';
import '../components/aset_barang_filter_dialog.dart';
import 'aset_barang_create_page.dart';
import 'aset_barang_detail_page.dart';

class AsetBarangPage extends StatefulWidget {
  final bool? showAction;
  const AsetBarangPage({super.key, this.showAction = true});

  @override
  State<AsetBarangPage> createState() => _AsetBarangPageState();
}

class _AsetBarangPageState extends State<AsetBarangPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  final searchController = TextEditingController();
  String selectedKategori = 'Semua Kategori';
  String selectedStatus = 'Semua Status';

  late final AssetController _assetController;

  @override
  void initState() {
    super.initState();
    _assetController = AssetController();
    _assetController.initFilter(initType: 'barang');

    refreshAssetBarangNotifier.addListener(() {
      if (refreshAssetBarangNotifier.value == true) {
        _assetController.pagingController.refresh();
        refreshAssetBarangNotifier.value = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    searchController.dispose();
    _assetController.dispose();
    super.dispose();
  }

  String role = AuthService().getRole();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset Barang')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomSearchFilter(
                searchController: searchController,
                hintSearch: 'Cari',
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                  _assetController.updateSearch(searchController.text);
                },
                isShowFilter: true,
                onOpenFilter: () async {
                  final result = await showAsetBarangFilterDialog(
                    context: context,
                    selectedKategori: selectedKategori,
                    selectedStatus: selectedStatus,
                  );

                  if (result != null && context.mounted) {
                    _assetController.updateFilter(
                      newKategori: result['newKategori'],
                      newStatus: result['newStatus'],
                    );
                  }
                },
                // isShowSorter: true,
                // onOpenSorter: () async {
                // final result = await showAsetBarangSorterDialog(
                //   context: context,
                //   selectedKategori: selectedKategori,
                //   selectedStatus: selectedStatus,
                // );

                // if (result != null && context.mounted) {
                //   _assetController.updateFilter(
                //     newKategori: result['newKategori'],
                //     newStatus: result['newStatus'],
                //   );
                // }
                // },
              ),
              // const SizedBox(height: 16),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: CustomFilledButton(
              //     title: 'Ekspor Aset',
              //     height: 40,
              //     width: 135,
              //     icon: Hicons.uploadBold,
              //     onPressed: () {},
              //   ),
              // ),
              const SizedBox(height: 24),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _assetController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _assetController.pagingController.itemList != null &&
                        _assetController.pagingController.itemList!.isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(
                        bottom: hasData ? 80 : 0,
                        left: 4,
                        right: 4,
                      ),
                      pagingController: _assetController.pagingController,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 16),
                      builderDelegate: PagedChildBuilderDelegate<AssetModel>(
                        itemBuilder: (context, asset, index) {
                          return AsetBarangCard(
                            asset: asset,
                            onDetail: () {
                              NavigationHelper.push(
                                context,
                                AsetBarangDetailPage(
                                  id: asset.id,
                                  showAction: widget.showAction,
                                ),
                              );
                            },
                          );
                        },
                        firstPageProgressIndicatorBuilder:
                            (_) => Center(child: CircularProgressIndicator()),
                        firstPageErrorIndicatorBuilder: (context) {
                          final error =
                              _assetController.pagingController.error
                                  ?.toString() ??
                              'Terjadi kesalahan';

                          if (error == 'Unauthenticated') {
                            Future.microtask(() {
                              if (context.mounted) {
                                NavigationHelper.pushAndRemoveUntil(
                                  context,
                                  LoginPage(),
                                );
                              }
                            });
                          }

                          return ErrorStateWidget(
                            onTap:
                                () =>
                                    _assetController.pagingController.refresh(),
                            errorType: error,
                          );
                        },
                        noItemsFoundIndicatorBuilder:
                            (_) => const NoItemsFoundIndicator(),
                        newPageErrorIndicatorBuilder:
                            (context) => NewPageErrorIndicator(
                              onRetry:
                                  () =>
                                      _assetController.pagingController
                                          .retryLastFailedRequest(),
                            ),
                        newPageProgressIndicatorBuilder:
                            (context) => const NewPageProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          ['Diskominfo', 'OPD', 'Admin Dinas'].contains(role)
              ? CustomFloatingActionButton(
                onTap: () {
                  NavigationHelper.push(context, AsetBarangCreatePage()).then((
                    value,
                  ) {
                    if (value) {
                      _assetController.pagingController.refresh();
                    }
                  });
                },
              )
              : SizedBox.shrink(),
    );
  }
}
