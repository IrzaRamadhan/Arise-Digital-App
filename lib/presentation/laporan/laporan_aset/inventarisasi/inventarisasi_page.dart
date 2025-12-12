import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../controllers/inventarisasi_controller.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../data/models/inventarisasi_model.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../../components/filter_widget.dart';
import '../../components/laporan_filter_dialog.dart';
import 'inventarisasi_card.dart';

class InventarisasiPage extends StatefulWidget {
  const InventarisasiPage({super.key});

  @override
  State<InventarisasiPage> createState() => _AsetBarangPageState();
}

class _AsetBarangPageState extends State<InventarisasiPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  final searchController = TextEditingController();
  DinasModel selectedDinas = DinasModel(id: 0, nama: 'Semua Dinas');
  String? selectedStartDate;
  String? selectedEndDate;

  late final InventarisasiController _inventarisasiController;

  @override
  void initState() {
    super.initState();
    _inventarisasiController = InventarisasiController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    searchController.dispose();
    _inventarisasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventarisasi Aset')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              LaporanFilterWidget(
                selectedDinas: selectedDinas,
                selectedStartDate: selectedStartDate,
                selectedEndDate: selectedEndDate,
                onTapFilter: () async {
                  final result = await showLaporanFilterDialog(
                    context: context,
                    selectedDinas: selectedDinas,
                    selectedStartDate: selectedStartDate,
                    selectedEndDate: selectedEndDate,
                  );

                  if (result != null && context.mounted) {
                    setState(() {
                      selectedDinas = result['newDinas'];
                      selectedStartDate = result['newStartDate'];
                      selectedEndDate = result['newEndDate'];
                    });

                    _inventarisasiController.updateFilter(
                      newDinas: result['newDinas'],
                      newStartDate: result['newStartDate'],
                      newEndDate: result['newEndDate'],
                    );
                  }
                },
                urlApi: 'asset/inventarisasi',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _inventarisasiController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _inventarisasiController.pagingController.itemList !=
                            null &&
                        _inventarisasiController
                            .pagingController
                            .itemList!
                            .isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(bottom: hasData ? 16 : 0),
                      pagingController:
                          _inventarisasiController.pagingController,
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      builderDelegate:
                          PagedChildBuilderDelegate<InventarisasiModel>(
                            itemBuilder: (context, asset, index) {
                              return InventarisasiCard(asset: asset);
                            },
                            firstPageProgressIndicatorBuilder:
                                (_) =>
                                    Center(child: CircularProgressIndicator()),
                            firstPageErrorIndicatorBuilder: (context) {
                              final error =
                                  _inventarisasiController
                                      .pagingController
                                      .error
                                      ?.toString() ??
                                  'Terjadi kesalahan';
                              return ErrorStateWidget(
                                onTap:
                                    () =>
                                        _inventarisasiController
                                            .pagingController
                                            .refresh(),
                                errorType: error,
                              );
                            },
                            noItemsFoundIndicatorBuilder:
                                (_) => const NoItemsFoundIndicator(),
                            newPageErrorIndicatorBuilder:
                                (context) => NewPageErrorIndicator(
                                  onRetry:
                                      () =>
                                          _inventarisasiController
                                              .pagingController
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
    );
  }
}
