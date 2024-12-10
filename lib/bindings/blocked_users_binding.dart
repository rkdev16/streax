import 'package:get/get.dart';
import 'package:streax/controller/settings/block/blocked_users_controller.dart';

class BlockedUsersBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => BlockedUsersController());
  }
}
