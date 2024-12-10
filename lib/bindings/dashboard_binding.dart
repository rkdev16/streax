import 'package:get/get.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/location/location_controller.dart';
import 'package:streax/controller/notification/notification_controller.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/controller/settings/settings_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import '../controller/chat/chat_controller.dart';
import '../controller/dashboard/dashboard_controller.dart';
import '../controller/home/home_controller.dart';

class DashBoardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashBoardController(),fenix: true);
    Get.lazyPut(() => ConnectionsController(),fenix: true);
    Get.lazyPut(() => StoriesController(),fenix: true);
    Get.lazyPut(() => SettingsController(),fenix: true);
    Get.lazyPut(() => NotificationController(),fenix: true);
    Get.lazyPut(() => ProfileController(),fenix: true);
    Get.lazyPut(() => HomeController(),fenix: true);
    Get.lazyPut(() => ChatController(),fenix: true);
    Get.lazyPut(() => LocationController(),fenix: true);
  }


}