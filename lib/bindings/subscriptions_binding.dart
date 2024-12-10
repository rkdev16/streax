import 'package:get/get.dart';
import 'package:streax/controller/premium/subscription_controller.dart';

class SubscriptionsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SubscriptionsController());
    // TODO: implement dependencies
  }

}