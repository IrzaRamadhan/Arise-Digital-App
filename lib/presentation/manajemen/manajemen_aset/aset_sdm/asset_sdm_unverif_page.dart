import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../controllers/asset_controller.dart';
import '../../../../data/models/asset_model.dart';
import '../../../../helper/navigation_helper.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../../widgets/states/no_item_found.dart';
import '../components/aset_sdm_card.dart';
import 'aset_sdm_detail_page.dart';

class AssetSdmUnverifPage extends StatefulWidget {
  final int? initialIndex;
  const AssetSdmUnverifPage({super.key, this.initialIndex});

  @override
  State<AssetSdmUnverifPage> createState() => _AssetSdmUnverifPageState();
}

class _AssetSdmUnverifPageState extends State<AssetSdmUnverifPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final AssetController _baruController;
  late final AssetController _penonaktianController;
  late final AssetController _penghapusanController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _baruController =
        AssetController()
          ..initFilter(initType: 'sdm', initVerifType: 'asset_baru');
    _penonaktianController =
        AssetController()
          ..initFilter(initType: 'sdm', initVerifType: 'penonaktifan');
    _penghapusanController =
        AssetController()
          ..initFilter(initType: 'sdm', initVerifType: 'penghapusan');

    _penonaktianController.pagingController.refresh();
    _penghapusanController.pagingController.refresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aset SDM'),
          elevation: 0,
          toolbarHeight: 40,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              _buildTab(
                index: 0,
                status: 'Aset Baru',
                controller: _baruController,
              ),
              _buildTab(
                index: 1,
                status: 'Penonaktifan',
                controller: _penonaktianController,
              ),
              _buildTab(
                index: 2,
                status: 'Penghapusan',
                controller: _penghapusanController,
              ),
            ],
            padding: const EdgeInsets.symmetric(horizontal: 12),
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicator: const BoxDecoration(color: Colors.transparent),
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildTabContent(controller: _baruController, status: 'Active'),
                _buildTabContent(
                  controller: _penonaktianController,
                  status: 'Inactive',
                ),
                _buildTabContent(
                  controller: _penghapusanController,
                  status: 'Dalam Review',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String status,
    required AssetController controller,
  }) {
    return Builder(
      builder: (context) {
        bool isSelected = _tabController.index == index;

        return GestureDetector(
          onTap: () {
            _tabController.animateTo(index);
            setState(() {});
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            width: (MediaQuery.of(context).size.width - 16 * 3) / 3,
            decoration: BoxDecoration(
              color: isSelected ? info400 : info050,
              border: Border.all(
                color: isSelected ? info400 : info200,
                width: isSelected ? 1 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                status,
                style: interSmallMedium.copyWith(
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabContent({
    required AssetController controller,
    required String status,
  }) {
    return PagedListView(
      pagingController: controller.pagingController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      builderDelegate: PagedChildBuilderDelegate<AssetModel>(
        itemBuilder: (context, asset, index) {
          return AsetSdmCard(
            asset: asset,
            onDetail: () {
              NavigationHelper.push(context, AsetSdmDetailPage(id: asset.id));
            },
          );
        },
        firstPageErrorIndicatorBuilder: (context) {
          final error =
              controller.pagingController.error?.toString() ??
              'Terjadi kesalahan';
          return Center(
            child: SingleChildScrollView(
              child: ErrorStateWidget(
                onTap: () {
                  controller.pagingController.refresh();
                },
                errorType: error,
              ),
            ),
          );
        },
        noItemsFoundIndicatorBuilder: (_) => const NoItemsFoundIndicator(),
        newPageErrorIndicatorBuilder:
            (context) => NewPageErrorIndicator(
              onRetry:
                  () => controller.pagingController.retryLastFailedRequest(),
            ),
        newPageProgressIndicatorBuilder:
            (context) => const NewPageProgressIndicator(),
      ),
    );
  }
}
