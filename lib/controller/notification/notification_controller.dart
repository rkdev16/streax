import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/model/notifications_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';

class NotificationController extends GetxController {
  final isLoading = false.obs;
  RxBool mutualMatchNotification = false.obs;
  RxBool likedMeNotification = false.obs;
  RxBool chatNotification = false.obs;
  RxBool storyNotification = false.obs;
  final notifications = <AppNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    getArguments();
    fetchNotifications();
    readNotifications();
  }

  getArguments() {
    User? user = PreferenceManager.user;
    if (user != null) {
      mutualMatchNotification.value = user.mutualMatchNotification??false;
      likedMeNotification.value = user.likedMeNotification??false;
      chatNotification.value = user.chatNotification??false;
      storyNotification.value = user.storyNotification??false;

      debugPrint("mutual = ${mutualMatchNotification.value}");
      debugPrint("likedMe = ${likedMeNotification.value}");
      debugPrint("chat = ${chatNotification.value}");
      debugPrint("story = ${storyNotification.value}");
    }
  }

  void updateMutualMatchNotification() {
    mutualMatchNotification.value = !mutualMatchNotification.value;
    Map<String, dynamic> requestBody = {
      'mutualMatchNotification': mutualMatchNotification.value
    };
    updateUserProfile(requestBody);
  }

  void updateLikedMeNotification() {
    likedMeNotification.value = !likedMeNotification.value;
    Map<String, dynamic> requestBody = {
      'likedMeNotification': likedMeNotification.value
    };
    updateUserProfile(requestBody);
  }



  void updateChatNotification() {
    chatNotification.value = !chatNotification.value;
    Map<String, dynamic> requestBody = {
      'chatNotification': chatNotification.value
    };
    updateUserProfile(requestBody);
  }

  void updateStoryNotification() {
    storyNotification.value = !storyNotification.value;
    Map<String, dynamic> requestBody = {
      'storyNotification': storyNotification.value
    };
    updateUserProfile(requestBody);
  }

  updateUserProfile(Map<String, dynamic> requestBody) async {
    try {
      var result = await PutRequests.updateProfile(requestBody);
      if (result != null) {
        if (result.success) {

          PreferenceManager.user = result.user;

        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }


  fetchNotifications() async{
    try{
      isLoading.value = true;
      final result = await GetRequests.fetchNotifications();
      if(result !=null){
        if(result.success){
          notifications.assignAll(result.notifications??[]);
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

  readNotifications() async{
    var result = await PutRequests.notificationReadAll();
    debugPrint(result.toString());
    Get.find<DashBoardController>().notificationCount.value.notificationCount = 0;
    Get.find<DashBoardController>().notificationCount.refresh();
    Get.find<DashBoardController>().refresh();
  }
}
