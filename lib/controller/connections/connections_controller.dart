
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';

class ConnectionsController extends GetxController{



  final RefreshController refreshController = RefreshController(initialRefresh: false);

  RxBool isLoading = false.obs;



  var mutual = <User>[].obs;
  var iLiked = <User>[].obs;
  var likedMe = <User>[].obs;


  @override
  void onInit() {
    super.onInit();
    getConnections();
  }

  void getConnections() async{
    try{
      if(mutual.isEmpty
      && iLiked.isEmpty
      && likedMe.isEmpty ){
        isLoading.value = true;
      }
      var result = await GetRequests.fetchConnections();
      if(result !=null){
        if(result.success){
          mutual.assignAll(result.connectionsData?.mutual??[]);
          iLiked.assignAll(result.connectionsData?.iLiked??[]);
          likedMe.assignAll(result.connectionsData?.likedMe??[]);
         refreshController.refreshCompleted();
        }else{
          AppAlerts.error(message: result.message);
        }
      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }

    }finally{
      isLoading.value =false;
    }
  }




  //superlike story basically like the user profile
  //1 for like 0 for unlike
  Future<int> superLike(String id) async{

    int likeStatus = 0;

    try{
      var result = await GetRequests.superLikeUser(id);
      if(result !=null){
        likeStatus = result.data?.superLike??0;
        getConnections();
        Get.find<ProfileController>().getUserProfile();
      }
    } on Exception catch(e){
      likeStatus = 0;
      debugPrint(e.toString());
    }

    return likeStatus;
  }


  // like story basically like the user profile
  // 1 for like 0 for unlike
  Future<int> toggleLike(String id) async {
    int likeStatus = 0;

    try {
      var result = await GetRequests.toggleLike(id);
      if (result != null) {
        likeStatus = result.data?.isLiked ?? 0;
        Get.find<StoriesController>().getConnectionsStories();
        getConnections();
      }
    } on Exception catch (e) {
      likeStatus = 0;
      debugPrint(e.toString());
    }

    return likeStatus;
  }




  // blockUser(User user) {
  //   CommonAlertDialog.showDialog(
  //       title: '${'block'.tr} ${user.userName}? ',
  //       message: 'message_block_user'.tr,
  //       negativeText: 'block',
  //       positiveText: 'dismiss'.tr,
  //       positiveBtCallback: () {
  //         Get.back();
  //       },
  //       negativeBtCallback: () {
  //         Get.back();
  //         _blockUnblock(userId: user.id??'',isBlock: true);
  //       });
  // }
  //
  // unblockUser(User user) {
  //   CommonAlertDialog.showDialog(
  //       title: '${'unblock'.tr} ${user.userName}? ',
  //       message: 'message_unblock_user'.tr,
  //       negativeText: 'unblock',
  //       positiveText: 'dismiss'.tr,
  //       positiveBtCallback: () {
  //         Get.back();
  //       },
  //       negativeBtCallback: () {
  //         Get.back();
  //         _blockUnblock(userId: user.id??'',isBlock: false);
  //       });
  // }

 Future<bool> toggleBlock({required String userId,required bool isBlocked}) async {
    bool blockedStatus = false;
    try {
      isLoading.value = true;
      Map<String, dynamic> requestBody = {
        "block": userId,
        "isBlock": isBlocked,
      };
      var result = await PostRequests.blockUnBlock(requestBody);
      if (result != null) {
        if (result.success) {
          blockedStatus = isBlocked;
          if(isBlocked){
            removedBlockedUser(userId);
          }else{

          }
        //  removedBlockedUser(userId);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }

    return blockedStatus;
  }

  removedBlockedUser(String userId) {
    Get.find<StoriesController>().connectionStories.removeWhere((element) => element.first.user.id == userId);
    mutual.removeWhere((element) => element.id == userId);
    iLiked.removeWhere((element) => element.id == userId);
    likedMe.removeWhere((element) => element.id == userId);
  }

}