import 'dart:async';

import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/location/location_controller.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/pages/home/components/profile_widget.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  // var profileSuggestions = <User>[].obs;
  var profileSuggestions = <ProfileWidget>[].obs;
  var centerStage = <ProfileWidget>[].obs;

  // Map<int, CachedVideoPlayerController> videoControllers = {};
  int focusedIndex = 0;
  RxBool isLoadingLike = false.obs;

  final RxInt timerCount = 1800.obs;

  RxBool isHavingPermission = false.obs;

  @override
  void onReady() {
    super.onReady();
    checkLocationPermission();
    getProfileSuggestions();
  }

  // toggleVideoPlayPause(){
  //   VideoPlayerController? controller = videoControllers[focusedIndex];
  //   if(controller!=null){
  //
  //     if(Get.find<DashBoardController>().dashboardSelectedTab.value ==2){
  //      // controller.play();
  //     }else{
  //     //  controller.pause();
  //     }
  //   }
  // }

  checkLocationPermission() async {
      isHavingPermission.value =
      await Get.find<LocationController>().isHavingLocationPermission();
      if (!isHavingPermission.value) {
        Get.toNamed(AppRoutes.routeRequestLocationPermissionScreen);
      } else {
        Get.find<LocationController>().getCurrentLocation();
    }
  }


  audioMuted(value){
    for (var element in profileSuggestions) {
      element.user.videoMuted = value;
    }}

  onPageChanged(int index) {
    debugPrint("FocusedIndex = $focusedIndex   index = $index");
    if (index > focusedIndex) {
      _playNext(index);
    } else {
      _playPrevious(index);
    }
    focusedIndex = index;
  }

  Future initializeProfileWidget() async {
    /// Initialize 1st video
    try {
      await _initializeControllerAtIndex(0);
      playControllerAtIndex(0);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    /// Play 1st video

    /// Initialize 2nd video
    await _initializeControllerAtIndex(1);
  }

  void _playNext(int index) {
    /// Stop [index - 1] controller
    stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  _playPrevious(int index) {
    /// Stop [index + 1] controller
    stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    debugPrint("_initializeControllerAtIndex  =$index");
    if (profileSuggestions.length > index && index >= 0) {
      var videoUrl = profileSuggestions[index].user.introVideo;
      debugPrint("VideoUrl index = $index  = $videoUrl");

      try {
        // if (videoUrl == null || videoUrl.toString().isEmail) return;
        if (videoUrl == null || videoUrl.isEmpty) return;

        final CachedVideoPlayerController controller =
            CachedVideoPlayerController.network(
                Helpers.getCompleteUrl(videoUrl));
        controller.setLooping(true);
        controller.setVolume(0.0);
        profileSuggestions[index].videoPlayerController = controller;
        await controller.initialize();
      } on Exception catch (e) {
        debugPrint("Exception while video loading = $e");
      }
    }
  }

  playControllerAtIndex(int index) {
    if (profileSuggestions.length > index && index >= 0) {
      CachedVideoPlayerController? controller =
          profileSuggestions[index].videoPlayerController;
      if (controller != null) {
        controller.play();
      }
    }
  }

  stopControllerAtIndex(int index) {
    if (profileSuggestions.length > index && index >= 0) {
      CachedVideoPlayerController? controller =
          profileSuggestions[index].videoPlayerController;
      if (controller != null) {
        controller.pause();
        // Reset position to beginning
        controller.seekTo(const Duration());
      }
    }
  }

  Future disposeControllerAtIndex(int index) async {
    if (profileSuggestions.length > index && index >= 0) {
      debugPrint("Dispose at index = $index");
      CachedVideoPlayerController? controller =
          profileSuggestions[index].videoPlayerController;
      if (controller != null) {
        controller.dispose();
        profileSuggestions[index].videoPlayerController = null;
      }
    }
  }

  getProfileSuggestions() async {
    try {
      isLoading.value = true;
      var result = await GetRequests.fetchProfileSuggestions();
      if (result != null) {
        if (result.success) {
          profileSuggestions.clear();
          centerStage.clear();
          result.users?.forEach((user) {
            // CachedVideoPlayerController? controller;
            // if(user.introVideo== null && user.introVideo!.isEmpty){
            //   controller= CachedVideoPlayerController.network(Helpers.getCompleteUrl(user.introVideo))
            // }
            if (user.centerStage == 1) {
              centerStage.add(ProfileWidget(user: user));
            }else{
              profileSuggestions.add(ProfileWidget(
                user: user,
              ));
            }
          });

          debugPrint("Focused Index=  $focusedIndex");
          if (focusedIndex == 0 && profileSuggestions.isNotEmpty) {
            initializeProfileWidget();
          }
          if (centerStage.isNotEmpty) {
            var totalCount = profileSuggestions.length;
            int count = 1;
            for (var index = 5; index <= totalCount; null) {
              if(count<=4){
                debugPrint("profileSuggestions ======>  $index");
                debugPrint("index =>  $count");
                if (index == totalCount) {
                  profileSuggestions.addAll(centerStage);
                } else if (index < totalCount) {
                  profileSuggestions.insertAll(index-1, centerStage);
                }
                index = index + 5 * (count+1);
                count++;
              }else{
                break;
              }
            }
          }
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

  checkForMatchRemove(String userId) {
    ProfileWidget? profileWidget = profileSuggestions
        .firstWhereOrNull((profileWidget) => profileWidget.user.id == userId);
    if (profileWidget != null) {
      profileSuggestions.remove(profileWidget);
      if (profileWidget.user.iLiked == 1 && profileWidget.user.likedMe == 1) {
        Get.toNamed(AppRoutes.routeNewMatchScreen,
            arguments: {AppConsts.keyUser: profileWidget.user});
      }
    }
    isLoadingLike.value = false;
  }

}
