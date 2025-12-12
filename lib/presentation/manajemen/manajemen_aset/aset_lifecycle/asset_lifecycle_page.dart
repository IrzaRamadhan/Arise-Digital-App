import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/asset_lifecycle/asset_lifecycle_bloc.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/states/error_state_widget.dart';
import 'asset_history_timeline_item.dart';

class AssetLifecyclePage extends StatelessWidget {
  final int id;
  const AssetLifecyclePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => AssetLifecycleBloc()..add(FetchAssetLifecycle(id: id)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(title: Text('Timeline Siklus Hidup Asset')),
        body: SafeArea(
          child: BlocBuilder<AssetLifecycleBloc, AssetLifecycleState>(
            builder: (context, state) {
              if (state is AssetLifecycleLoaded) {
                final asset = state.asset;

                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // HEADER CARD
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: secondary1,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.inventory_2,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Nama Aset",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      asset.asset.namaAsset,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${asset.history.length} Riwayat Aktivitas",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 16),
                      child: Text(
                        "Timeline Aktivitas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    if (asset.history.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history_toggle_off,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Belum ada riwayat aktivitas",
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...List.generate(
                        asset.history.length,
                        (i) => AssetHistoryTimelineItem(
                          data: asset.history[i],
                          isLast: i == asset.history.length - 1,
                        ),
                      ),
                  ],
                );
              } else if (state is AssetLifecycleFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<AssetLifecycleBloc>().add(
                          FetchAssetLifecycle(id: id),
                        );
                      },
                      errorType: state.message,
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
