
import 'package:get/get.dart';
import 'package:streax/controller/settings/update_mobile_controller.dart';

class UpdateMobileBinding implements Bindings{
  @override
  void dependencies() {
  Get.lazyPut(() => UpdateMobileController());
  }

}