

import 'package:get/get.dart';
import 'package:streax/controller/profile/edit_profile_controller.dart';

class EditProfileBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => EditProfileController());
  }
}
