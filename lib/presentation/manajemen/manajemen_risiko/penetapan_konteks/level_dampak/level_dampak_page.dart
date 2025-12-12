import 'package:arise/bloc/level_dampak/level_dampak_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import 'level_dampak_card.dart';
import 'level_dampak_create_page.dart';
import 'level_dampak_edit_page.dart';

class LevelDampakPage extends StatelessWidget {
  const LevelDampakPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Level Dampak')),
      body: SafeArea(
        child: BlocBuilder<LevelDampakBloc, LevelDampakState>(
          builder: (context, state) {
            if (state is LevelDampakLoaded) {
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  role == 'Diskominfo' ? 90 : 16,
                ),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: state.listLevelDampak.length,
                itemBuilder: (context, index) {
                  return LevelDampakCard(
                    ctxLevelDampak: context,
                    levelDampak: state.listLevelDampak[index],
                    onEdit: () {
                      NavigationHelper.push(
                        context,
                        LevelDampakEditPage(
                          levelDampak: state.listLevelDampak[index],
                        ),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<LevelDampakBloc>().add(
                            FetchLevelDampak(),
                          );
                        }
                      });
                    },
                  );
                },
              );
            } else if (state is LevelDampakFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<LevelDampakBloc>().add(FetchLevelDampak());
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
      floatingActionButton: BlocBuilder<LevelDampakBloc, LevelDampakState>(
        builder: (context, state) {
          if (state is LevelDampakLoaded && role == 'Diskominfo') {
            return CustomFloatingActionButton(
              onTap: () {
                NavigationHelper.push(context, LevelDampakCreatePage()).then((
                  value,
                ) {
                  if (value && context.mounted) {
                    context.read<LevelDampakBloc>().add(FetchLevelDampak());
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
