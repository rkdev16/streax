import 'package:get/get.dart';

import '../controller/profile_setup/profile_setup_controller.dart';
class ProfileSetupBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileSetupController());
  }

}

