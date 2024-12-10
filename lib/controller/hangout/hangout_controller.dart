
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/model/place_detail_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/utils/app_alerts.dart';

class HangoutController extends GetxController{

  final formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  late TextEditingController placeController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController commentController;


  PlaceDetail? placeDetail;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;


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
    placeController = TextEditingController();
    locationController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    commentController = TextEditingController();
  }

  disposeTextEditingControllers(){
    placeController.dispose();
    locationController.dispose();
    dateController.dispose();
    timeController.dispose();
    commentController.dispose();

  }

  clearData(){
    placeController.clear();
    locationController.clear();
    dateController.clear();
    timeController.clear();
    commentController.clear();
    placeDetail = null;
    selectedDate = null;
    selectedTime = null;
  }



  selectPlace(PlaceDetail placeDetail){
    locationController.text = placeDetail.result?.formattedAddress??"";
    this.placeDetail = placeDetail;
  }

  pickDate(BuildContext context) async{
    DateTime currentDate = DateTime.now();
 DateTime? pickedDate =  await  showDatePicker(context: context,
        firstDate: currentDate,
        initialDate: currentDate,
        lastDate: currentDate.add(const Duration(days: 365)));

 if(pickedDate !=null){
   dateController.text = DateFormat("dd,MMM,yyyy").format(pickedDate);
   selectedDate = pickedDate;
 }
  }

  pickTime(BuildContext context) async{
    DateTime? currentTime = DateTime.now();
    TimeOfDay? pickedTime =  await  showTimePicker(context: context,
        initialTime: TimeOfDay(hour: currentTime.hour, minute: currentTime.minute));


    if(pickedTime !=null){
      timeController.text = pickedTime.format(context);
      selectedTime = pickedTime;
    }
  }

 Future<String?> sendHangoutRequest(User? user) async{

    debugPrint("User = ${user?.id}");

    if(formKey.currentState!.validate()){
      String? hangoutRequestId;
      try{
        isLoading.value =true;

        DateTime dateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute
        );


        Map<String,dynamic> requestBody = {
          "place": placeController.text.toString().trim(),
          "location": locationController.text.toString().trim(),
          "latitude": placeDetail?.result?.geometry?.location?.lat,
          "longitude": placeDetail?.result?.geometry?.location?.lng,
          "comment": commentController.text.toString().trim(),
          "date": dateTime.toIso8601String()};
        var result = await PostRequests.sendHangoutRequest(user?.id??"",
            requestBody);
        Get.find<HomeController>().checkForMatchRemove(user?.id ?? '');

        if(result!=null){
          if(result.success){
            hangoutRequestId = result.hangoutRequest?.id;
          }else{
            AppAlerts.error(message: result.message);
          }
        }else{
          AppAlerts.error(message: 'message_server_error'.tr);
        }

      }finally{
        isLoading.value =false;
      }
      return hangoutRequestId;
    }
    return null;


  }
}
