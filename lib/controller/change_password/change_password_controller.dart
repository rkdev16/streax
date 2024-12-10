import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';

class ChangePasswordController extends GetxController{

  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  late TextEditingController oldPasswordController ;
  late TextEditingController newPasswordController ;
  late TextEditingController confirmPasswordController ;
  @override
  void onInit(){
    super.onInit();
    initTextEditingControllers();
  }


  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }

  void initTextEditingControllers() {
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  disposeTextEditingControllers(){
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }


  validateFormAndUpdatePassword() async{


    if(formKey.currentState!.validate()){

      try{
        isLoading.value =true;
        Map<String,dynamic> requestBody = {
          "oldPassword": oldPasswordController.text.toString().trim(),
          "newPassword": newPasswordController.text.toString().trim()
        };

        var result = await PostRequests.changePassword(requestBody);
        if(result !=null){
          if(result.success){
            showChangePasswordSuccessDialog();
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


  showChangePasswordSuccessDialog(){
    CommonAlertDialog.showDialog(
      onPop: (){
        // Get.offAllNamed(AppRoutes.routeSignInScreen);
      },
      title: 'password_changed_successfully'.tr,
        message: 'message_password_changed_successfully'.tr,
        positiveText: 'login'.tr,
        positiveBtCallback: (){
          Get.back();
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.offAllNamed(AppRoutes.routeSignInScreen);
        });

    });
  }

}