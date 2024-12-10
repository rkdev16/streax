import 'package:get/get.dart';
import '../controller/notification/notification_controller.dart';

class NotificationBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
    // TODO: implement dependencies
  }

}