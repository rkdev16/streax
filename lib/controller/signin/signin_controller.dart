import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import '../../route/app_routes.dart';

class SignInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isSelected = true.obs;
  RxBool isLoading = false.obs;


  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  var selectedCountry = Rx<Country>(Country.parse('US'));


  AuthType authType = AuthType.phone;

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();

  }


  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }

  initTextEditingControllers() {
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  disposeTextEditingControllers() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }


  login() async{
    if(formKey.currentState!.validate()){
      try{

      Map<String,dynamic> requestBody = {};
      if(authType == AuthType.email){
        requestBody.addAll({
          "email": emailController.text.toString().trim(),
          "password":passwordController.text.toString().trim(),
          "loginType": loginTypeValues.reverse[LoginType.manual]
        });
      }else if(authType == AuthType.phone){
        requestBody.addAll({
          "countryCode": "+${selectedCountry.value.phoneCode}",
          "mobile": phoneController.text.toString().trim(),
          "password": passwordController.text.toString().trim(),
          "loginType": loginTypeValues.reverse[LoginType.manual]
        });
      }
      CommonLoader.show();
      var result = await PostRequests.login(requestBody);
      CommonLoader.dismiss();
      if(result !=null){
        if(result.success){
          PreferenceManager.user = result.user;
          PreferenceManager.token= result.user?.token;

          if(PreferenceManager.user?.userName ==null){
            Get.offAllNamed(AppRoutes.routeSetupBasicInfoScreen);
          }else{
            Get.offAllNamed(AppRoutes.routeDashBoardScreen);
          }


        }else{
          AppAlerts.error(message: result.message);
        }

      }else{
        AppAlerts.error(message: "message_server_error".tr);
      }


    }finally{
      CommonLoader.dismiss();
    }

  }

  }









}
