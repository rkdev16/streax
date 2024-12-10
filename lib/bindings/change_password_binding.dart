import 'package:get/get.dart';
import 'package:streax/controller/change_password/change_password_controller.dart';

class ChangePasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordController());
    // TODO: implement dependencies
  }

}