import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/area_dampak/area_dampak_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import 'area_dampak_card.dart';
import 'area_dampak_create_page.dart';
import 'area_dampak_edit_page.dart';

class AreaDampakPage extends StatelessWidget {
  const AreaDampakPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Area Dampak')),
      body: SafeArea(
        child: BlocBuilder<AreaDampakBloc, AreaDampakState>(
          builder: (context, state) {
            if (state is AreaDampakLoaded) {
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  role == 'Diskominfo' ? 90 : 16,
                ),
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: state.listAreaDampak.length,
                itemBuilder: (context, index) {
                  return AreaDampakCard(
                    ctxAreaDampak: context,
                    areaDampak: state.listAreaDampak[index],
                    onEdit: () {
                      NavigationHelper.push(
                        context,
                        AreaDampakEditPage(
                          areaDampak: state.listAreaDampak[index],
                        ),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<AreaDampakBloc>().add(FetchAreaDampak());
                        }
                      });
                    },
                  );
                },
              );
            } else if (state is AreaDampakFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<AreaDampakBloc>().add(FetchAreaDampak());
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
      floatingActionButton: BlocBuilder<AreaDampakBloc, AreaDampakState>(
        builder: (context, state) {
          if (state is AreaDampakLoaded && role == 'Diskominfo') {
            return CustomFloatingActionButton(
              onTap: () {
                NavigationHelper.push(context, AreaDampakCreatePage()).then((
                  value,
                ) {
                  if (value && context.mounted) {
                    context.read<AreaDampakBloc>().add(FetchAreaDampak());
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
