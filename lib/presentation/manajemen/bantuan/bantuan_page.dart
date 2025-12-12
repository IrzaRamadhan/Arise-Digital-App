import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hicons/flutter_hicons.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../bloc/faq/faq_bloc.dart';
import '../../../data/models/faq_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../helper/navigation_helper.dart';
import '../../../shared/theme.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/floating_action_button.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/states/no_item_found.dart';
import '../../login/login_page.dart';
import 'bantuan_add_page.dart';
import 'bantuan_edit_page.dart';

class BantuanPage extends StatefulWidget {
  const BantuanPage({super.key});

  @override
  State<BantuanPage> createState() => _BantuanPageState();
}

class _BantuanPageState extends State<BantuanPage> {
  int? _activeIndex;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqBloc()..add(FetchFaq()),
      child: BlocConsumer<FaqBloc, FaqState>(
        listener: (context, state) {
          if (state is FaqFailed && state.message == 'Unauthenticated') {
            NavigationHelper.pushAndRemoveUntil(context, LoginPage());
          }
        },
        builder: (context, state) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11),
                    color: primary1,
                    child: Row(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/bantuan.png', width: 130),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bantuan Aplikasi ARISE!',
                                style: interBodyLargeBold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Temukan panduan, jawaban, dan dukungan untuk memudahkan Anda dalam mengelola aset TI maupun non-TI.',
                                style: interBodySmallRegular.copyWith(
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Body
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: BlocBuilder<FaqBloc, FaqState>(
                        builder: (context, state) {
                          if (state is FaqLoaded) {
                            if (state.faqs.isEmpty) {
                              return NoItemsFoundIndicator();
                            }
                            if (AuthService().getRole() == 'Diskominfo') {
                              return Column(
                                children: [
                                  Row(
                                    spacing: 8,
                                    children: [
                                      SizedBox(
                                        width: 18,
                                        child: Center(
                                          child: Text(
                                            'No',
                                            style: interSmallSemibold.copyWith(
                                              color: primary1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'Pertanyaan',
                                            style: interSmallSemibold.copyWith(
                                              color: primary1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 65,
                                        child: Center(
                                          child: Text(
                                            'Tgl Edit',
                                            style: interSmallSemibold.copyWith(
                                              color: primary1,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 73,
                                        child: Center(
                                          child: Text(
                                            'Aksi',
                                            style: interSmallSemibold.copyWith(
                                              color: primary1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(bottom: 70),
                                      itemCount: state.faqs.length,
                                      itemBuilder: (context, index) {
                                        FaqModel faq = state.faqs[index];
                                        return _buildFaqItemAdmin(
                                          ctxFaq: context,
                                          index: index,
                                          faq: faq,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return ListView.separated(
                                separatorBuilder:
                                    (context, index) => SizedBox(height: 16),
                                itemCount: state.faqs.length,

                                itemBuilder: (context, index) {
                                  FaqModel faq = state.faqs[index];
                                  return _buildFaqItem(
                                    index: index,
                                    question: faq.pertanyaan,
                                    answer: faq.jawaban,
                                  );
                                },
                              );
                            }
                          } else if (state is FaqFailed) {
                            return Center(child: Text(state.message));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar:
                AuthService().getRole() == 'Diskominfo'
                    ? null
                    : SafeArea(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              offset: const Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              offset: const Offset(0, -8),
                              blurRadius: 16,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          spacing: 24,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Perlu info lebih lanjut?',
                                style: interSmallSemibold.copyWith(
                                  color: Color(0xFF222121),
                                ),
                              ),
                            ),
                            Container(
                              width: 160,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: primary1,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                spacing: 8,
                                children: [
                                  Image.asset(
                                    'assets/images/whatsapp.png',
                                    width: 32,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Hubungi Pusat Bantuan',
                                      style: interSmallBold.copyWith(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

            floatingActionButton:
                AuthService().getRole() != 'Diskominfo'
                    ? null
                    : Builder(
                      builder: (context) {
                        return CustomFloatingActionButton(
                          onTap: () {
                            NavigationHelper.push(
                              context,
                              BantuanAddPage(),
                            ).then((value) {
                              if (value) {
                                if (context.mounted) {
                                  context.read<FaqBloc>().add(FetchFaq());
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
          );
        },
      ),
    );
  }

  Widget _buildFaqItemAdmin({
    required BuildContext ctxFaq,
    required int index,
    required FaqModel faq,
  }) {
    return Column(
      children: [
        Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              child: Text(
                '${index + 1}',
                style: interSmallRegular.copyWith(color: Color(0xFFA4A5AC)),
              ),
            ),
            Expanded(
              child: Text(
                faq.pertanyaan,
                style: interSmallRegular.copyWith(color: Color(0xFFA4A5AC)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 65,
              child: Text(
                DateFormat('d/M/y').format(faq.createdAt),
                style: interSmallRegular.copyWith(color: Color(0xFFA4A5AC)),
              ),
            ),
            SizedBox(
              width: 73,
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      onPressed: () {
                        NavigationHelper.push(
                          context,
                          BantuanEditPage(faq: faq),
                        ).then((value) {
                          if (value) {
                            if (ctxFaq.mounted) {
                              ctxFaq.read<FaqBloc>().add(FetchFaq());
                            }
                          }
                        });
                      },
                      icon: Icon(
                        Hicons.editSquareLightOutline,
                        color: primary1,
                        size: 20,
                      ),
                    ),
                  ),
                  BlocProvider(
                    create:
                        (context) => FaqBloc(useConnectivityListener: false),
                    child: BlocConsumer<FaqBloc, FaqState>(
                      listener: (context, state) {
                        if (state is FaqDeleted) {
                          context.loaderOverlay.hide();
                          ctxFaq.read<FaqBloc>().add(FetchFaq());
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
                        return SizedBox(
                          width: 36,
                          height: 36,
                          child: IconButton(
                            onPressed: () async {
                              showConfirmationDialog(
                                context: context,
                                title: 'Hapus FAQ',
                                description:
                                    'Apakah anda yakin ingin menghapus FAQ ini?',
                                onConfirm: () async {
                                  context.loaderOverlay.show();
                                  context.read<FaqBloc>().add(
                                    DeleteFaq(faq.id),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Hicons.delete2LightOutline,
                              color: danger600,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
  }) {
    final bool expanded = _activeIndex == index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_activeIndex == index) {
                _activeIndex = null;
              } else {
                _activeIndex = index;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF2B3791).withValues(alpha: 0.12),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 10,
              children: [
                Icon(
                  expanded ? Hicons.up2Bold : Hicons.down2Bold,
                  color: const Color(0xFFF58612),
                ),
                Expanded(
                  child: Text(
                    question,
                    style: poppinsSmallRegular.copyWith(
                      color: const Color(0xFF4B4B4C),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 44, top: 8),
            child: Text(
              answer,
              style: poppinsSmallRegular.copyWith(
                color: const Color(0xFF4B4B4C),
              ),
            ),
          ),
      ],
    );
  }
}
