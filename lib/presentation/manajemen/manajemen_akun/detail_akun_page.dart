import 'package:arise/bloc/account/account_bloc.dart';
import 'package:arise/data/models/account_model.dart';
import 'package:arise/data/models/user_model.dart';
import 'package:arise/shared/theme.dart';
import 'package:arise/widgets/states/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailAkunPage extends StatefulWidget {
  final int id;
  const DetailAkunPage({super.key, required this.id});

  @override
  State<DetailAkunPage> createState() => _DetailAkunPageState();
}

class _DetailAkunPageState extends State<DetailAkunPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc()..add(FetchAccount(id: widget.id)),
      child: Scaffold(
        appBar: AppBar(title: Text('Detail Akun')),
        body: SafeArea(
          child: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              if (state is AccountLoaded) {
                AccountModel accout = state.account;
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
                            color: Colors.black.withOpacity(0.04),
                            offset: const Offset(0, 0),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        spacing: 4,
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/user_1.jpg',
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
                                      accout.name,
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
                                      accout.username,
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
                                      accout.email,
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
                                    Text(
                                      'Dinas',
                                      style: interBodySmallSemibold.copyWith(
                                        color: Color(0xFF2B2B2B),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Pemerintah Kota Surabaya',
                                      style: interSmallRegular.copyWith(
                                        color: Color(0xFF4A4848),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Role',
                                      style: interBodySmallSemibold.copyWith(
                                        color: Color(0xFF2B2B2B),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${roles[int.parse(accout.roleId)]}',
                                      style: interSmallRegular.copyWith(
                                        color: Color(0xFF4A4848),
                                      ),
                                    ),
                                    SizedBox(height: 8),
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
                                  color:
                                      accout.status == 'Active'
                                          ? success100
                                          : danger100,
                                  border: Border.all(
                                    color:
                                        accout.status == 'Active'
                                            ? success600
                                            : danger600,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  accout.status,
                                  style: interSmallRegular.copyWith(
                                    color:
                                        accout.status == 'Active'
                                            ? success600
                                            : danger600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is AccountFailed) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ErrorStateWidget(
                      onTap: () {
                        context.read<AccountBloc>().add(
                          FetchAccount(id: widget.id),
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
      ),
    );
  }
}
