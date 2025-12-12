import 'package:arise/data/models/peraturan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../../bloc/peraturan/peraturan_bloc.dart';
import '../../../../../data/models/peraturan_form_model.dart';
import '../../../../../helper/navigation_helper.dart';
import '../../../../../shared/theme.dart';
import '../../../../../widgets/buttons.dart';
import '../../../../../widgets/forms.dart';
import '../../../../../widgets/snackbar.dart';

class PeraturanEditPage extends StatefulWidget {
  final PeraturanModel peraturan;
  const PeraturanEditPage({super.key, required this.peraturan});

  @override
  State<PeraturanEditPage> createState() => _PeraturanEditPageState();
}

class _PeraturanEditPageState extends State<PeraturanEditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaController.text = widget.peraturan.nama;
    deskripsiController.text = widget.peraturan.amanat ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Peraturan Risiko')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama Peraturan',
              placeholder: 'Contoh: PermenPANRB No. 5 Tahun 2020',
              badgeRequired: true,
            ),
            SizedBox(height: 16),
            CustomOutlineForm(
              controller: deskripsiController,
              title: 'Amanat/Isi Peraturan',
              placeholder: 'Jelaskan amanat atau isi dari peraturan ini...',
              minLines: 3,
              maxLines: 5,
              badgeRequired: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, boxShadow: listShadow),
          child: BlocProvider(
            create: (context) => PeraturanBloc(),
            child: BlocConsumer<PeraturanBloc, PeraturanState>(
              listener: (context, state) {
                if (state is PeraturanUpdated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is PeraturanFailed) {
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
                      context.read<PeraturanBloc>().add(
                        UpdatePeraturan(
                          id: widget.peraturan.id,
                          data: PeraturanFormModel(
                            nama: namaController.text,
                            amanat: deskripsiController.text,
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
