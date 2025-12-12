import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/stakeholders/stakeholders_bloc.dart';
import '../../../../../data/models/stakeholders_form_model.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class StakeholdersCreatePage extends StatefulWidget {
  const StakeholdersCreatePage({super.key});

  @override
  State<StakeholdersCreatePage> createState() => _StakeholdersCreatePageState();
}

class _StakeholdersCreatePageState extends State<StakeholdersCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final unitController = TextEditingController();
  final emailController = TextEditingController();
  final tanggungJawabController = TextEditingController();
  final teleponController = TextEditingController();
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Pemangku Kebijakan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: unitController,
              title: 'Unit Organisasi',
              placeholder: 'Nama dinas atau unit organisasi',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: emailController,
              title: 'Email',
              placeholder: 'email@example.com',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: tanggungJawabController,
              title: 'Tanggung Jawab',
              placeholder:
                  'Deskripsikan tanggung jawab dalam manajemen risiko...',
              minLines: 3,
              maxLines: 5,
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: teleponController,
              title: 'Telepon',
              placeholder: '08xx-xxxx-xxxx',
              isNumber: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              badgeRequired: true,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text('Status Aktif', style: interBodySmallMedium),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => StakeholdersBloc(),
            child: BlocConsumer<StakeholdersBloc, StakeholdersState>(
              listener: (context, state) {
                if (state is StakeholdersCreated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is StakeholdersFailed) {
                  context.loaderOverlay.hide();
                  showCustomSnackbar(
                    context: context,
                    message: state.message,
                    isSuccess: false,
                  );
                }
              },
              builder: (context, state) {
                return CustomFilledButton(
                  title: 'Simpan',
                  useCheckInternet: true,
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      context.loaderOverlay.show();
                      context.read<StakeholdersBloc>().add(
                        CreateStakeholders(
                          StakeholdersFormModel(
                            unitOrganisasi: unitController.text,
                            email: emailController.text,
                            telepon: teleponController.text,
                            tanggungJawab: tanggungJawabController.text,
                            isActive: isChecked,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
