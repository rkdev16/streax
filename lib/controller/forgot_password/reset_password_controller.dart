import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/request_otp_res_model.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';

import '../../consts/app_consts.dart';

class ResetPasswordController extends GetxController {

  final formKey = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  RxBool isLoading = false.obs;
  AuthType? authType;
  OtpData? otpData;


  @override
  void onInit() {
    super.onInit();

    initTextEditingControllers();
    getArguments();

  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }







  initTextEditingControllers() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  disposeTextEditingControllers(){
    passwordController.dispose();
    confirmPasswordController.dispose();
  }



  void getArguments() {
    Map<String, dynamic> data = Get.arguments;
    otpData = OtpData.fromJson(json.decode(data[AppConsts.keyOtpData]));
    authType = data[AppConsts.keyAuthType];

  }
  resetPassword() async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()){
      try{
        isLoading.value = true;
        Map<String,dynamic> requestBody = {};
        if(authType == AuthType.phone){
          requestBody.addAll({
            "mobile":otpData?.mobile??"",
          "countryCode":otpData?.countryCode??'',
          "newPassword":passwordController.text.toString().trim(),
          "otp":otpData?.otp??''
          });
        }else if(authType == AuthType.email){
          requestBody.addAll({
            "email": otpData?.email??"",
            "newPassword":passwordController.text.toString().trim(),
            "otp":otpData?.otp??''
          });
        }
        var result =  await PostRequests.resetPassword(requestBody);
        if(result !=null){
         if(result.success){
           Get.offNamed(AppRoutes.routePasswordChangedScreen);
         }else{
          AppAlerts.error(message: result.message);
         }

       }else{
         AppAlerts.error(message: 'message_server_error'.tr);
       }


      }finally{
        isLoading.value = false;
      }

    }

  }
}
