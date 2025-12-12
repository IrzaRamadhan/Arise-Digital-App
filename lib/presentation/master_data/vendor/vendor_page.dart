import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../helper/navigation_helper.dart';
import '../../../../widgets/floating_action_button.dart';
import '../../../../widgets/states/error_state_widget.dart';
import '../../../bloc/vendor/vendor_bloc.dart';
import '../../../data/services/auth_service.dart';
import '../../../widgets/filter.dart';
import '../../../widgets/states/no_item_found.dart';
import 'vendor_card.dart';
import 'vendor_create_page.dart';
import 'vendor_edit_page.dart';

class VendorPage extends StatefulWidget {
  const VendorPage({super.key});

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  String role = AuthService().getRole();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendor')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomSearchFilter(
                searchController: searchController,
                hintSearch: 'Cari',
              ),
              SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<VendorBloc, VendorState>(
                  builder: (context, state) {
                    if (state is VendorLoaded) {
                      var filteredList =
                          state.listVendor.where((vendor) {
                            final query = searchController.text.toLowerCase();
                            if (query.isEmpty) return true;

                            return vendor.nama.toLowerCase().contains(query);
                          }).toList();

                      if (filteredList.isEmpty) {
                        return NoItemsFoundIndicator();
                      }

                      return ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: role == 'Diskominfo' ? 90 : 16,
                        ),
                        separatorBuilder:
                            (context, index) => SizedBox(height: 8),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          return VendorCard(
                            ctxVendor: context,
                            vendor: filteredList[index],
                            onEdit: () {
                              NavigationHelper.push(
                                context,
                                VendorEditPage(vendor: filteredList[index]),
                              ).then((value) {
                                if (value && context.mounted) {
                                  context.read<VendorBloc>().add(FetchVendor());
                                }
                              });
                            },
                          );
                        },
                      );
                    } else if (state is VendorFailed) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ErrorStateWidget(
                            onTap: () {
                              context.read<VendorBloc>().add(FetchVendor());
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
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<VendorBloc, VendorState>(
        builder: (context, state) {
          if (state is VendorLoaded && role == 'Diskominfo') {
            return CustomFloatingActionButton(
              onTap: () {
                NavigationHelper.push(context, VendorCreatePage()).then((
                  value,
                ) {
                  if (value && context.mounted) {
                    context.read<VendorBloc>().add(FetchVendor());
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
