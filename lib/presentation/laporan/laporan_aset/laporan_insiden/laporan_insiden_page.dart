import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../controllers/laporan_insiden_controller.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../data/models/laporan_insiden_model.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../../components/filter_widget.dart';
import '../../components/laporan_filter_dialog.dart';
import 'laporan_insiden_card.dart';

class LaporanInsidenPage extends StatefulWidget {
  const LaporanInsidenPage({super.key});

  @override
  State<LaporanInsidenPage> createState() => _AsetBarangPageState();
}

class _AsetBarangPageState extends State<LaporanInsidenPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  final searchController = TextEditingController();
  DinasModel selectedDinas = DinasModel(id: 0, nama: 'Semua Dinas');
  String? selectedStartDate;
  String? selectedEndDate;

  late final LaporanInsidenController _laporanInsidenController;

  @override
  void initState() {
    super.initState();
    _laporanInsidenController = LaporanInsidenController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    searchController.dispose();
    _laporanInsidenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Insiden')),
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

                    _laporanInsidenController.updateFilter(
                      newDinas: result['newDinas'],
                      newStartDate: result['newStartDate'],
                      newEndDate: result['newEndDate'],
                    );
                  }
                },
                urlApi: 'asset/insiden',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _laporanInsidenController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _laporanInsidenController.pagingController.itemList !=
                            null &&
                        _laporanInsidenController
                            .pagingController
                            .itemList!
                            .isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(bottom: hasData ? 16 : 0),
                      pagingController:
                          _laporanInsidenController.pagingController,
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      builderDelegate:
                          PagedChildBuilderDelegate<LaporanInsidenModel>(
                            itemBuilder: (context, laporanInsiden, index) {
                              return LaporanInsidenCard(
                                laporanInsiden: laporanInsiden,
                              );
                            },
                            firstPageProgressIndicatorBuilder:
                                (_) =>
                                    Center(child: CircularProgressIndicator()),
                            firstPageErrorIndicatorBuilder: (context) {
                              final error =
                                  _laporanInsidenController
                                      .pagingController
                                      .error
                                      ?.toString() ??
                                  'Terjadi kesalahan';
                              return ErrorStateWidget(
                                onTap:
                                    () =>
                                        _laporanInsidenController
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
                                          _laporanInsidenController
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
