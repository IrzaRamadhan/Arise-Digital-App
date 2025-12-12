import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/faq/faq_bloc.dart';
import '../../../data/models/faq_form_model.dart';
import '../../../data/models/faq_model.dart';
import '../../../data/models/user_model.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dropdowns.dart';
import '../../../widgets/forms.dart';
import '../../../widgets/snackbar.dart';
import 'components/bantuan_header_item.dart';

class BantuanEditPage extends StatefulWidget {
  final FaqModel faq;
  const BantuanEditPage({super.key, required this.faq});

  @override
  State<BantuanEditPage> createState() => _BantuanEditPageState();
}

class _BantuanEditPageState extends State<BantuanEditPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole;
  final pertanyaanController = TextEditingController();
  final jawabanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.faq.roleId != null) {
      selectedRole = roles[widget.faq.roleId];
    }
    pertanyaanController.text = widget.faq.pertanyaan;
    jawabanController.text = widget.faq.jawaban;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary1,
        surfaceTintColor: primary1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            BantuanHeaderItem(),
            // Body
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Role
                    CustomDropdown(
                      selectedValue: selectedRole,
                      title: 'Role',
                      placeholder: 'Pilih role',
                      listItem: listRole,
                      onChanged: (value) {
                        selectedRole = value;
                      },
                    ),
                    SizedBox(height: 16),
                    // Pertanyaan
                    CustomOutlineForm(
                      controller: pertanyaanController,
                      title: 'Pertanyaan',
                      placeholder: 'Ketik disini',
                      minLines: 5,
                      maxLines: 10,
                    ),
                    SizedBox(height: 16),
                    // Jawaban
                    CustomOutlineForm(
                      controller: jawabanController,
                      title: 'Jawaban',
                      placeholder: 'Ketik disini',
                      minLines: 5,
                      maxLines: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Jawaban';
                        }
                        if (value.trim().length < 10) {
                          return 'Jawaban harus terdiri dari minimal 10 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    BlocProvider(
                      create:
                          (context) => FaqBloc(useConnectivityListener: false),
                      child: BlocConsumer<FaqBloc, FaqState>(
                        listener: (context, state) {
                          if (state is FaqUpdated) {
                            context.loaderOverlay.hide();
                            NavigationHelper.pop(context, true);
                          } else if (state is FaqFailed) {
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
                                final roleId = roleIds[selectedRole];
                                context.read<FaqBloc>().add(
                                  UpdateFaq(
                                    id: widget.faq.id,
                                    data: FaqFormModel(
                                      pertanyaan: pertanyaanController.text,
                                      jawaban: jawabanController.text,
                                      roleId: roleId!,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
