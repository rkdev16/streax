
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/utils/app_alerts.dart';

class PublicProfileController extends GetxController{

  Rx<User?> user = Rx<User?>(null);


  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getArguments();
    getPublicProfile();
  }


  getArguments(){
    user.value = Get.arguments[AppConsts.keyUser];

  }




  getPublicProfile() async{
    try{
      isLoading.value = true;
      var result = await GetRequests.fetchPublicProfile(user.value?.id??"");
      if(result !=null){
        if(result.success){
          user.value = result.user;
        }else{
          AppAlerts.error(message: result.message);
        }

      }else{
        AppAlerts.error(message: "message_server_error".tr);
      }
    }finally{
      isLoading.value = false;
    }
  }

}