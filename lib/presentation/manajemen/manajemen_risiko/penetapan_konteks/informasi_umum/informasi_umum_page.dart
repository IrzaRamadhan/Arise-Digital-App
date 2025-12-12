import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/informasi_umum/informasi_umum_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../../../../widgets/states/no_item_found.dart';
import 'informasi_umum_card.dart';
import 'informasi_umum_create_page.dart';
import 'informasi_umum_edit_page.dart';

class InformasiUmumPage extends StatelessWidget {
  const InformasiUmumPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return BlocProvider(
      create: (context) => InformasiUmumBloc()..add(FetchInformasiUmum()),
      child: Scaffold(
        appBar: AppBar(title: Text('Informasi Umum')),
        body: SafeArea(
          child: BlocBuilder<InformasiUmumBloc, InformasiUmumState>(
            builder: (context, state) {
              if (state is InformasiUmumLoaded) {
                if (state.listInformasiUmum.isEmpty) {
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
                  itemCount: state.listInformasiUmum.length,
                  itemBuilder: (context, index) {
                    return InformasiUmumCard(
                      ctxInformasiUmum: context,
                      informasiUmum: state.listInformasiUmum[index],
                      onEdit: () {
                        NavigationHelper.push(
                          context,
                          InformasiUmumEditPage(
                            informasiUmum: state.listInformasiUmum[index],
                          ),
                        ).then((value) {
                          if (value && context.mounted) {
                            context.read<InformasiUmumBloc>().add(
                              FetchInformasiUmum(),
                            );
                          }
                        });
                      },
                    );
                  },
                );
              } else if (state is InformasiUmumFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<InformasiUmumBloc>().add(
                          FetchInformasiUmum(),
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
            BlocBuilder<InformasiUmumBloc, InformasiUmumState>(
              builder: (context, state) {
                if (state is InformasiUmumLoaded && role == 'Diskominfo') {
                  return CustomFloatingActionButton(
                    onTap: () {
                      NavigationHelper.push(
                        context,
                        InformasiUmumCreatePage(),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<InformasiUmumBloc>().add(
                            FetchInformasiUmum(),
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
