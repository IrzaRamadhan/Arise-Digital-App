import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/kategori_risiko/kategori_risiko_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import 'kategori_risiko_card.dart';
import 'kategori_risiko_create_page.dart';
import 'kategori_risiko_edit_page.dart';

class KategoriRisikoPage extends StatelessWidget {
  const KategoriRisikoPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Kategori Risiko')),
      body: SafeArea(
        child: BlocBuilder<KategoriRisikoBloc, KategoriRisikoState>(
          builder: (context, state) {
            if (state is KategoriRisikoLoaded) {
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  role == 'Diskominfo' ? 90 : 16,
                ),
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: state.listKategoriRisiko.length,
                itemBuilder: (context, index) {
                  return KategoriRisikoCard(
                    ctxKategoriRisiko: context,
                    kategoriRisiko: state.listKategoriRisiko[index],
                    onEdit: () {
                      NavigationHelper.push(
                        context,
                        KategoriRisikoEditPage(
                          kategoriRisiko: state.listKategoriRisiko[index],
                        ),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<KategoriRisikoBloc>().add(
                            FetchKategoriRisiko(),
                          );
                        }
                      });
                    },
                  );
                },
              );
            } else if (state is KategoriRisikoFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<KategoriRisikoBloc>().add(
                        FetchKategoriRisiko(),
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
          BlocBuilder<KategoriRisikoBloc, KategoriRisikoState>(
            builder: (context, state) {
              if (state is KategoriRisikoLoaded && role == 'Diskominfo') {
                return CustomFloatingActionButton(
                  onTap: () {
                    NavigationHelper.push(
                      context,
                      KategoriRisikoCreatePage(),
                    ).then((value) {
                      if (value && context.mounted) {
                        context.read<KategoriRisikoBloc>().add(
                          FetchKategoriRisiko(),
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
    );
  }
}
