import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';
import '../../../config/app_colors.dart';
import '../../../consts/app_images.dart';
import '../../../route/app_routes.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Image.asset(
                  AppImages.imgBgCollage,
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRect(
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.9),
                              Colors.white
                            ],
                          ).createShader(
                              Rect.fromLTRB(0, 0, rect.width, rect.height));
                        },
                        blendMode: BlendMode.dstIn,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: SizeConfig.heightMultiplier * 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: SizeConfig.heightMultiplier * 35,
                      padding: const EdgeInsets.only(top: 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 32),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppIcons.icAppHeartRed,
                                  height: 32,
                                  width: 32,
                                ),
                                const SizedBox(width: 8.0),
                                Text(
                                  'streax'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Inter',
                                        color: AppColors.colorTextPrimary,
                                        fontSize:  29.fontMultiplier,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          CommonButton(
                            text: "sign_up",
                            margin: const  EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                            backgroundColor: AppColors.kPrimaryColor,
                            onPressed: () {
                              Get.offNamed(AppRoutes.routeSignUpScreen);
                            },
                          ),
                          CommonButton(
                            backgroundColor: AppColors.colorC2,
                            text: "sign_in",
                            onPressed: () {
                              Get.offNamed(AppRoutes.routeSignInScreen);
                            },
                          ),
          
                          const SizedBox(
                            height: 24.0,
                          )
          
                          //
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
