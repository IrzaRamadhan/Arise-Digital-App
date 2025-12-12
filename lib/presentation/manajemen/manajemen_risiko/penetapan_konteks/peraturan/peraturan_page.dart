import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/peraturan/peraturan_bloc.dart';
import '../../../../../data/services/auth_service.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../widgets/floating_action_button.dart';
import '../../../../../widgets/states/error_state_widget.dart';
import '../../../../../widgets/states/no_item_found.dart';
import 'peraturan_card.dart';
import 'peraturan_create_page.dart';
import 'peraturan_edit_page.dart';

class PeraturanPage extends StatelessWidget {
  const PeraturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    String role = AuthService().getRole();
    return BlocProvider(
      create: (context) => PeraturanBloc()..add(FetchPeraturan()),
      child: Scaffold(
        appBar: AppBar(title: Text('Peraturan & Regulasi')),
        body: SafeArea(
          child: BlocBuilder<PeraturanBloc, PeraturanState>(
            builder: (context, state) {
              if (state is PeraturanLoaded) {
                if (state.listPeraturan.isEmpty) {
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
                  itemCount: state.listPeraturan.length,
                  itemBuilder: (context, index) {
                    return PeraturanCard(
                      ctxPeraturan: context,
                      peraturan: state.listPeraturan[index],
                      onEdit: () {
                        NavigationHelper.push(
                          context,
                          PeraturanEditPage(
                            peraturan: state.listPeraturan[index],
                          ),
                        ).then((value) {
                          if (value && context.mounted) {
                            context.read<PeraturanBloc>().add(FetchPeraturan());
                          }
                        });
                      },
                    );
                  },
                );
              } else if (state is PeraturanFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<PeraturanBloc>().add(FetchPeraturan());
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
        floatingActionButton: BlocBuilder<PeraturanBloc, PeraturanState>(
          builder: (context, state) {
            if (state is PeraturanLoaded && role == 'Diskominfo') {
              return CustomFloatingActionButton(
                onTap: () {
                  NavigationHelper.push(context, PeraturanCreatePage()).then((
                    value,
                  ) {
                    if (value && context.mounted) {
                      context.read<PeraturanBloc>().add(FetchPeraturan());
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
