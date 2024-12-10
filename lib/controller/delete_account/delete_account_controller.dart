import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/network/delete_requests.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';


const int timerCount = 60;
class DeleteAccountController extends GetxController {




  final RxBool isLoading = false.obs;
  final TextEditingController otpFieldController = TextEditingController();
  RxBool enableVerifyBtn = false.obs;
  Timer? _timer;
  final RxInt start = timerCount.obs;

  @override
  void onInit() {
    super.onInit();
    initTimer();
    sendOtp();
  }


  @override
  void onClose() {
    cancelTimer();
    super.onClose();
  }

  initTimer() {
    cancelTimer();
    start.value = timerCount;
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



  showDeleteAccountDialog(){
    CommonAlertDialog.showDialog(
        title: 'deleting_account'.tr,
        message: 'message_deleting_account'.tr,
        negativeText: 'delete'.tr,

        positiveText: 'dismiss'.tr,
        negativeBtCallback: (){
          Get.back();
          deleteAccount();
        },
        positiveBtCallback: (){
          Get.back();
        });

  }




  sendOtp() async{
    try{
      initTimer();
     var result =  await GetRequests.sendOtpDeleteAccount();
     if(result !=null){
       if(result.success){
       }else{
         AppAlerts.error(message: result.message);
       }

     }else{
       AppAlerts.error(message: "message_server_error".tr);
     }



    } on Exception catch(e){
      debugPrint("Exception $e");
      cancelTimer();
    }

  }

  deleteAccount() async{
    var otp = otpFieldController.text.toString().trim();
    if(otp.isEmpty || otp.length <4){
      return;
    }

    try{

      isLoading.value =true;
      Map<String,dynamic> requestBody = {
        "otp": otp
      };

      var result = await DeleteRequests.deleteAccount(requestBody);
      if(result !=null){
        if(result.success){
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            PreferenceManager.user= null;
            PreferenceManager.token = null;
            Get.offAllNamed(AppRoutes.routeSignInScreen);
          });

        }else{
          AppAlerts.error(message: result.message);
        }
      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    }
    finally{
     isLoading.value =false;
    }

  }
}