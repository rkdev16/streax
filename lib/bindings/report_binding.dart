import 'package:get/get.dart';
import 'package:streax/controller/report/report_controller.dart';

class ReportBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ReportController());
  }

}