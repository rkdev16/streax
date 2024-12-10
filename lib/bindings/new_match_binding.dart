import 'package:get/get.dart';
import 'package:streax/controller/new_match/new_match_controller.dart';

class NewMatchBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut(() => NewMatchController());
  }

}