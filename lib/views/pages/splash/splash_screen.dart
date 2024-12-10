import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_raw_res.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/preference_manager.dart';
import '../../../config/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int animationDelay = 3; //seconds

  Timer? _timer;

  moveToNextScreen() {
    cancelTimer();
    _timer = Timer(Duration(seconds: animationDelay), () {
     final user = PreferenceManager.user;
      if (PreferenceManager.token.isEmpty) {
        Get.offNamed(AppRoutes.routeSignInScreen);
      } else if (user?.userName == null) {
        Get.offNamed(AppRoutes.routeSetupBasicInfoScreen);
      } else {
        Get.offNamed(AppRoutes.routeDashBoardScreen);
      }
    });
  }

  cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(statusBarColor: AppColors.kPrimaryColor),
      child: Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Image.asset(
              AppRawRes.splashLogo,
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }
}

