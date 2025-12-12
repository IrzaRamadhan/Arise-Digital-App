import 'package:arise/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../helper/cek_internet_helper.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/dropdowns.dart';
import '../../../../widgets/filter.dart';
import '../../../../widgets/floating_action_button.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/snackbar.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../../../login/login_page.dart';
import '../components/aset_sdm_card.dart';
import 'aset_sdm_detail_page.dart';
import 'aset_sdm_create_page.dart';

class AsetSdmPage extends StatefulWidget {
  final bool? showAction;
  const AsetSdmPage({super.key, this.showAction = true});

  @override
  State<AsetSdmPage> createState() => _AsetSdmPageState();
}

class _AsetSdmPageState extends State<AsetSdmPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  String selectedKategori = 'Semua Kategori';
  String selectedStatus = 'Semua Status';

  late final AssetController _assetController;

  String role = AuthService().getRole();

  @override
  void initState() {
    super.initState();
    _assetController = AssetController();
    _assetController.initFilter(initType: 'sdm');
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    searchController.dispose();
    _assetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asset SDM')),
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
                  final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Dialog(
                          insetPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            constraints: const BoxConstraints(maxWidth: 500),
                            padding: EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Filter',
                                      style: interHeadlineSemibold,
                                    ),
                                    SizedBox(height: 24),
                                    CustomDropdown(
                                      selectedValue: selectedKategori,
                                      title: 'Kategori',
                                      placeholder: 'Pilih Kategori',
                                      listItem: [
                                        'Semua Kategori',
                                        'TI',
                                        'Non-TI',
                                      ],
                                      useTitle: false,
                                      onChanged: (value) {
                                        if (value != null) {
                                          selectedKategori = value;
                                        }
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    CustomDropdown(
                                      selectedValue: selectedStatus,
                                      title: 'Status',
                                      placeholder: 'Pilih Status',
                                      listItem: [
                                        'Semua Status',
                                        'Pending',
                                        'Aktif',
                                        'Non-Aktif',
                                        'Pemeliharaan',
                                        'Rusak',
                                        'Ditolak',
                                      ],
                                      useTitle: false,
                                      onChanged: (value) {
                                        if (value != null) {
                                          selectedStatus = value;
                                        }
                                      },
                                    ),
                                    SizedBox(height: 24),
                                    CustomFilledButton(
                                      title: 'Tampilkan',
                                      onPressed: () async {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(FocusNode());
                                        if (_formKey.currentState!.validate()) {
                                          bool isConnected =
                                              await hasInternetConnection();
                                          if (isConnected) {
                                            if (context.mounted) {
                                              _assetController.updateFilter(
                                                newKategori: selectedKategori,
                                                newStatus: selectedStatus,
                                              );
                                              NavigationHelper.pop(context);
                                            }
                                          } else {
                                            if (context.mounted) {
                                              showCustomSnackbar(
                                                context: context,
                                                message:
                                                    'Periksa Koneksi Internet Anda',
                                                isSuccess: false,
                                              );
                                            }
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    CustomOutlineButton(
                                      title: 'Reset',
                                      textColor: Color(0xFFF22121),
                                      onPressed: () async {
                                        bool isConnected =
                                            await hasInternetConnection();
                                        if (isConnected) {
                                          if (context.mounted) {
                                            selectedKategori = 'Semua Kategori';
                                            selectedStatus = 'Semua Status';
                                            _assetController.resetFilter();

                                            NavigationHelper.pop(context);
                                          }
                                        } else {
                                          if (context.mounted) {
                                            showCustomSnackbar(
                                              context: context,
                                              message:
                                                  'Periksa Koneksi Internet Anda',
                                              isSuccess: false,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );

                  if (result && context.mounted) {
                    _assetController.pagingController.refresh();
                  }
                },
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
              const SizedBox(height: 16),
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
                          return AsetSdmCard(
                            asset: asset,
                            onDetail: () {
                              NavigationHelper.push(
                                context,
                                AsetSdmDetailPage(
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
                  NavigationHelper.push(context, AsetSdmCreatePage()).then((
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
