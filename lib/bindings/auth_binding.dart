import 'package:get/get.dart';
import 'package:streax/controller/auth_controller.dart';

class AuthBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
  }

}