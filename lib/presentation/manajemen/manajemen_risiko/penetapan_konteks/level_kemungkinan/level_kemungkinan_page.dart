import 'package:arise/bloc/level_kemungkinan/level_kemungkinan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import 'level_kemungkinan_card.dart';
import 'level_kemungkinan_create_page.dart';
import 'level_kemungkinan_edit_page.dart';

class LevelKemungkinanPage extends StatelessWidget {
  const LevelKemungkinanPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return Scaffold(
      appBar: AppBar(title: Text('Level Kemungkinan')),
      body: SafeArea(
        child: BlocBuilder<LevelKemungkinanBloc, LevelKemungkinanState>(
          builder: (context, state) {
            if (state is LevelKemungkinanLoaded) {
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  role == 'Diskominfo' ? 90 : 16,
                ),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemCount: state.listLevelKemungkinan.length,
                itemBuilder: (context, index) {
                  return LevelKemungkinanCard(
                    ctxLevelKemungkinan: context,
                    levelKemungkinan: state.listLevelKemungkinan[index],
                    onEdit: () {
                      NavigationHelper.push(
                        context,
                        LevelKemungkinanEditPage(
                          levelKemungkinan: state.listLevelKemungkinan[index],
                        ),
                      ).then((value) {
                        if (value && context.mounted) {
                          context.read<LevelKemungkinanBloc>().add(
                            FetchLevelKemungkinan(),
                          );
                        }
                      });
                    },
                  );
                },
              );
            } else if (state is LevelKemungkinanFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ErrorStateWidget(
                    onTap: () {
                      context.read<LevelKemungkinanBloc>().add(
                        FetchLevelKemungkinan(),
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
          BlocBuilder<LevelKemungkinanBloc, LevelKemungkinanState>(
            builder: (context, state) {
              if (state is LevelKemungkinanLoaded && role == 'Diskominfo') {
                return CustomFloatingActionButton(
                  onTap: () {
                    NavigationHelper.push(
                      context,
                      LevelKemungkinanCreatePage(),
                    ).then((value) {
                      if (value && context.mounted) {
                        context.read<LevelKemungkinanBloc>().add(
                          FetchLevelKemungkinan(),
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
