import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/sasaran_risiko/sasaran_risiko_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../../../../widgets/states/no_item_found.dart';
import 'sasaran_risiko_card.dart';
import 'sasaran_risiko_create_page.dart';
import 'sasaran_risiko_edit_page.dart';

class SasaranRisikoPage extends StatelessWidget {
  const SasaranRisikoPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return BlocProvider(
      create: (context) => SasaranRisikoBloc()..add(FetchSasaranRisiko()),
      child: Scaffold(
        appBar: AppBar(title: Text('Sasaran Risiko')),
        body: SafeArea(
          child: BlocBuilder<SasaranRisikoBloc, SasaranRisikoState>(
            builder: (context, state) {
              if (state is SasaranRisikoLoaded) {
                if (state.listSasaranRisiko.isEmpty) {
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
                  itemCount: state.listSasaranRisiko.length,
                  itemBuilder: (context, index) {
                    return SasaranRisikoCard(
                      ctxSasaranRisiko: context,
                      sasaranRisiko: state.listSasaranRisiko[index],
                      onEdit: () {
                        NavigationHelper.push(
                          context,
                          SasaranRisikoEditPage(
                            sasaranRisiko: state.listSasaranRisiko[index],
                          ),
                        ).then((value) {
                          if (value && context.mounted) {
                            context.read<SasaranRisikoBloc>().add(
                              FetchSasaranRisiko(),
                            );
                          }
                        });
                      },
                    );
                  },
                );
              } else if (state is SasaranRisikoFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<SasaranRisikoBloc>().add(
                          FetchSasaranRisiko(),
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
            BlocBuilder<SasaranRisikoBloc, SasaranRisikoState>(
              builder: (context, state) {
                if (state is SasaranRisikoLoaded && role == 'Diskominfo') {
                  return CustomFloatingActionButton(
                    onTap: () {
                      NavigationHelper.push(
                        context,
                        SasaranRisikoCreatePage(),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<SasaranRisikoBloc>().add(
                            FetchSasaranRisiko(),
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
