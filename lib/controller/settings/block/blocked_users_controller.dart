
import 'package:get/get.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/utils/app_alerts.dart';

class BlockedUsersController extends GetxController{

  RxBool isLoading = true.obs;



  var blockedUsers=  <User>[].obs;



  @override
  void onReady() {
    super.onReady();
    getBlockedUsers();
  }


  getBlockedUsers() async{
    try{
      isLoading.value = true;
      var result = await GetRequests.fetchBlockedUsers();
      if(result!=null){
        if(result.success){
          blockedUsers.assignAll(result.users??[]);
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