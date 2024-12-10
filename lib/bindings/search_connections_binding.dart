import 'package:get/get.dart';
import 'package:streax/controller/connections/search_connections_controller.dart';

class SearchConnectionsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SearchConnectionsController());
  }

}