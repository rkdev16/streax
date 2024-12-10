import 'package:get/get.dart';
import 'package:streax/controller/delete_account/delete_account_controller.dart';

class DeleteAccountBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DeleteAccountController());
    // TODO: implement dependencies
  }

}