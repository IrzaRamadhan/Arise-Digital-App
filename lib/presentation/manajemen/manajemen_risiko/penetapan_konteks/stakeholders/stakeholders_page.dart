import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/stakeholders/stakeholders_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../../../../widgets/states/no_item_found.dart';
import 'stakeholders_card.dart';
import 'stakeholders_create_page.dart';
import 'stakeholders_edit_page.dart';

class StakeholdersPage extends StatelessWidget {
  const StakeholdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return BlocProvider(
      create: (context) => StakeholdersBloc()..add(FetchStakeholders()),
      child: Scaffold(
        appBar: AppBar(title: Text('Pemangku Kebijakan')),
        body: SafeArea(
          child: BlocBuilder<StakeholdersBloc, StakeholdersState>(
            builder: (context, state) {
              if (state is StakeholdersLoaded) {
                if (state.listStakeholders.isEmpty) {
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
                  itemCount: state.listStakeholders.length,
                  itemBuilder: (context, index) {
                    return StakeholdersCard(
                      ctxStakeholders: context,
                      stakeholders: state.listStakeholders[index],
                      onEdit: () {
                        NavigationHelper.push(
                          context,
                          StakeholdersEditPage(
                            stakeholders: state.listStakeholders[index],
                          ),
                        ).then((value) {
                          if (value && context.mounted) {
                            context.read<StakeholdersBloc>().add(
                              FetchStakeholders(),
                            );
                          }
                        });
                      },
                    );
                  },
                );
              } else if (state is StakeholdersFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<StakeholdersBloc>().add(
                          FetchStakeholders(),
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
        floatingActionButton: BlocBuilder<StakeholdersBloc, StakeholdersState>(
          builder: (context, state) {
            if (state is StakeholdersLoaded && role == 'Diskominfo') {
              return CustomFloatingActionButton(
                onTap: () {
                  NavigationHelper.push(
                    context,
                    StakeholdersCreatePage(),
                  ).then((value) {
                    if (value && context.mounted) {
                      context.read<StakeholdersBloc>().add(FetchStakeholders());
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
