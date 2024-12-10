import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/dialogs/common/country_code_picker_dialog.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_curve_appbar.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import '../../../config/app_colors.dart';
import '../../../controller/forgot_password/forgot_password_controller.dart';
import '../../../route/app_routes.dart';
import '../../../utils/validations.dart';
import '../../widgets/common_input_feilds.dart';
import '../../widgets/common_phone_input_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final _forgotPasswordController = Get.find<ForgotPasswordController>();

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
        ),
        body: LayoutBuilder(
          builder: (BuildContext context,BoxConstraints constraints) {
            return Container(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.start,
               // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Text(
                      "forgot_password".tr,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.colorTextPrimary,
                            fontSize: 20.fontMultiplier,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
                    child: Obx(
                      () => Text(
                        _forgotPasswordController.authType.value == AuthType.phone
                            ? "message_forgot_password_phone".tr
                            : "message_forgot_password_email".tr,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.color95,
                              fontSize: 16.fontMultiplier,
                            ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: _forgotPasswordController.formKey,
                        child: CommonCardWidget(
                          padding:
                              const EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Obx(
                              ()=> AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _forgotPasswordController.authType.value ==
                                            AuthType.email
                                        ? "email_address".tr
                                        : 'phone_number'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                            color: AppColors.colorTextPrimary,
                                            fontSize: 14.fontMultiplier),
                                  ),
                                  if (_forgotPasswordController.authType.value ==
                                      AuthType.phone)
                                    CommonPhoneInputField(
                                        validator: Validations.checkPhoneValidations,
                                        inputType: TextInputType.number,
                                        controller:
                                            _forgotPasswordController.phoneController,
                                        hint: 'phone_number'.tr,
                                        countryCodePickerCallback: () =>
                                            CountryCodePickerDialog.show(
                                                context: context,
                                                onSelect: _forgotPasswordController
                                                    .selectedCountry),
                                        selectedCountry:
                                            _forgotPasswordController.selectedCountry),
                                  if (_forgotPasswordController.authType.value ==
                                      AuthType.email)
                                    CommonInputField(
                                        validator: Validations.checkEmailValidations,
                                        textCapitalization: TextCapitalization.none,
                                        controller:
                                            _forgotPasswordController.emailController,
                                        hint: "email_address".tr),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () {
                                          _forgotPasswordController.authType.value =
                                              _forgotPasswordController
                                                          .authType.value ==
                                                      AuthType.phone
                                                  ? AuthType.email
                                                  : AuthType.phone;

                                          _forgotPasswordController.emailController
                                              .clear();
                                          _forgotPasswordController.phoneController
                                              .clear();
                                        },
                                        child: Text(
                                            _forgotPasswordController
                                                        .authType.value ==
                                                    AuthType.phone
                                                ? "forgot_with_email".tr
                                                : "forgot_with_phone".tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                    fontSize: 12.0.fontMultiplier,
                                                    color: AppColors.kPrimaryColor))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  CommonButton(
                    isLoading: _forgotPasswordController.isLoading,
                    text: 'send_otp'.tr,
                    onPressed: () {
                      _forgotPasswordController.forgotPassword();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 26),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: MaterialButton(
                        onPressed: () => {},
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            text: TextSpan(
                                text: 'remember_password'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(height: 5.5),
                                children: <InlineSpan>[
                                  const WidgetSpan(child: SizedBox(width: 5.0)),
                                  TextSpan(
                                      text: 'sign_in'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: AppColors.kPrimaryColor,
                                          ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.toNamed(AppRoutes.routeSignInScreen);
                                        })
                                ]),
                          ),
                        ),
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
