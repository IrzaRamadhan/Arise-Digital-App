import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'bloc/area_dampak/area_dampak_bloc.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/dinas/dinas_bloc.dart';
import 'bloc/informasi_umum/informasi_umum_bloc.dart';
import 'bloc/jabatan/jabatan_bloc.dart';
import 'bloc/kategori_risiko/kategori_risiko_bloc.dart';
import 'bloc/kompetensi/kompetensi_bloc.dart';
import 'bloc/level_dampak/level_dampak_bloc.dart';
import 'bloc/level_kemungkinan/level_kemungkinan_bloc.dart';
import 'bloc/lokasi/lokasi_bloc.dart';
import 'bloc/matriks_risiko/matriks_risiko_bloc.dart';
import 'bloc/penanggung_jawab/penanggung_jawab_bloc.dart';
import 'bloc/peraturan/peraturan_bloc.dart';
import 'bloc/sasaran_risiko/sasaran_risiko_bloc.dart';
import 'bloc/sub_kategori/sub_kategori_bloc.dart';
import 'bloc/unit_kerja/unit_kerja_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'bloc/vendor/vendor_bloc.dart';
import 'presentation/splash/splash_page.dart';
import 'shared/theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await Hive.openBox('credentials');
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => UserBloc()),

        // Penetapan Konteks
        BlocProvider(
          create: (context) => InformasiUmumBloc()..add(FetchInformasiUmum()),
        ),
        BlocProvider(
          create: (context) => SasaranRisikoBloc()..add(FetchSasaranRisiko()),
        ),
        BlocProvider(
          create: (context) => PeraturanBloc()..add(FetchPeraturan()),
        ),
        BlocProvider(
          create: (context) => KategoriRisikoBloc()..add(FetchKategoriRisiko()),
        ),
        BlocProvider(
          create: (context) => AreaDampakBloc()..add(FetchAreaDampak()),
        ),
        BlocProvider(
          create: (context) => LevelDampakBloc()..add(FetchLevelDampak()),
        ),
        BlocProvider(
          create:
              (context) => LevelKemungkinanBloc()..add(FetchLevelKemungkinan()),
        ),
        BlocProvider(
          create: (context) => MatriksRisikoBloc()..add(FetchMatriksRisiko()),
        ),

        // Master Data
        BlocProvider(
          create: (context) => SubKategoriBloc()..add(FetchSubKategori()),
        ),
        BlocProvider(create: (context) => VendorBloc()..add(FetchVendor())),
        BlocProvider(create: (context) => LokasiBloc()..add(FetchLokasi())),
        BlocProvider(create: (context) => DinasBloc()..add(FetchDinas())),
        BlocProvider(create: (context) => JabatanBloc()..add(FetchJabatan())),
        BlocProvider(
          create: (context) => KompetensiBloc()..add(FetchKompetensi()),
        ),
        BlocProvider(
          create:
              (context) => UnitKerjaBloc()..add(FetchUnitKerja(dinasId: null)),
        ),
        BlocProvider(
          create:
              (context) => PenanggungJawabBloc()..add(FetchPenanggungJawab()),
        ),
      ],
      child: GlobalLoaderOverlay(
        overlayColor: Colors.black.withValues(alpha: 0.4),
        overlayWidgetBuilder: (_) {
          return Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: CircularProgressIndicator(color: primary1)),
            ),
          );
        },
        child: MaterialApp(
          title: 'Arise',
          debugShowCheckedModeBanner: false,
          home: SplashPage(),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: primary1),
            appBarTheme: AppBarTheme(
              toolbarHeight: 60,
              centerTitle: true,
              color: Colors.white,
              titleTextStyle: interHeadlineSemibold.copyWith(
                color: Color(0xFF282525),
              ),
              surfaceTintColor: Colors.white,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEAE9EA)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEAE9EA)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEAE9EA)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: danger600),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: danger600),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFEFEFEF)),
              ),
              errorStyle: interSmallRegular.copyWith(color: danger600),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xFFFBFBFB)),
          ),
          locale: const Locale('id', 'ID'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
        ),
      ),
    );
  }
}
