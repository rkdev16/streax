
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/preference_manager.dart';

class UpdateMobileController extends GetxController{

  late TextEditingController phoneController;
  var selectedCountry = Rx<Country>(Country.parse('US'));
  RxBool isUserExist = false.obs;

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
    getPrefData();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }


  getPrefData(){
    User? user = PreferenceManager.user;
    if(user !=null){
     // var  = selectedCountry.value = Coun
    }

  }



  initTextEditingControllers(){
    phoneController = TextEditingController();
  }

  disposeTextEditingControllers(){
    phoneController.dispose();
  }

  selectCountry(Country country){
    selectedCountry.value = country;
  }
}
