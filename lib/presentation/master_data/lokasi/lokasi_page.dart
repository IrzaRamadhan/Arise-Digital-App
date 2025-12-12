import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../helper/navigation_helper.dart';
import '../../../../widgets/floating_action_button.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../bloc/lokasi/lokasi_bloc.dart';
import '../../../data/services/auth_service.dart';
import '../../../widgets/filter.dart';
import '../../../widgets/states/no_item_found.dart';
import 'lokasi_card.dart';
import 'lokasi_create_page.dart';
import 'lokasi_edit_page.dart';

class LokasiPage extends StatefulWidget {
  const LokasiPage({super.key});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> {
  String role = AuthService().getRole();
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lokasi')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomSearchFilter(
                searchController: searchController,
                hintSearch: 'Cari',
              ),
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<LokasiBloc, LokasiState>(
                  builder: (context, state) {
                    if (state is LokasiLoaded) {
                      var filteredList =
                          state.listLokasi.where((lokasi) {
                            final query = searchController.text.toLowerCase();
                            if (query.isEmpty) return true;

                            return lokasi.nama.toLowerCase().contains(query) ||
                                lokasi.alamat.toLowerCase().contains(query);
                          }).toList();

                      if (filteredList.isEmpty) {
                        return NoItemsFoundIndicator();
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: role == 'Diskominfo' ? 90 : 16,
                        ),
                        separatorBuilder:
                            (context, index) => SizedBox(height: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return LokasiCard(
                            ctxLokasi: context,
                            lokasi: filteredList[index],
                            onEdit: () {
                              NavigationHelper.push(
                                context,
                                LokasiEditPage(lokasi: filteredList[index]),
                              ).then((value) {
                                if (value && context.mounted) {
                                  context.read<LokasiBloc>().add(FetchLokasi());
                                }
                              });
                            },
                          );
                        },
                      );
                    } else if (state is LokasiFailed) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ErrorStateWidget(
                            onTap: () {
                              context.read<LokasiBloc>().add(FetchLokasi());
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
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<LokasiBloc, LokasiState>(
        builder: (context, state) {
          if (state is LokasiLoaded && role == 'Diskominfo') {
            return CustomFloatingActionButton(
              onTap: () {
                NavigationHelper.push(context, LokasiCreatePage()).then((
                  value,
                ) {
                  if (value && context.mounted) {
                    context.read<LokasiBloc>().add(FetchLokasi());
                  }
                });
              },
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
