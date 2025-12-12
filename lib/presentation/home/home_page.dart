import 'package:arise/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:intl/intl.dart';

import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dinas/dinas_bloc.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/dinas_model.dart';
import '../../data/services/auth_service.dart';
import '../../shared/theme.dart';
import '../../widgets/dropdowns.dart';
import '../../widgets/states/error_state_widget.dart';
import '../notifikasi/notifikasi_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();

  String name = AuthService().getName();
  String role = AuthService().getRole();
  int selectedDinas = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(FetchDashboard(selectedDinas)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary1,
          surfaceTintColor: primary1,
          toolbarHeight: (['Diskominfo', 'Auditor'].contains(role)) ? 140 : 90,
          title: Column(
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/img_profile.webp',
                      width: 40,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: interHeadlineMedium.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          role,
                          style: interSmallRegular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          NavigationHelper.push(context, NotifikasiPage());
                        },
                        icon: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Icon(
                                Hicons.notification3LightOutline,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            // Positioned(
                            //   top: 0,
                            //   right: 0,
                            //   child: Container(
                            //     padding: const EdgeInsets.all(4),
                            //     decoration: BoxDecoration(
                            //       color: Color(0xFFF22121),
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: Text(
                            //       '5',
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 10,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (['Diskominfo', 'Auditor'].contains(role))
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BlocBuilder<DinasBloc, DinasState>(
                    builder: (context, state) {
                      List<DinasModel> listDinas = [
                        DinasModel(id: 0, nama: 'Semua Dinas'),
                      ];

                      if (state is DinasLoaded) {
                        listDinas = [
                          DinasModel(id: 0, nama: 'Semua Dinas'),
                          ...state.listDinas,
                        ];

                        selectedDinas = 0;
                      }

                      return CustomDropdownGeneric<DinasModel>(
                        title: 'Dinas',
                        badgeRequired: true,
                        useTitle: false,
                        selectedItem: listDinas.firstWhere(
                          (d) => d.id == selectedDinas,
                          orElse: () => listDinas.first,
                        ),
                        onChanged: (value) {
                          if (value != null) {
                            selectedDinas = value.id;
                            context.read<DashboardBloc>().add(
                              FetchDashboard(selectedDinas),
                            );
                          }
                        },
                        items: listDinas,
                        itemAsString: (d) => d.nama,
                        compareFn: (a, b) => a.id == b.id,
                        hintText: 'Pilih Dinas',
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardLoaded) {
                DashboardSummaryModel dashboard = state.data;
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        CardHomeData(
                          title: 'Aset Aktif',
                          total: dashboard.totalAktif,
                          totalTi: dashboard.totalAktifTi,
                          totalNonTi: dashboard.totalAktifNonTi,
                          icon: Icons.check,
                          iconColor: Color(0xFF18A538),
                        ),
                        CardHomeData(
                          title: 'Perlu Pemeliharaan',
                          total: dashboard.dueMaintenanceTotal,
                          totalTi: dashboard.dueMaintenanceTi,
                          totalNonTi: dashboard.dueMaintenanceNonTi,
                          icon: Icons.handyman,
                          iconColor: Color(0xFFFFC107),
                        ),
                        CardHomeData(
                          title: 'Risiko Tersisa',
                          total: dashboard.residualRiskTotal,
                          totalTi: dashboard.residualRiskTi,
                          totalNonTi: dashboard.residualRiskNonTi,
                          icon: Icons.warning,
                          iconColor: Color(0xFFDC3545),
                        ),
                        CardHomeData(
                          title: 'Aset Nonaktif',
                          total: dashboard.endOfLifeTotal,
                          totalTi: dashboard.endOfLifeTi,
                          totalNonTi: dashboard.endOfLifeNonTi,
                          icon: Icons.delete,
                          iconColor: Color(0xFF007BFF),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is DashboardFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<DashboardBloc>().add(
                          FetchDashboard(selectedDinas),
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

class CardHomeData extends StatelessWidget {
  final String title;
  final int total;
  final int totalTi;
  final int totalNonTi;
  final IconData icon;
  final Color iconColor;
  const CardHomeData({
    super.key,
    required this.title,
    required this.total,
    required this.totalTi,
    required this.totalNonTi,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: listShadow3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat('#,###', 'id_ID').format(total),
                    style: interHeadlineSemibold,
                  ),
                  Text(title),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            height: 1,
            width: double.infinity,
            color: Colors.grey[300],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 2,
                  children: [
                    Text('TI', style: interSmallRegular),
                    Text(totalTi.toString(), style: interBodySmallSemibold),
                  ],
                ),
              ),
              Container(height: 24, width: 1, color: Colors.grey[300]),
              Expanded(
                child: Column(
                  spacing: 2,
                  children: [
                    Text('Non TI', style: interSmallRegular),
                    Text(totalNonTi.toString(), style: interBodySmallSemibold),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
