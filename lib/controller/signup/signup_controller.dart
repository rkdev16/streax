import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/request_otp_res_model.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import '../../consts/app_formatters.dart';

import '../../route/app_routes.dart';
import '../../utils/app_alerts.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final isAgreeTerms = false.obs;
  final RxBool isSelected = true.obs;
  final RxBool isUserExists = false.obs;
  Worker? emailTextChangeWorker;
  Worker? phoneTextChangeWorker;

  final isGoogleLoading = false.obs;

  GoogleSignIn googleSignIn = GoogleSignIn();

  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  var selectedCountry = Rx<Country>(Country.parse('US'));

  RxString email = ''.obs;
  RxString phone = ''.obs;

  RxBool isLoading = false.obs;

  AuthType authType = AuthType.phone;

  @override
  void onInit() {
    super.onInit();
    initTextEditingController();
    setupWorkers();
  }


  @override
  void onClose() {
    disposeTextEditingController();
    disposeWorkers();
    super.onClose();
  }



  initTextEditingController() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  onChangeAgreeTerms(bool? isAgree){
    isAgreeTerms.value = isAgree??false;
  }

  disposeTextEditingController() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  void setupWorkers() {
    emailTextChangeWorker =
        debounce(email, (callback) => checkEmailExist(email.value));
    emailController.addListener(() {
      isUserExists.value = false;
      email.value = emailController.text.toString().trim();
    });

    phoneTextChangeWorker =
        debounce(phone, (callback) => checkPhoneExist(phone.value));
    phoneController.addListener(() {
      isUserExists.value = false;
      phone.value = phoneController.text.toString().trim();
    });
  }

  disposeWorkers() {
    emailTextChangeWorker?.dispose();
    phoneTextChangeWorker?.dispose();
  }

  checkEmailExist(String email) async {
    if (AppFormatters.validEmailExp.hasMatch(email)) {
      isUserExists.value = await PostRequests.checkEmailExist(email);
    }
  }

  checkPhoneExist(String phone) async {
    if (AppFormatters.validPhoneExp.hasMatch(phone)) {
      isUserExists.value = await PostRequests.checkPhoneExist(
          '+${selectedCountry.value.phoneCode}', phone);
    }
  }

  Future<void> requestOtp() async {
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      if (isUserExists.value) return;
      if(!isAgreeTerms.value) return;
      if (formKey.currentState!.validate()) {

        CommonLoader.show();
        RequestOtpResModel? result;
        if (authType == AuthType.phone) {
          result = await PostRequests.requestOtpMobile(
              "+${selectedCountry.value.phoneCode}",
              phoneController.text.toString().trim());
        } else if (authType == AuthType.email) {
          result = await PostRequests.requestOtpEmail(
              emailController.text.toString().trim());
        }

        CommonLoader.dismiss();

        if (result != null) {
          if (result.success) {
            Get.toNamed(AppRoutes.routeOtpVerificationScreen, arguments: {
              AppConsts.keyOtpVerificationFor: OtpVerificationFor.signup,
              AppConsts.keyOtpData: json.encode(result.otpData?.toJson()),
              AppConsts.keyPassword: passwordController.text.toString().trim(),
              AppConsts.keyAuthType: authType,
            });
          } else {
            AppAlerts.error(message: result.message);
          }
        } else {
          AppAlerts.error(message: 'message_server_error'.tr);
        }
      }
    } finally {
      CommonLoader.dismiss();
    }
  }
}
