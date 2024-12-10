
import 'package:get/get.dart';
import 'package:streax/controller/signin/signin_controller.dart';

class SignInBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());


  }

}