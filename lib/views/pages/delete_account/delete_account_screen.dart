import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/delete_account/delete_account_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_pin_field.dart';
import '../../widgets/common_app_bar.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});

  final _deleteAccountController = Get.find<DeleteAccountController>();
  final defaultPinTheme = PinTheme(
    width: 66,
    height: 66,
    textStyle: const TextStyle(
        fontSize: 18,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.colorF3, width: 1.5),
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
      child: Scaffold(
        appBar: CommonAppBar(
          backgroundColor: Colors.white,
          title: 'delete_account'.tr,
          onBackTap: () {
            Get.back();
          },
        ),
        body: CommonCardWidget(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "message_enter_pin".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Gap(16),
              CommonPinField(
                textEditingController:
                    _deleteAccountController.otpFieldController,
                onChanged: (String pin) {
                  _deleteAccountController.enableVerifyBtn.value =
                      pin.length == 4;
                },
                onComplete: (String pin) {
                  _deleteAccountController.enableVerifyBtn.value =
                      pin.length == 4;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              Center(
                child: Obx(
                      () => _deleteAccountController.start.value == 0
                      ? TextButton(
                      onPressed: () {
                        _deleteAccountController.sendOtp();
                      },
                      child: Text(
                        'resend_code'.tr,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.fontMultiplier,
                            color: AppColors.kPrimaryColor),
                      ))
                      : Padding(
                    padding:
                    const EdgeInsets.only(top: 16.0, bottom: 12),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'resend_code'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 16.fontMultiplier,
                              color: AppColors.kPrimaryColor,
                              fontWeight: FontWeight.w600),
                          children: <InlineSpan>[
                            const WidgetSpan(
                                child: SizedBox(width: 3.0)),
                            TextSpan(
                                text: 'in'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                  color: AppColors.colorTextPrimary,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {}),
                            const WidgetSpan(
                                child: SizedBox(width: 3.0)),
                            TextSpan(
                              text:
                              '${_deleteAccountController.start.value} s',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  fontSize: 16.fontMultiplier,
                                  color: AppColors.kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CommonButton(
          isLoading: _deleteAccountController.isLoading,
          isEnable: _deleteAccountController.enableVerifyBtn,
          margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
          text: 'delete_account'.tr,
          onPressed: () {
            _deleteAccountController.showDeleteAccountDialog();
          },
        ),
      ),
    );
  }
}
