import 'package:get/get.dart';
import 'package:streax/controller/profile/profile_controller.dart';

class MyProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());

    // TODO: implement dependencies
  }

}