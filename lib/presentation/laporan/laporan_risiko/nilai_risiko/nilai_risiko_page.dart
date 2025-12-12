import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../controllers/nilai_risiko_controller.dart';
import '../../../../data/models/dinas_model.dart';
import '../../../../data/models/nilai_risiko_model.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../../components/filter_widget.dart';
import '../../components/laporan_filter_dialog.dart';
import 'nilai_risiko_card.dart';

class NilaiRisikoPage extends StatefulWidget {
  const NilaiRisikoPage({super.key});

  @override
  State<NilaiRisikoPage> createState() => _AsetBarangPageState();
}

class _AsetBarangPageState extends State<NilaiRisikoPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  final searchController = TextEditingController();
  DinasModel selectedDinas = DinasModel(id: 0, nama: 'Semua Dinas');
  String? selectedStartDate;
  String? selectedEndDate;

  late final NilaiRisikoController _nilaiRisikoController;

  @override
  void initState() {
    super.initState();
    _nilaiRisikoController = NilaiRisikoController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    searchController.dispose();
    _nilaiRisikoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nilai Risiko')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              LaporanFilterWidget(
                selectedDinas: selectedDinas,
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

                    _nilaiRisikoController.updateFilter(
                      newDinas: result['newDinas'],
                      newStartDate: result['newStartDate'],
                      newEndDate: result['newEndDate'],
                    );
                  }
                },
                urlApi: 'risiko/nilai-risiko',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _nilaiRisikoController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _nilaiRisikoController.pagingController.itemList !=
                            null &&
                        _nilaiRisikoController
                            .pagingController
                            .itemList!
                            .isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(bottom: hasData ? 16 : 0),
                      pagingController: _nilaiRisikoController.pagingController,
                      separatorBuilder: (context, index) => SizedBox(height: 8),
                      builderDelegate:
                          PagedChildBuilderDelegate<NilaiRisikoModel>(
                            itemBuilder: (context, nilaiRisiko, index) {
                              return NilaiRisikoCard(nilaiRisiko: nilaiRisiko);
                            },
                            firstPageProgressIndicatorBuilder:
                                (_) =>
                                    Center(child: CircularProgressIndicator()),
                            firstPageErrorIndicatorBuilder: (context) {
                              final error =
                                  _nilaiRisikoController.pagingController.error
                                      ?.toString() ??
                                  'Terjadi kesalahan';
                              return ErrorStateWidget(
                                onTap:
                                    () =>
                                        _nilaiRisikoController.pagingController
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
                                          _nilaiRisikoController
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
