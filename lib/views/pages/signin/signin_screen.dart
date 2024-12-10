import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/auth_controller.dart';
import 'package:streax/controller/signin/signin_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_auth_form_widget.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_button_icon.dart';
import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';
import '../../widgets/common_curve_appbar.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _signInController = Get.find<SignInController>();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CommonCurveAppBar(
          systemUiOverlayStyle: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: AppColors.kPrimaryColor),
          leading: const SizedBox(),
        ),
        body: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'log_in_to_streax'.tr,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            color: AppColors.colorTextPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.5),
                      ),
                    ),

                    CommonAuthFormWidget(
                      isUserExist: RxBool(false),
                      formKey: _signInController.formKey,
                      authFormType: AuthFormType.signIn,
                      emailController: _signInController.emailController,
                      phoneController: _signInController.phoneController,
                      passwordController: _signInController.passwordController,
                      selectedCountry: _signInController.selectedCountry,
                      onAuthTypeChange: (AuthType authType) {
                        _signInController.authType = authType;
                      },
                    ),

                    CommonButton(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        text: "sign_in".tr,
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _signInController.login();
                        }),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                                color: AppColors.colorTextPrimary.withOpacity(
                                    0.3),
                                thickness: 1.0,
                              )),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0),
                            height: 25,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.colorTextPrimary.withOpacity(
                                      0.0),
                                ),
                                color: AppColors.colorTextPrimary.withOpacity(
                                    0.1),
                                borderRadius: BorderRadius.circular(24.0)),
                            child: Center(
                                child: Text(
                                  "or".tr,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                    fontSize: 12.fontMultiplier,
                                    color: AppColors.colorTextPrimary
                                        .withOpacity(0.5),
                                  ),
                                )),
                          ),
                          Expanded(
                              child: Divider(
                                color: AppColors.colorTextPrimary.withOpacity(
                                    0.3),
                                thickness: 1.0,
                              ))
                        ],
                      ),
                    ),

                    if(Platform.isIOS) CommonButtonIcon(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      elevation: 0,
                      backgroundColor: AppColors.color2A,
                      text: "apple_sign_in".tr,
                      onPressed: () {
                        _authController.loginWithApple();
                      },
                      icon: SvgPicture.asset(
                        AppIcons.icApple,
                        height: 25,
                        width: 20,
                      ),),

                    CommonButtonIcon(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        borderColor: AppColors.colorE8,
                        borderRadius: 8,
                        borderWidth: 1,
                        textColor: AppColors.color95,
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            AppIcons.icGoogle,
                            height: 25,
                            width: 20,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                        text: "google_sign_in".tr,
                        onPressed: () {
                          _authController.loginUsingGoogle();
                        }),
                    Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 8, bottom: 24),
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                              text: 'dont_have_account'.tr,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  color: AppColors.colorTextPrimary,
                                  fontWeight: FontWeight.w600
                              ),

                              children: [
                                const WidgetSpan(child: SizedBox(width: 3.0)),
                                TextSpan(
                                    text: 'sign_up'.tr,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.fontMultiplier,
                                      color: AppColors.kPrimaryColor,),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offNamed(
                                            AppRoutes.routeSignUpScreen);
                                      })
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
