import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/auth_controller.dart';
import 'package:streax/network/api_urls.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/web_view/common_web_view_screen.dart';
import 'package:streax/views'
    '/widgets/common_auth_form_widget.dart';
import 'package:streax/views/widgets/common_button_icon.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_icons.dart';
import '../../../controller/signup/signup_controller.dart';
import '../../../route/app_routes.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_curve_appbar.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _signUpController = Get.find<SignupController>();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonCurveAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: AppColors.kPrimaryColor),
        leading: const SizedBox(),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('lets_get_started'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.fontMultiplier,
                              )),
                    ),
                    CommonAuthFormWidget(
                      formKey: _signUpController.formKey,
                      authFormType: AuthFormType.signUp,
                      emailController: _signUpController.emailController,
                      phoneController: _signUpController.phoneController,
                      passwordController: _signUpController.passwordController,
                      selectedCountry: _signUpController.selectedCountry,
                      isUserExist: _signUpController.isUserExists,
                      onAuthTypeChange: (AuthType authType) {
                        _signUpController.authType = authType;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Checkbox(
                                value: _signUpController.isAgreeTerms.value,
                                checkColor: Colors.white,
                                activeColor: AppColors.kPrimaryColor,
                                onChanged:
                                    _signUpController.onChangeAgreeTerms)),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: RichText(
                                    softWrap: true,
                                    text: TextSpan(
                                        text: 'i_am_18_years'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontSize: 12.fontMultiplier,
                                                color: AppColors
                                                    .colorTextSecondary),
                                        children: [
                                          TextSpan(
                                              text: 'terms_of_services'.tr,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => Get.to(
                                                    () => const CommonWebViewScreen(
                                                        title: 'terms_of_use',
                                                        url:
                                                            ApiUrls.termsOfUse),
                                                    curve: Curves.easeIn,
                                                    transition:
                                                        Transition.downToUp),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize:
                                                          12.fontMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .kPrimaryColor)),
                                          const WidgetSpan(
                                              child: SizedBox(
                                            width: 4,
                                          )),
                                          TextSpan(text: 'and'.tr),
                                          const WidgetSpan(
                                              child: SizedBox(
                                            width: 4,
                                          )),
                                          TextSpan(
                                              text: 'privacy_policy'.tr,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => Get.to(
                                                    () => const CommonWebViewScreen(
                                                        title: 'terms_of_use',
                                                        url: ApiUrls
                                                            .privacyPolicy),
                                                    curve: Curves.easeIn,
                                                    transition:
                                                        Transition.downToUp),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                      fontSize:
                                                          12.fontMultiplier,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .kPrimaryColor)),
                                        ])),
                              ),
                            )
                          ]),
                    ),
                    CommonButton(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        text: "sign_up".tr,
                        onPressed: () {
                          _signUpController.requestOtp();
                        }),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            color: AppColors.colorTextPrimary.withOpacity(0.3),
                            thickness: 1.0,
                          )),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            height: 25,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.colorTextPrimary
                                      .withOpacity(0.0),
                                ),
                                color:
                                    AppColors.colorTextPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24.0)),
                            child: Center(
                                child: Text(
                              "or".tr,
                              style: Theme.of(context)
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
                            color: AppColors.colorTextPrimary.withOpacity(0.3),
                            thickness: 1.0,
                          ))
                        ],
                      ),
                    ),
                    if (Platform.isIOS)
                      CommonButtonIcon(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          icon: SvgPicture.asset(
                            AppIcons.icApple,
                            height: 25,
                            width: 20,
                          ),
                          backgroundColor: AppColors.color2A,
                          text: "apple_sign_in".tr,
                          onPressed: () {
                            _authController.loginWithApple();
                          }),
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
                              text: 'already_have_account'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.fontMultiplier,
                                    color: AppColors.colorTextPrimary,
                                  ),
                              children: [
                                const WidgetSpan(child: SizedBox(width: 3.0)),
                                TextSpan(
                                    text: 'sign_in'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.fontMultiplier,
                                          color: AppColors.kPrimaryColor,
                                        ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offNamed(
                                            AppRoutes.routeSignInScreen);
                                      })
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Visibility(
                      visible: _signUpController.isLoading.value,
                      child: const CommonProgressBar()),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
