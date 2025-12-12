import 'package:arise/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/account/account_bloc.dart';
import '../../../bloc/dinas/dinas_bloc.dart';
import '../../../controllers/account_controller.dart';
import '../../../data/models/account_create_form_model.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/account_update_form_model.dart';
import '../../../data/models/dinas_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/dropdowns.dart';
import '../../../widgets/filter.dart';
import '../../../widgets/floating_action_button.dart';
import '../../../widgets/forms.dart';
import '../../../widgets/infinite_scroll/new_page_error_indicator.dart';
import '../../../widgets/infinite_scroll/new_page_progress_indicator.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/states/error_state_widget.dart';
import '../../../widgets/states/no_item_found.dart';
import '../../login/login_page.dart';
import 'detail_akun_page.dart';

class ManajemenAkunPage extends StatefulWidget {
  const ManajemenAkunPage({super.key});

  @override
  State<ManajemenAkunPage> createState() => _ManajemenAkunPageState();
}

class _ManajemenAkunPageState extends State<ManajemenAkunPage> {
  final PageController _controller = PageController();

  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  String? selectedRole;

  late final AccountController _accountController;

  String role = AuthService().getRole();

  @override
  void initState() {
    super.initState();
    _accountController = AccountController();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Akun')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomSearchFilter(
                searchController: searchController,
                hintSearch: 'Cari',
                onSubmitted: (value) {
                  FocusScope.of(context).unfocus();
                  _accountController.updateSearch(searchController.text);
                },
                isShowFilter: true,
                onOpenFilter: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return SafeArea(
                        child: Dialog(
                          insetPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 32,
                            constraints: const BoxConstraints(maxWidth: 500),
                            padding: EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Filter',
                                      style: interHeadlineSemibold,
                                    ),
                                    SizedBox(height: 24),
                                    CustomDropdown(
                                      selectedValue: selectedRole,
                                      title: 'Role',
                                      placeholder: 'Pilih role',
                                      listItem: listRole,
                                      useTitle: false,
                                      onChanged: (value) {
                                        selectedRole = value;
                                      },
                                    ),
                                    SizedBox(height: 24),
                                    BlocProvider(
                                      create: (context) => AccountBloc(),
                                      child: BlocConsumer<
                                        AccountBloc,
                                        AccountState
                                      >(
                                        listener: (context, state) {
                                          if (state is AccountCreated) {
                                            context.loaderOverlay.hide();
                                            NavigationHelper.pop(context, true);
                                          } else if (state is AccountFailed) {
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
                                            title: 'Tampilkan',
                                            useCheckInternet: true,
                                            onPressed: () async {
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(FocusNode());
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _accountController.updateFilter(
                                                  newRole: selectedRole,
                                                );

                                                NavigationHelper.pop(context);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    CustomOutlineButton(
                                      title: 'Reset',
                                      textColor: Color(0xFFF22121),
                                      useCheckInternet: true,
                                      onPressed: () async {
                                        selectedRole = null;
                                        _accountController.resetFilter();

                                        NavigationHelper.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );

                  if (result && context.mounted) {
                    _accountController.pagingController.refresh();
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                spacing: 10,
                children: [
                  Image.asset('assets/images/user_color.png', width: 24),
                  Text(
                    'Daftar Pengguna',
                    style: interHeadlineSemibold.copyWith(color: primary1),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _accountController.pagingController,
                  builder: (context, _, _) {
                    final hasData =
                        _accountController.pagingController.itemList != null &&
                        _accountController
                            .pagingController
                            .itemList!
                            .isNotEmpty;

                    return PagedListView.separated(
                      padding: EdgeInsets.only(
                        bottom:
                            !hasData
                                ? 0
                                : role == 'Diskominfo'
                                ? 85
                                : 16,
                        left: 4,
                        right: 4,
                      ),
                      pagingController: _accountController.pagingController,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 16),
                      builderDelegate: PagedChildBuilderDelegate<AccountModel>(
                        itemBuilder: (context, account, index) {
                          return GestureDetector(
                            onTap: () {
                              NavigationHelper.push(
                                context,
                                DetailAkunPage(id: account.id),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.08),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    offset: const Offset(0, -2),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  account.avatar != null
                                      ? ClipOval(
                                        child: CustomNetworkImage(
                                          imageUrl: account.avatar!,
                                          height: 40,
                                          width: 40,
                                        ),
                                      )
                                      : ClipOval(
                                        child: Image.asset(
                                          'assets/images/img_profile.webp',
                                          width: 40,
                                        ),
                                      ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: '${account.name} - ',
                                            style: interSmallRegular.copyWith(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${roles[int.parse(account.roleId)]}',
                                                style: interSmallBold.copyWith(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          account.email,
                                          style: interSmallLight,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  if (role == 'Diskominfo') ...[
                                    SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: IconButton(
                                        onPressed: () async {
                                          final nameController =
                                              TextEditingController(
                                                text: account.name,
                                              );
                                          final usernameController =
                                              TextEditingController(
                                                text: account.username,
                                              );
                                          final emailController =
                                              TextEditingController(
                                                text: account.email,
                                              );
                                          final passwordController =
                                              TextEditingController();
                                          final confirmController =
                                              TextEditingController();
                                          String? selectedRole =
                                              roles[int.parse(account.roleId)];
                                          int? selectedDinas =
                                              account.dinasId != null
                                                  ? int.parse(account.dinasId!)
                                                  : null;
                                          final result = await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (
                                                  context,
                                                  setModalState,
                                                ) {
                                                  return SafeArea(
                                                    child: Dialog(
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              16,
                                                            ),
                                                      ),
                                                      child: Container(
                                                        width:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width -
                                                            32,
                                                        constraints:
                                                            const BoxConstraints(
                                                              maxWidth: 500,
                                                            ),
                                                        padding: EdgeInsets.all(
                                                          16,
                                                        ),
                                                        child: SingleChildScrollView(
                                                          child: Form(
                                                            key: _formKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Text(
                                                                  'Edit Akun',
                                                                  style:
                                                                      interHeadlineSemibold,
                                                                ),
                                                                SizedBox(
                                                                  height: 24,
                                                                ),
                                                                CustomOutlineForm(
                                                                  controller:
                                                                      nameController,
                                                                  title:
                                                                      'Nama Lengkap',
                                                                  placeholder:
                                                                      'Masukkan nama lengkap',
                                                                  badgeRequired:
                                                                      true,
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                CustomOutlineForm(
                                                                  controller:
                                                                      usernameController,
                                                                  title:
                                                                      'Username',
                                                                  placeholder:
                                                                      'Masukkan username',
                                                                  badgeRequired:
                                                                      true,
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                CustomOutlineForm(
                                                                  controller:
                                                                      emailController,
                                                                  title:
                                                                      'E-mail',
                                                                  placeholder:
                                                                      'Masukkan e-mail',
                                                                  badgeRequired:
                                                                      true,
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                CustomOutlineForm(
                                                                  controller:
                                                                      passwordController,
                                                                  title:
                                                                      'Kata Sandi',
                                                                  placeholder:
                                                                      'Masukkan kata sandi',
                                                                  isPassword:
                                                                      true,
                                                                  badgeRequired:
                                                                      true,
                                                                  validator: (
                                                                    value,
                                                                  ) {
                                                                    return null;
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                CustomOutlineForm(
                                                                  controller:
                                                                      confirmController,
                                                                  title:
                                                                      'Konfirmasi Kata Sandi',
                                                                  placeholder:
                                                                      'Masukkan konfirmasi kata sandi',
                                                                  isPassword:
                                                                      true,
                                                                  badgeRequired:
                                                                      true,
                                                                  validator: (
                                                                    value,
                                                                  ) {
                                                                    return null;
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                CustomDropdown(
                                                                  selectedValue:
                                                                      selectedRole,
                                                                  title: 'Role',
                                                                  placeholder:
                                                                      'Pilih role',
                                                                  listItem:
                                                                      listRole,
                                                                  badgeRequired:
                                                                      true,
                                                                  onChanged: (
                                                                    value,
                                                                  ) {
                                                                    setModalState(() {
                                                                      selectedRole =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                                if (selectedRole !=
                                                                        null &&
                                                                    [
                                                                      'OPD',
                                                                      'Verifikator',
                                                                    ].contains(
                                                                      selectedRole,
                                                                    )) ...[
                                                                  SizedBox(
                                                                    height: 16,
                                                                  ),
                                                                  BlocBuilder<
                                                                    DinasBloc,
                                                                    DinasState
                                                                  >(
                                                                    builder: (
                                                                      context,
                                                                      state,
                                                                    ) {
                                                                      List<
                                                                        DinasModel
                                                                      >
                                                                      listDinas =
                                                                          [];
                                                                      if (state
                                                                          is DinasLoaded) {
                                                                        listDinas =
                                                                            state.listDinas;
                                                                      }

                                                                      return CustomDropdownGeneric<
                                                                        DinasModel
                                                                      >(
                                                                        title:
                                                                            'Dinas',
                                                                        badgeRequired:
                                                                            true,
                                                                        selectedItem:
                                                                            selectedDinas !=
                                                                                    null
                                                                                ? listDinas.firstWhere(
                                                                                  (
                                                                                    d,
                                                                                  ) =>
                                                                                      d.id ==
                                                                                      selectedDinas,
                                                                                  orElse:
                                                                                      () =>
                                                                                          listDinas.first,
                                                                                )
                                                                                : null,
                                                                        onChanged: (
                                                                          value,
                                                                        ) {
                                                                          if (value !=
                                                                              null) {
                                                                            selectedDinas =
                                                                                value.id;
                                                                          }
                                                                        },
                                                                        items:
                                                                            listDinas,
                                                                        itemAsString:
                                                                            (
                                                                              d,
                                                                            ) =>
                                                                                d.nama,
                                                                        compareFn:
                                                                            (
                                                                              a,
                                                                              b,
                                                                            ) =>
                                                                                a.id ==
                                                                                b.id,
                                                                        hintText:
                                                                            'Pilih Dinas',
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                                SizedBox(
                                                                  height: 24,
                                                                ),
                                                                BlocProvider(
                                                                  create:
                                                                      (
                                                                        context,
                                                                      ) =>
                                                                          AccountBloc(),
                                                                  child: BlocConsumer<
                                                                    AccountBloc,
                                                                    AccountState
                                                                  >(
                                                                    listener: (
                                                                      context,
                                                                      state,
                                                                    ) {
                                                                      if (state
                                                                          is AccountUpdated) {
                                                                        context
                                                                            .loaderOverlay
                                                                            .hide();
                                                                        NavigationHelper.pop(
                                                                          context,
                                                                          true,
                                                                        );
                                                                      } else if (state
                                                                          is AccountFailed) {
                                                                        context
                                                                            .loaderOverlay
                                                                            .hide();
                                                                        showCustomSnackbar(
                                                                          context:
                                                                              context,
                                                                          message:
                                                                              state.message,
                                                                          isSuccess:
                                                                              false,
                                                                        );
                                                                      }
                                                                    },
                                                                    builder: (
                                                                      context,
                                                                      state,
                                                                    ) {
                                                                      return CustomFilledButton(
                                                                        title:
                                                                            'Simpan Perubahan',
                                                                        onPressed: () async {
                                                                          FocusScope.of(
                                                                            context,
                                                                          ).requestFocus(
                                                                            FocusNode(),
                                                                          );
                                                                          if (_formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            context.loaderOverlay.show();
                                                                            final roleId =
                                                                                roleIds[selectedRole];
                                                                            context
                                                                                .read<
                                                                                  AccountBloc
                                                                                >()
                                                                                .add(
                                                                                  UpdateAccount(
                                                                                    id:
                                                                                        account.id,
                                                                                    data: AccountUpdateFormModel(
                                                                                      name:
                                                                                          nameController.text,
                                                                                      username:
                                                                                          usernameController.text,
                                                                                      email:
                                                                                          emailController.text,
                                                                                      password:
                                                                                          passwordController.text.isEmpty
                                                                                              ? null
                                                                                              : passwordController.text,
                                                                                      passwordConfirmation:
                                                                                          confirmController.text.isEmpty
                                                                                              ? null
                                                                                              : confirmController.text,
                                                                                      roleId:
                                                                                          roleId!,
                                                                                      status:
                                                                                          account.status,
                                                                                    ),
                                                                                  ),
                                                                                );
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 16,
                                                                ),
                                                                CustomOutlineButton(
                                                                  title:
                                                                      'Batalkan Perubahan',
                                                                  textColor: Color(
                                                                    0xFFF22121,
                                                                  ),
                                                                  onPressed: () {
                                                                    NavigationHelper.pop(
                                                                      context,
                                                                    );
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );

                                          if (result && context.mounted) {
                                            _accountController.pagingController
                                                .refresh();
                                          }
                                        },
                                        icon: Icon(
                                          Hicons.editSquareLightOutline,
                                          color: primary1,
                                        ),
                                      ),
                                    ),
                                    BlocProvider(
                                      create: (context) => AccountBloc(),
                                      child: BlocConsumer<
                                        AccountBloc,
                                        AccountState
                                      >(
                                        listener: (context, state) {
                                          if (state is AccountDeleted) {
                                            context.loaderOverlay.hide();
                                            _accountController.pagingController
                                                .refresh();
                                          } else if (state is AccountFailed) {
                                            context.loaderOverlay.hide();
                                            showCustomSnackbar(
                                              context: context,
                                              message: state.message,
                                              isSuccess: false,
                                            );
                                          }
                                        },
                                        builder: (context, state) {
                                          return SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: IconButton(
                                              onPressed: () {
                                                showConfirmationDialog(
                                                  context: context,
                                                  title: 'Hapus Akun',
                                                  description:
                                                      'Apakah anda yakin ingin menghapus akun ini?',
                                                  onConfirm: () async {
                                                    context.loaderOverlay
                                                        .show();
                                                    context
                                                        .read<AccountBloc>()
                                                        .add(
                                                          DeleteAccount(
                                                            account.id,
                                                          ),
                                                        );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Hicons.delete2LightOutline,
                                                color: Color(0xFFF22121),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                        firstPageProgressIndicatorBuilder:
                            (_) => Center(child: CircularProgressIndicator()),
                        firstPageErrorIndicatorBuilder: (context) {
                          final error =
                              _accountController.pagingController.error
                                  ?.toString() ??
                              'Terjadi kesalahan';

                          if (error == 'Unauthenticated') {
                            Future.microtask(() {
                              if (context.mounted) {
                                NavigationHelper.pushAndRemoveUntil(
                                  context,
                                  LoginPage(),
                                );
                              }
                            });
                          }

                          return ErrorStateWidget(
                            onTap:
                                () =>
                                    _accountController.pagingController
                                        .refresh(),
                            errorType: error,
                          );
                        },
                        noItemsFoundIndicatorBuilder:
                            (_) => const NoItemsFoundIndicator(),
                        newPageErrorIndicatorBuilder:
                            (context) => NewPageErrorIndicator(
                              onRetry:
                                  () =>
                                      _accountController.pagingController
                                          .retryLastFailedRequest(),
                            ),
                        newPageProgressIndicatorBuilder:
                            (context) => const NewPageProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          role == 'Diskominfo'
              ? CustomFloatingActionButton(
                onTap: () async {
                  final nameController = TextEditingController();
                  final usernameController = TextEditingController();
                  final emailController = TextEditingController();
                  final passwordController = TextEditingController();
                  String? selectedRole;
                  int? selectedDinas;
                  final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return SafeArea(
                            child: Dialog(
                              insetPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                ),
                                padding: EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Tambah Akun',
                                          style: interHeadlineSemibold,
                                        ),
                                        SizedBox(height: 24),
                                        CustomOutlineForm(
                                          controller: nameController,
                                          title: 'Nama Lengkap',
                                          placeholder: 'Masukkan nama lengkap',
                                          badgeRequired: true,
                                        ),
                                        SizedBox(height: 16),
                                        CustomOutlineForm(
                                          controller: usernameController,
                                          title: 'Username',
                                          placeholder: 'Masukkan username',
                                          badgeRequired: true,
                                        ),
                                        SizedBox(height: 16),
                                        CustomOutlineForm(
                                          controller: emailController,
                                          title: 'E-mail',
                                          placeholder: 'Masukkan e-mail',
                                          badgeRequired: true,
                                        ),
                                        SizedBox(height: 16),
                                        CustomOutlineForm(
                                          controller: passwordController,
                                          title: 'Kata Sandi',
                                          placeholder: 'Masukkan kata sandi',
                                          isPassword: true,
                                          badgeRequired: true,
                                        ),
                                        SizedBox(height: 16),
                                        CustomDropdown(
                                          selectedValue: selectedRole,
                                          title: 'Role',
                                          placeholder: 'Pilih role',
                                          listItem: listRole,
                                          badgeRequired: true,
                                          onChanged: (value) {
                                            setModalState(() {
                                              selectedRole = value;
                                            });
                                          },
                                        ),
                                        if (selectedRole != null &&
                                            [
                                              'OPD',
                                              'Verifikator',
                                            ].contains(selectedRole)) ...[
                                          SizedBox(height: 16),

                                          BlocBuilder<DinasBloc, DinasState>(
                                            builder: (context, state) {
                                              List<DinasModel> listDinas = [];
                                              if (state is DinasLoaded) {
                                                listDinas = state.listDinas;
                                              }

                                              return CustomDropdownGeneric<
                                                DinasModel
                                              >(
                                                title: 'Dinas',
                                                badgeRequired: true,
                                                selectedItem:
                                                    selectedDinas != null
                                                        ? listDinas.firstWhere(
                                                          (d) =>
                                                              d.id ==
                                                              selectedDinas,
                                                          orElse:
                                                              () =>
                                                                  listDinas
                                                                      .first,
                                                        )
                                                        : null,
                                                onChanged: (value) {
                                                  if (value != null) {
                                                    selectedDinas = value.id;
                                                  }
                                                },
                                                items: listDinas,
                                                itemAsString: (d) => d.nama,
                                                compareFn:
                                                    (a, b) => a.id == b.id,
                                                hintText: 'Pilih Dinas',
                                              );
                                            },
                                          ),
                                        ],
                                        SizedBox(height: 24),
                                        BlocProvider(
                                          create: (context) => AccountBloc(),
                                          child: BlocConsumer<
                                            AccountBloc,
                                            AccountState
                                          >(
                                            listener: (context, state) {
                                              if (state is AccountCreated) {
                                                context.loaderOverlay.hide();
                                                NavigationHelper.pop(
                                                  context,
                                                  true,
                                                );
                                              } else if (state
                                                  is AccountFailed) {
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
                                                title: 'Simpan Akun',
                                                useCheckInternet: true,
                                                onPressed: () async {
                                                  FocusScope.of(
                                                    context,
                                                  ).requestFocus(FocusNode());
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    context.loaderOverlay
                                                        .show();
                                                    final roleId =
                                                        roleIds[selectedRole];
                                                    context.read<AccountBloc>().add(
                                                      CreateAccount(
                                                        AccountCreateFormModel(
                                                          name:
                                                              nameController
                                                                  .text,
                                                          username:
                                                              usernameController
                                                                  .text,
                                                          email:
                                                              emailController
                                                                  .text,
                                                          password:
                                                              passwordController
                                                                  .text,
                                                          roleId: roleId!,
                                                          dinasId:
                                                              selectedDinas,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        CustomOutlineButton(
                                          title: 'Batal',
                                          textColor: Color(0xFFF22121),
                                          onPressed: () {
                                            NavigationHelper.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );

                  if (result && context.mounted) {
                    _accountController.pagingController.refresh();
                  }
                },
              )
              : SizedBox.shrink(),
    );
  }
}
