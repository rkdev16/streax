import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/controller/change_password/change_password_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_password_input_feilds.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import '../../widgets/common_app_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _changePasswordController = Get.find<ChangePasswordController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(

        appBar: CommonAppBar(
          backgroundColor: Colors.white,
          title: 'change_password'.tr,
          onBackTap: () {
            Get.back();
          },
        ),
        body: Form(
          key: _changePasswordController.formKey,
          child: Column(
            children: [
              CommonCardWidget(
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "old_password".tr,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 14.fontMultiplier),
                    ),
                    CommonPasswordInputField(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        controller:
                            _changePasswordController.oldPasswordController,
                        validator: Validations.checkEmptyFiledValidations,
                        hint: 'hint_password'.tr),
                    Text(
                      "new_password".tr,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 14.fontMultiplier),
                    ),
                    CommonPasswordInputField(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        validator: Validations.checkPasswordValidations,
                        controller:
                            _changePasswordController.newPasswordController,
                        hint: "hint_password".tr),
                    Text(
                      "confirm_password".tr,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontSize: 14.fontMultiplier),
                    ),
                    CommonPasswordInputField(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        controller:
                            _changePasswordController.confirmPasswordController,
                        validator: (String? value) {
                          return Validations.checkConfirmPasswordValidations(
                              value,
                              _changePasswordController.newPasswordController.text
                                  .toString()
                                  .trim());
                        },
                        hint: "hint_password".tr),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CommonButton(
          margin: const EdgeInsets.all(16),
          isLoading: _changePasswordController.isLoading,
          text: 'Save',
          onPressed: () {
          _changePasswordController.validateFormAndUpdatePassword();
          },
        ),
      ),
    );
  }
}
