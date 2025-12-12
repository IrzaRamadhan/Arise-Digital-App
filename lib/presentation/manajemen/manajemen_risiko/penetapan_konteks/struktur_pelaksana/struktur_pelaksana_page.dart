import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/struktur_pelaksana/struktur_pelaksana_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../../../../widgets/states/no_item_found.dart';
import 'struktur_pelaksana_card.dart';
import 'struktur_pelaksana_create_page.dart';
import 'struktur_pelaksana_edit_page.dart';

class StrukturPelaksanaPage extends StatelessWidget {
  const StrukturPelaksanaPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return BlocProvider(
      create:
          (context) => StrukturPelaksanaBloc()..add(FetchStrukturPelaksana()),
      child: Scaffold(
        appBar: AppBar(title: Text('Struktur Pelaksana')),
        body: SafeArea(
          child: BlocBuilder<StrukturPelaksanaBloc, StrukturPelaksanaState>(
            builder: (context, state) {
              if (state is StrukturPelaksanaLoaded) {
                if (state.listStrukturPelaksana.isEmpty) {
                  return NoItemsFoundIndicator();
                }

                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    role == 'Diskominfo' ? 90 : 16,
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: state.listStrukturPelaksana.length,
                  itemBuilder: (context, index) {
                    return StrukturPelaksanaCard(
                      ctxStrukturPelaksana: context,
                      strukturPelaksana: state.listStrukturPelaksana[index],
                      onEdit: () {
                        NavigationHelper.push(
                          context,
                          StrukturPelaksanaEditPage(
                            struktur: state.listStrukturPelaksana[index],
                          ),
                        ).then((value) {
                          if (value && context.mounted) {
                            context.read<StrukturPelaksanaBloc>().add(
                              FetchStrukturPelaksana(),
                            );
                          }
                        });
                      },
                    );
                  },
                );
              } else if (state is StrukturPelaksanaFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<StrukturPelaksanaBloc>().add(
                          FetchStrukturPelaksana(),
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
        floatingActionButton:
            BlocBuilder<StrukturPelaksanaBloc, StrukturPelaksanaState>(
              builder: (context, state) {
                if (state is StrukturPelaksanaLoaded && role == 'Diskominfo') {
                  return CustomFloatingActionButton(
                    onTap: () {
                      NavigationHelper.push(
                        context,
                        StrukturPelaksanaCreatePage(),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<StrukturPelaksanaBloc>().add(
                            FetchStrukturPelaksana(),
                          );
                        }
                      });
                    },
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
      ),
    );
  }
}
