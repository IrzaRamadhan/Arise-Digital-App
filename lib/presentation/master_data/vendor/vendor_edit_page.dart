import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/vendor/vendor_bloc.dart';
import '../../../data/models/vendor_form_model.dart';
import '../../../data/models/vendor_model.dart';
import '../../../helper/cek_internet_helper.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/forms.dart';
import '../../../widgets/snackbar.dart';

class VendorEditPage extends StatefulWidget {
  final VendorModel vendor;
  const VendorEditPage({super.key, required this.vendor});

  @override
  State<VendorEditPage> createState() => _VendorEditPageState();
}

class _VendorEditPageState extends State<VendorEditPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    namaController.text = widget.vendor.nama;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Vendor')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomOutlineForm(
              controller: namaController,
              title: 'Nama Vendor',
              placeholder: 'Contoh: PT Maju Jaya',
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
            create: (context) => VendorBloc(),
            child: BlocConsumer<VendorBloc, VendorState>(
              listener: (context, state) {
                if (state is VendorUpdated) {
                  context.loaderOverlay.hide();
                  NavigationHelper.pop(context, true);
                } else if (state is VendorFailed) {
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
                  title: 'Simpan Vendor',
                  onPressed: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (_formKey.currentState!.validate()) {
                      bool isConnected = await hasInternetConnection();
                      if (isConnected) {
                        if (context.mounted) {
                          context.loaderOverlay.show();
                          context.read<VendorBloc>().add(
                            UpdateVendor(
                              id: widget.vendor.id,
                              data: VendorFormModel(nama: namaController.text),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          showCustomSnackbar(
                            context: context,
                            message: 'Periksa Koneksi Internet Anda',
                            isSuccess: false,
                          );
                        }
                      }
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
