
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/model/report/report_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';

class ReportController extends GetxController{

  User? user;

  var reportOptions= [
    ReportModel('I just don\'t want to see it', false),
    ReportModel('Bullying,harassment and defamation', false),
    ReportModel('Nudity & sexual content', false),
    ReportModel('Threat,violence & dangerour behaviour', false),
    ReportModel('Drug & weapons', false),
    ReportModel('Suicide & self-harm', false),
    ReportModel('False information or deceptive practices', false),
    ReportModel('Intellectual property', false),
    ReportModel('Other', false),
  ].obs;


late   TextEditingController commentTextController;


int selectedIndex = -1;
RxBool isLoading = false.obs;

RxString messageId = ''.obs;
RxString storyId = ''.obs;


  @override
  void onInit() {
    super.onInit();
    getArguments();
    commentTextController = TextEditingController();
  }


  @override
  void onClose() {
    commentTextController.dispose();
    super.onClose();
  }

  getArguments(){
 Map<String,dynamic>? data = Get.arguments ;
 if(data !=null){
   user = data[AppConsts.keyUser];
   messageId.value = data["message"] ?? '';
   storyId.value = data["story_id"] ?? '';
 }
  }


  selectOption(int index){
    selectedIndex = index;
    for (int i =0;i< reportOptions.length;i++) {
      reportOptions[i].isSelected = i ==index;
    }
    reportOptions.refresh();
  }


  validateData(){
    if(selectedIndex <0){
      AppAlerts.alert(message: 'message_select_report_option'.tr);
      return;
    }

    //it means user selected others option
    if(reportOptions.last.isSelected){
      var comment  = commentTextController.text.toString().trim();
      if(comment.isEmpty){
        AppAlerts.alert(message: 'message_add_your_comment');
        return;
      }

    }

    askForBlockUser();

  }


  askForBlockUser(){
    CommonAlertDialog.showDialog(
        title: '${'block'.tr} ${user?.userName}? ',
        message: 'message_block_user'.tr,
        negativeText: 'block',
        positiveText: 'report_only'.tr,
        positiveBtCallback: () {
          Get.back(result: true);
          reportUser();
        },
        negativeBtCallback: () async{
          Get.back();
          isLoading.value =true;
         await _blockUnblock(user?.id ?? "");
         reportUser();
        });
  }




 Future<void> _blockUnblock(String userId) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> requestBody = {
        "block": userId,
      };

      var result = await PostRequests.blockUnBlock(requestBody);
      if (result != null) {
        if (result.success) {
          Get.find<StoriesController>().getConnectionsStories();
          Get.find<ConnectionsController>().getConnections();
          Get.find<ChatController>().getChatDialogs();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }


  reportUser() async{

    try{
      isLoading.value = true;
      Map<String,dynamic> requestBody = {
        "message" : messageId.value,
        "storyId" : storyId.value,
        "report": user?.id,
        "title":reportOptions[selectedIndex].title,
        "comment":commentTextController.text.toString().trim()
      };
      var result =  await PostRequests.reportUser(requestBody);
      if(result !=null){
        if(result.success){
          AppAlerts.success(message: result.message);
          Future.delayed(Duration(seconds: 1),(){
            Get.back(result : true);
          });
        }else{
          AppAlerts.error(message: result.message);
        }
      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }

    }finally{
      Future.delayed(Duration(seconds: 1),(){
        isLoading.value = false;
      });
    }
  }


}
