import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_pin_field.dart';
import '../../../config/app_colors.dart';
import '../../../controller/otp_verification/otp_verification_controller.dart';
import '../../widgets/common_curve_appbar.dart';

class OtpVerificationScreen extends StatelessWidget {
  OtpVerificationScreen({super.key});

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

  final _otpVerificationController = Get.find<OtpVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonCurveAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.kPrimaryColor
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              "otp_verification".tr,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.colorTextPrimary,
                fontSize: 20.fontMultiplier,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 4),
            child: Text(
                      _otpVerificationController.authType == AuthType.phone ?  "enter_verification_code_phone".tr : 'enter_verification_code_email'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.color95,
                  fontSize: 16.fontMultiplier,
                ),
              ),

          ),

          Align(
            alignment: Alignment.center,
            child: CommonCardWidget(
              margin: const EdgeInsets.only(top: 16.0, bottom: 0.0),
              child: CommonPinField(
                textEditingController:
                    _otpVerificationController.otpFieldController,
                onChanged: (String pin) {
                  _otpVerificationController.enableVerifyBtn.value =
                      pin.length == 4;
                },
                onComplete: (String pin) {
                  _otpVerificationController.enableVerifyBtn.value =
                      pin.length == 4;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ),
          ),
          Center(
            child: Obx(
              () => _otpVerificationController.start.value == 0
                  ? TextButton(
                      onPressed: () {
                        _otpVerificationController.requestOtp();
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
                                    '${_otpVerificationController.start.value} s',
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
          CommonButton(
            isEnable: _otpVerificationController.enableVerifyBtn,
            isLoading: _otpVerificationController.isLoading,
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            text: 'verify'.tr,
            onPressed: () {
              _otpVerificationController.verifyOtp();
            },
          ),
        ],
      ),
    );
  }
}
