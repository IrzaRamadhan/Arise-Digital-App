import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../helper/navigation_helper.dart';
import '../../shared/theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/confirmation_dialog.dart';
import '../../widgets/snackbar.dart';
import '../../widgets/states/error_state_widget.dart';
import '../login/login_page.dart';
import 'components/profile_edit_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final token = AuthService().getToken();
  @override
  void initState() {
    super.initState();
    if (token != '' && context.read<UserBloc>().state is! UserLoaded) {
      context.read<UserBloc>().add(FetchUser());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil Pengguna')),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserFailed) {
            if (state.message == 'Unauthenticated') {
              NavigationHelper.pushAndRemoveUntil(context, LoginPage());
            }
          }
        },
        builder: (context, state) {
          if (state is UserLoaded) {
            UserModel user = state.user;
            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFFE4E4E4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        offset: const Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    spacing: 4,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await showProfilEditDialog(
                            context: context,
                            user: user,
                          );
                          if (result != null && context.mounted) {
                            context.read<UserBloc>().add(FetchUser());
                          }
                        },

                        child: Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Hicons.editSquareLightOutline,
                              color: primary1,
                            ),
                            Text(
                              'Edit Akun',
                              style: interBodySmallSemibold.copyWith(
                                color: primary1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ClipOval(
                        child: Image.asset(
                          'assets/images/img_profile.webp',
                          width: 80,
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Lengkap',
                                  style: interBodySmallSemibold.copyWith(
                                    color: Color(0xFF2B2B2B),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user.name,
                                  style: interSmallRegular.copyWith(
                                    color: Color(0xFF4A4848),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Username',
                                  style: interBodySmallSemibold.copyWith(
                                    color: Color(0xFF2B2B2B),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user.username,
                                  style: interSmallRegular.copyWith(
                                    color: Color(0xFF4A4848),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Email',
                                  style: interBodySmallSemibold.copyWith(
                                    color: Color(0xFF2B2B2B),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user.email,
                                  style: interSmallRegular.copyWith(
                                    color: Color(0xFF4A4848),
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (user.dinasNama != null) ...[
                                  Text(
                                    'Dinas',
                                    style: interBodySmallSemibold.copyWith(
                                      color: Color(0xFF2B2B2B),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.dinasNama!,
                                    style: interSmallRegular.copyWith(
                                      color: Color(0xFF4A4848),
                                    ),
                                  ),
                                ],
                                SizedBox(height: 8),
                                Text(
                                  'Role',
                                  style: interBodySmallSemibold.copyWith(
                                    color: Color(0xFF2B2B2B),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  roles[user.roleId]!,
                                  style: interSmallRegular.copyWith(
                                    color: Color(0xFF4A4848),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      Row(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Status:',
                            style: interSmallRegular.copyWith(
                              color: Color(0xFF312F2F),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: success100,
                              border: Border.all(color: success600),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              user.status,
                              style: interSmallRegular.copyWith(
                                color: success600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLogoutSuccess) {
                      context.loaderOverlay.hide();
                      NavigationHelper.pushAndRemoveUntil(context, LoginPage());
                    } else if (state is AuthLogoutFailed) {
                      context.loaderOverlay.hide();
                      showCustomSnackbar(
                        context: context,
                        message: state.message,
                        isSuccess: false,
                      );
                    }
                  },
                  child: CustomOutlineButton(
                    title: 'Keluar',
                    icon: Hicons.logoutLightOutline,
                    textColor: danger600,
                    backgroundColor: danger100,
                    reverse: true,
                    onPressed: () async {
                      showConfirmationDialog(
                        context: context,
                        title: 'Keluar',
                        description: 'Apakah anda yakin ingin keluar?',
                        onConfirm: () async {
                          context.loaderOverlay.show();
                          context.read<AuthBloc>().add(AuthLogout());
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is UserFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ErrorStateWidget(onTap: () {}, errorType: state.message),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
