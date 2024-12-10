import 'package:get/get.dart';

import '../controller/signup/signup_controller.dart';

class SignUpBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController());

  }

}