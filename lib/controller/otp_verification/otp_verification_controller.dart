import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/forgot_password/forgot_password_controller.dart';
import 'package:streax/model/request_otp_res_model.dart';
import 'package:streax/model/signup_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';

const int timerCount = 60;
class OtpVerificationController extends GetxController {
  OtpVerificationFor? verificationFor;
  final TextEditingController otpFieldController = TextEditingController();
  String? enteredOtp;
  RxBool enableVerifyBtn = true.obs;

  RxBool isLoading = false.obs;
  Timer? _timer;
  final RxInt start = timerCount.obs;

  RxBool isEnableButton = false.obs;
  ForgotPasswordController? forgotPasswordController;
  AuthType? authType;
  OtpData? otpData;
  String? password;

  @override
  void onInit() {
    super.onInit();
    getArguments();
    initTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpFieldController.clear();
    super.onClose();
  }

  initTimer() {
    cancelTimer();
    start.value  =timerCount;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (start.value == 0) {
        _timer?.cancel();
      } else {
        start.value--;
      }
    });
  }

  cancelTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void getArguments() {
    Map<String, dynamic> data = Get.arguments;
    verificationFor = data[AppConsts.keyOtpVerificationFor];
    otpData = OtpData.fromJson(json.decode(data[AppConsts.keyOtpData]));
    password = data[AppConsts.keyPassword];
    authType = data[AppConsts.keyAuthType];

  }

  void requestOtp() {

    debugPrint("RequestOtp = $verificationFor");
    otpFieldController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    if (verificationFor == OtpVerificationFor.signup) {
      resendOtpSignup();
    } else if (verificationFor == OtpVerificationFor.forgotPassword) {
      resendOtpForgotPassword();
    }
  }

  void resendOtpSignup() async {
    try{
      isLoading.value = true;
      RequestOtpResModel? result;

      if (authType == AuthType.phone) {
        result = await PostRequests.requestOtpMobile(
            otpData?.countryCode??"",
            otpData?.mobile??"");
      } else if (authType == AuthType.email) {
        result = await PostRequests.requestOtpEmail(
            otpData?.email??'');
      }
      if (result != null) {

        if(result.success){
          otpData= result.otpData;
          start.value = timerCount;
          initTimer();
        }else{
          AppAlerts.error(message: result.message);
        }


      } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      }
    }finally{
      isLoading.value = false;
    }


  }

  void resendOtpForgotPassword() async {
    FocusManager.instance.primaryFocus!.unfocus();


    try{
      isLoading.value = true;
      Map<String,dynamic> requestBody = {};
      if(authType == AuthType.phone){
         requestBody.addAll({
           "mobile":otpData?.mobile??"",
           "countryCode":otpData?.countryCode??''
         });
      }else if(authType == AuthType.email){
        requestBody.addAll({
           "email": otpData?.email??""
         });
      }

      var result = await PostRequests.forgotPassword(requestBody);

      if(result !=null){
        if(result.success){

          start.value = timerCount;
          initTimer();
        }else{
          AppAlerts.error(message: result.message);
        }

      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }


    }finally{
      isLoading.value = false;
    }

    isLoading.value = true;
    var response = await PostRequests.requestOtpEmail(otpData?.email??'');
    isLoading.value = false;

    if (response != null) {
      if (response.success) {
        start.value = timerCount;
        initTimer();
      } else {
        AppAlerts.error(message: response.message);
      }
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
    }
  }


  verifyOtp() async {
    var enteredOtp = otpFieldController.text.toString().trim();
    if(enteredOtp == otpData?.otp){
      if(verificationFor == OtpVerificationFor.signup){
        registerUser();
      }else if(verificationFor == OtpVerificationFor.forgotPassword){
        Get.toNamed(AppRoutes.resetPasswordScreen,arguments: {
          AppConsts.keyOtpVerificationFor: OtpVerificationFor.forgotPassword,
          AppConsts.keyOtpData: json.encode(otpData?.toJson()),
          AppConsts.keyAuthType: authType,
        });


        Get.offNamed(AppRoutes.resetPasswordScreen);

      }

    }else{
      AppAlerts.error(message: 'message_wrong_otp'.tr);
    }
  }

  void registerUser() async {

    try {

      isLoading.value = true;

      Map<String,dynamic> requestBody = {};
      SignupResModel? result;

      if(authType ==AuthType.email){
        requestBody.assignAll({
          "email": otpData?.email,
          "otp": otpData?.otp,
          "password": password,
          "loginType": loginTypeValues.reverse[LoginType.manual]

        });
        result = await PostRequests.registerWithEmail(requestBody);
      }else if(authType == AuthType.phone){
        requestBody.assignAll({
          "otp": otpData?.otp,
          "countryCode": otpData?.countryCode,
          "mobile": otpData?.mobile,
          "password":password,
          "loginType": loginTypeValues.reverse[LoginType.manual]
        });
        result = await PostRequests.registerWithMobile(requestBody);
      }
      if(result !=null){
        if(result.success){
          PreferenceManager.token = result.signupData?.token;
          Get.offAllNamed(AppRoutes.routeSetupBasicInfoScreen);



        }else{
          AppAlerts.error(message: result.message);
        }

      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }


    } finally {
      isLoading.value = false;
    }
  }
}
