import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../controllers/rekap_nilai_controller.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../data/models/rekap_nilai_model.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../../components/filter_widget.dart';
import '../../components/laporan_filter_dialog.dart';
import 'rekap_nilai_card.dart';

class RekapNilaiPage extends StatefulWidget {
  const RekapNilaiPage({super.key});

  @override
  State<RekapNilaiPage> createState() => _AsetBarangPageState();
}

class _AsetBarangPageState extends State<RekapNilaiPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  final searchController = TextEditingController();
  DinasModel selectedDinas = DinasModel(id: 0, nama: 'Semua Dinas');
  String? selectedStartDate;
  String? selectedEndDate;

  late final RekapNilaiController _rekapNilaiController;

  @override
  void initState() {
    super.initState();
    _rekapNilaiController = RekapNilaiController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    searchController.dispose();
    _rekapNilaiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekap Nilai')),
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

                    _rekapNilaiController.updateFilter(
                      newDinas: result['newDinas'],
                      newStartDate: result['newStartDate'],
                      newEndDate: result['newEndDate'],
                    );
                  }
                },
                urlApi: 'asset/rekap-nilai',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _rekapNilaiController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _rekapNilaiController.pagingController.itemList !=
                            null &&
                        _rekapNilaiController
                            .pagingController
                            .itemList!
                            .isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(bottom: hasData ? 16 : 0),
                      pagingController: _rekapNilaiController.pagingController,
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      builderDelegate:
                          PagedChildBuilderDelegate<RekapNilaiModel>(
                            itemBuilder: (context, rekapNilai, index) {
                              return RekapNilaiCard(rekapNilai: rekapNilai);
                            },
                            firstPageProgressIndicatorBuilder:
                                (_) =>
                                    Center(child: CircularProgressIndicator()),
                            firstPageErrorIndicatorBuilder: (context) {
                              final error =
                                  _rekapNilaiController.pagingController.error
                                      ?.toString() ??
                                  'Terjadi kesalahan';
                              return ErrorStateWidget(
                                onTap:
                                    () =>
                                        _rekapNilaiController.pagingController
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
                                          _rekapNilaiController.pagingController
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
