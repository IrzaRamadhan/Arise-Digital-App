import 'package:arise/data/models/penilaian_risiko_model.dart';
import 'package:arise/helper/navigation_helper.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penilaian_risiko/penilaian_risiko_card.dart';
import 'package:arise/presentation/manajemen/manajemen_risiko/penilaian_risiko/penilaian_risiko_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../controllers/asset_controller.dart';
import '../../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../../../../widgets/states/no_item_found.dart';
import '../../../../controllers/penilaian_risiko_controller.dart';

class PenilaianRisikoPage extends StatefulWidget {
  const PenilaianRisikoPage({super.key});

  @override
  State<PenilaianRisikoPage> createState() => _PenilaianRisikoPageState();
}

class _PenilaianRisikoPageState extends State<PenilaianRisikoPage> {
  final PageController _controller = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier<int>(0);

  late final PenilaianRisikoController _risikoController;

  @override
  void initState() {
    super.initState();
    _risikoController = PenilaianRisikoController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _indexNotifier.dispose();
    _risikoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penilaian Risiko')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _risikoController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _risikoController.pagingController.itemList != null &&
                        _risikoController.pagingController.itemList!.isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: hasData ? 80 : 0,
                        left: 4,
                        right: 4,
                      ),
                      pagingController: _risikoController.pagingController,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 16),
                      builderDelegate:
                          PagedChildBuilderDelegate<PenilaianRisikoModel>(
                            itemBuilder: (context, risiko, index) {
                              return GestureDetector(
                                onTap: () {
                                  NavigationHelper.push(
                                    context,
                                    PenilaianRisikoDetailPage(risiko: risiko),
                                  );
                                },
                                child: PenilaianRisikoCard(risiko: risiko),
                              );
                            },
                            firstPageProgressIndicatorBuilder:
                                (_) =>
                                    Center(child: CircularProgressIndicator()),
                            firstPageErrorIndicatorBuilder: (context) {
                              final error =
                                  _risikoController.pagingController.error
                                      ?.toString() ??
                                  'Terjadi kesalahan';
                              return ErrorStateWidget(
                                onTap:
                                    () =>
                                        _risikoController.pagingController
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
                                          _risikoController.pagingController
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
