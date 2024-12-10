import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/model/notification_count_res_model.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/utils/socket_helper.dart';
import 'package:streax/views/pages/chat/recent_chat_dialogs_screen.dart';
import 'package:streax/views/pages/connections/connections_screen.dart';
import 'package:streax/views/pages/home/home_screen.dart';
import 'package:streax/views/pages/profile/profile_screen.dart';

const double iconSize = 26.0;
const colorNormal = ColorFilter.mode(AppColors.colorC2, BlendMode.srcIn);
const colorActive = ColorFilter.mode(AppColors.kPrimaryColor, BlendMode.srcIn);

class DashBoardController extends GetxController {
  RxInt currentTabIndex = 0.obs;
  IO.Socket? _socket;

  Rx<NotificationCount> notificationCount = NotificationCount().obs;
  Rx<MessageCount> messageCount = MessageCount().obs;

  var pages = [
    //  SettingsScreen(),

    const HomeScreen(),
    const RecentChatDialogsScreen(),
    const SizedBox.shrink(),
    ConnectionsScreen(),
    ProfileScreen(),
  ];

  void changeBottomNavBarItem(int index) {
    if (index == 0) {
      currentTabIndex.value = index;
    }
    else if (index == 2) {
      Get.find<HomeController>().stopControllerAtIndex(Get.find<HomeController>().focusedIndex);
      var storyController = Get.find<StoriesController>();
      if (!storyController.isLoadingPostStory.value) {
        storyController.pickMediaForPost();
      }
    } else {
      Get.find<HomeController>().stopControllerAtIndex(Get.find<HomeController>().focusedIndex);
      Get.find<HomeController>().disposeControllerAtIndex(Get.find<HomeController>().focusedIndex);
      currentTabIndex.value = index;
    }
    currentTabIndex.refresh();
  }

  Worker? tabChangeWorker;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      currentTabIndex.value = Get.arguments['selectedTab'];
      changeBottomNavBarItem(currentTabIndex.value);
    }
    _socket = SocketHelper.getInstance();
    initWorkers();
    updateFcmToken();
    fetchNotificationsCount();
    fetchChatCount();
    setupFcm();
  }

  @override
  void onClose() {
    disposeWorkers();
    super.onClose();
  }

  initWorkers() {
    tabChangeWorker =
        ever(currentTabIndex, (callback) => reloadDataOnTabChange());
  }

  disposeWorkers() {
    tabChangeWorker?.dispose();
  }

  reloadDataOnTabChange() {
    switch (currentTabIndex.value) {
      case 1:
        Get.find<ChatController>().getChatDialogs();
        break;
      default:
    }
  }

  void updateFcmToken() async {
    var messaging = FirebaseMessaging.instance;
    String? fcmToken = await messaging.getToken();
    debugPrint("FcmToken = $fcmToken");
    if (fcmToken != null) {
      PreferenceManager.fcmToken = fcmToken;
      try {
        Map<String, dynamic> requestBody = {'fcmToken': fcmToken};

        PutRequests.updateProfile(requestBody);
      } on Exception catch (e) {
        debugPrint("Error facing while updating Fcm token");
        debugPrint(e.toString());
      }
    }
  }

  fetchNotificationsCount() async {
    try {
      final result = await GetRequests.fetchNotificationsCount();
      if (result != null) {
        if (result.success!) {
          notificationCount.value = result.data!;
        } else {
          AppAlerts.error(message: result.message ?? '');
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {}
  }

  fetchChatCount() async {
    try {
      final result = await GetRequests.fetchChatCount();
      if (result != null) {
        if (result.success!) {
          messageCount.value = result.data!;
        } else {
          AppAlerts.error(message: result.message ?? '');
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {}
  }

  setupFcm() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        debugPrint("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          debugPrint("New Notification");

          //    Get.find<DashBoardController>().dashboardSelectedTab.value = 1;

          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
  }
}
