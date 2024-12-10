
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdateEmailController extends GetxController{

   late  TextEditingController emailController;
   RxBool isUserExist = false.obs;

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
  }


  @override
  void onClose() {
   disposeTextEditingControllers();
    super.onClose();
  }


  initTextEditingControllers(){
    emailController = TextEditingController();
  }
  disposeTextEditingControllers(){
    emailController.dispose();
  }

}
