import 'dart:io';
import 'dart:math';


import 'package:country_picker/country_picker.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:streax/config/device_info.dart';
import 'package:streax/notification/notification_service.dart';
import 'package:streax/route/app_pages.dart';
import 'package:streax/route/app_routes.dart';

import 'config/app_theme.dart';
import 'config/local_strings.dart';
import 'config/size_config.dart';
import 'consts/app_consts.dart';
import 'utils/preference_manager.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white));

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await PreferenceManager.init();
  await DeviceConfig.init();
  await PhotoManager.clearFileCache();
  await NotificationService().init();

  // Set FFmpegKit configuration

  FFmpegKitConfig.enableRedirection();
  FFmpegKitConfig.enableStatisticsCallback();
  FFmpegKitConfig.enableLogCallback((log) {
    final message = log.getMessage();
    debugPrint("message ======== $message");

  });

  runApp(const MyApp());

  FlutterNativeSplash.remove();
}


String getVideoSize({required File file}) => formatBytes(file.lengthSync(), 2);

String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) {
    return '0 B';
  }
  const List<String> suffixes = <String>[
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ];
  final int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
          SizeConfig.init(constraints, orientation);
          return GetMaterialApp(
            translations: LocalStrings(),
            locale: const Locale('en', 'US'),
            localizationsDelegates: const [
              CountryLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: AppConsts.appName,
            theme: appTheme(context),
            initialRoute: AppRoutes.routeSplashScreen,
            // initialRoute:  AppRoutes.routeSetupBasicInfoScreen,
            getPages: AppPages.pages,
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('es'),
              Locale('de'),
              Locale('fr'),
              Locale('el'),
              Locale('et'),
              Locale('nb'),
              Locale('nn'),
              Locale('pl'),
              Locale('pt'),
              Locale('ru'),
              Locale('hi'),
              Locale('ne'),
              Locale('uk'),
              Locale('hr'),
              Locale('tr'),
              Locale('lv'),
              Locale('lt'),
              Locale('ku'),
              Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
              // Generic Simplified Chinese 'zh_Hans'
              Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
              // Generic traditional Chinese 'zh_Hant'
            ],
          );
        });
      }),
    );
  }
}
