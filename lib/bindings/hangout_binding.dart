
import 'package:get/get.dart';
import 'package:streax/controller/hangout/hangout_controller.dart';

class HangoutBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HangoutController());
  }

}