import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/forgot_password/reset_password_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_curve_appbar.dart';
import 'package:streax/views/widgets/common_password_input_feilds.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);
  final _resetPasswordController = Get.find<ResetPasswordController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonCurveAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: AppColors.kPrimaryColor),
      ),
      body: ListView(
        padding: const  EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              "create_new_password".tr,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.colorTextPrimary,
                    fontSize: 20.fontMultiplier,
                  ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Text(
              'hint_new_password'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.color95,
                    fontSize: 16.fontMultiplier,
                  ),
            ),
          ),
          CommonCardWidget(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Form(
              key: _resetPasswordController.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonPasswordInputField(
                      title: 'new_password'.tr,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      controller: _resetPasswordController.passwordController,
                      hint: "new_password",
                  validator: Validations.checkPasswordValidations,),
                  CommonPasswordInputField(
                      title: 'confirm_password'.tr,
                      margin: const EdgeInsets.only(top: 10, bottom: 5),
                      isShowText: false,
                      suffixIcon: const SizedBox.shrink(),
                      controller: _resetPasswordController.confirmPasswordController,
                      hint: "confirm_password",
                    validator: (String? value){
                        return Validations.checkConfirmPasswordValidations(value,
                            _resetPasswordController.passwordController.text.toString().trim());
                    },
                  )
                ],
              ),
            ),
          ),
          CommonButton(
            isLoading: _resetPasswordController.isLoading,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            text: 'reset_password'.tr,
            onPressed: () {
              _resetPasswordController.resetPassword();

            },
          )
        ],
      ),
    );
  }
}
