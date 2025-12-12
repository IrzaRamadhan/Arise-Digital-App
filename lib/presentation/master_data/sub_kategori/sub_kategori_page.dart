import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../helper/navigation_helper.dart';
import '../../../../widgets/floating_action_button.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../bloc/sub_kategori/sub_kategori_bloc.dart';
import '../../../data/services/auth_service.dart';
import '../../../widgets/filter.dart';
import '../../../widgets/states/no_item_found.dart';
import 'sub_kategori_card.dart';
import 'sub_kategori_create_page.dart';
import 'sub_kategori_edit_page.dart';

class SubKategoriPage extends StatefulWidget {
  const SubKategoriPage({super.key});

  @override
  State<SubKategoriPage> createState() => _SubKategoriPageState();
}

class _SubKategoriPageState extends State<SubKategoriPage> {
  String role = AuthService().getRole();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sub Kategori')),
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
                child: BlocBuilder<SubKategoriBloc, SubKategoriState>(
                  builder: (context, state) {
                    if (state is SubKategoriLoaded) {
                      var filteredList =
                          state.listSubKategori.where((subKategori) {
                            final query = searchController.text.toLowerCase();
                            if (query.isEmpty) return true;

                            return subKategori.nama.toLowerCase().contains(
                              query,
                            );
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
                          return SubKategoriCard(
                            ctxSubKategori: context,
                            vendor: filteredList[index],
                            onEdit: () {
                              NavigationHelper.push(
                                context,
                                SubKategoriEditPage(
                                  vendor: filteredList[index],
                                ),
                              ).then((value) {
                                if (value && context.mounted) {
                                  context.read<SubKategoriBloc>().add(
                                    FetchSubKategori(),
                                  );
                                }
                              });
                            },
                          );
                        },
                      );
                    } else if (state is SubKategoriFailed) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ErrorStateWidget(
                            onTap: () {
                              context.read<SubKategoriBloc>().add(
                                FetchSubKategori(),
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
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<SubKategoriBloc, SubKategoriState>(
        builder: (context, state) {
          if (state is SubKategoriLoaded && role == 'Diskominfo') {
            return CustomFloatingActionButton(
              onTap: () {
                NavigationHelper.push(context, SubKategoriCreatePage()).then((
                  value,
                ) {
                  if (value && context.mounted) {
                    context.read<SubKategoriBloc>().add(FetchSubKategori());
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
