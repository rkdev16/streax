import 'package:get/get.dart';
import 'package:streax/controller/profile/public_profile_controller.dart';

class PublicProfileBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => PublicProfileController());
  }

}