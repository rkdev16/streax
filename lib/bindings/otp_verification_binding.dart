import 'package:get/get.dart';
import 'package:streax/controller/otp_verification/otp_verification_controller.dart';

class OtpVerificationBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OtpVerificationController());
    // TODO: implement dependencies
  }

}