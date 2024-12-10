import 'package:get/get.dart';
import 'package:streax/controller/forgot_password/reset_password_controller.dart';

import '../controller/forgot_password/forgot_password_controller.dart';



class ForgotPasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController());
    Get.lazyPut(() => ResetPasswordController());
  }

}