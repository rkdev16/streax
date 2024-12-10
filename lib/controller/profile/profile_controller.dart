import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import '../../utils/preference_manager.dart';

class ProfileController extends GetxController {
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;


  @override
  void onReady() {
    super.onReady();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;
      var result = await GetRequests.fetchUserProfile();
      if (result != null) {
        if (result.success) {
          PreferenceManager.user = result.user;
          user.value = result.user;
          debugPrint('====> ${user.value?.fcmToken}');
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
