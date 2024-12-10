import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';

class ForgotPasswordController extends GetxController{
  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  Rx<AuthType> authType = Rx<AuthType>(AuthType.phone);
  var selectedCountry = Rx<Country>(Country.parse('US'));



  late TextEditingController emailController;
  late TextEditingController phoneController;
  @override
  void onInit(){
    super.onInit();
    initTextEditingControllers();
    getArguments();
  }


  @override
  void onClose() {
    disposeTextEditingController();
    super.onClose();

  }

  getArguments(){
    Map<String,dynamic>? data= Get.arguments;
    if(data !=null){
      authType.value = data['auth_type']??AuthType.phone;
    }
  }

  initTextEditingControllers() {
    emailController = TextEditingController();
    phoneController = TextEditingController();

  }

  disposeTextEditingController(){
    emailController.dispose();
    phoneController.dispose();
  }



  forgotPassword() async{
    FocusManager.instance.primaryFocus?.unfocus();
    if(formKey.currentState!.validate()){
      try{



        isLoading.value = true;
        Map<String,dynamic> requestBody = {};
        if(authType.value == AuthType.phone){
          requestBody.addAll({
            "mobile":phoneController.text.toString().trim(),
            "countryCode":"+${selectedCountry.value.phoneCode}"
          });
        }else if(authType.value == AuthType.email){
          requestBody.addAll({
            "email": emailController.text.toString().trim()
          });
        }

        var result = await PostRequests.forgotPassword(requestBody);

        if(result !=null){
          if(result.success){
            Get.toNamed(AppRoutes.routeOtpVerificationScreen,arguments: {
              AppConsts.keyOtpVerificationFor: OtpVerificationFor.forgotPassword,
                AppConsts.keyOtpData: json.encode(result.otpData?.toJson()),
              AppConsts.keyAuthType: authType.value,
            });

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