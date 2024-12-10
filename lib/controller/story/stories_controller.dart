
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/story/story.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/delete_requests.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/custom_gallery/custom_media_picker.dart';
import 'package:streax/utils/custom_gallery/media_preview.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';
import 'package:streax/views/pages/story/components/custom_story_item.dart';
import 'package:streax/views/pages/story/components/story_view/story_controller.dart';

class StoriesController extends GetxController {
  RxBool isLoadingPostStory = false.obs;
  RxBool isLoading = false.obs;
  final storyController = StoryController(); //storyViewController
  final pageController = PageController(initialPage: 0);
  int currentStoryPageIndex = 0;
  int storyPagesLength = 1;

  var myStories = <List<CustomStoryItem>>[].obs;
  var connectionStories = <List<CustomStoryItem>>[].obs;

  Rx<CustomStoryItem?> currentShowingStory = Rx<CustomStoryItem?>(null);

  Worker? viewStoryWorker;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMyStories();
      getConnectionsStories();
      initWorkers();
    });
  }

  @override
  void onClose() {
    disposeWorkers();
    super.onClose();
  }

  initWorkers() {
    viewStoryWorker = ever(currentShowingStory, (callback) => viewStory());
  }

  disposeWorkers() {
    viewStoryWorker?.dispose();
  }

  moveToNextPage(BuildContext context, bool isMyStory) {
    debugPrint("CurrentStoryPageIndex=$currentStoryPageIndex");
    currentStoryPageIndex += 1;

    if (currentStoryPageIndex < storyPagesLength) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 600), curve: Curves.easeIn);
    } else {
      Navigator.of(context).pop();
    }
  }

  getMyStories() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoadingPostStory.value = false;
      });
      var result = await GetRequests.fetchMyStories();
      if (result != null) {
        if (result.success) {
          myStories.assignAll(setupMyStoryData(result.stories ?? []));
          update();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server.error'.tr);
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoadingPostStory.value = false;
      });
    }
  }

  getConnectionsStories() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoadingPostStory.value = false;
      });
      var result = await GetRequests.fetchConnectionsStories();
      if (result != null) {
        if (result.success) {
          if (result.stories != null) {
            // var adminStoryIndex = result.stories!
            //     .indexWhere((element) => element.role == "ADMIN");
            // if (adminStoryIndex != -1) {
            //   var adminStory = result.stories![adminStoryIndex];
            //   result.stories!.removeAt(adminStoryIndex);
            //   result.stories!.insert(0, adminStory);
            // }
            connectionStories.assignAll(setupStoryData(result.stories ?? []));
          }
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server.error'.tr);
      }
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isLoadingPostStory.value = false;
      });
    }
  }

  Future<String?> uploadFile(List<String> paths) async {
    var result = await PostRequests.uploadFiles(paths: paths);
    if (result != null) {
      if (result.success) {
        return result.data?.first.name;
      } else {
        AppAlerts.error(message: result.message);
      }
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
    }
    return null;
  }

  pickMediaForPost() {
    CustomMediaPicker.pickMedia((media) => MediaPreview.preview(
        media: media,
        onDone: (MediaData media) async {
          var storyData = await Get.toNamed(AppRoutes.routeShareStoryScreen);
          postStory(
            media.mediaType,
            media.mediaPath!,
            media.mediaDuration,
            storyData['sharedUserIds'] ?? [],
            storyData['addStory'],
            uploadVideo: media.uploadVideoPath,
          );
        },
        onRetake: () {
          pickMediaForPost();
        }));
  }

  postStory(MediaType mediaType, String mediaPath, int? mediaDuration,
      List<String?> shareUserIds, myStory,
      {String? uploadVideo}) async {
    try {
      isLoadingPostStory.value = true;
      String? mediaUrl = await uploadFile([mediaPath]);
      String? thumbnailUrl;
      if (mediaType == MediaType.video) {
        String? thumbnailPath =
            await Helpers.createVideoThumbnail(uploadVideo!);
        if (thumbnailPath != null) {
          thumbnailUrl = await uploadFile([thumbnailPath]);
        }
      } else {
        thumbnailUrl = mediaUrl;
      }
      debugPrint('FileUrl = $mediaUrl');
      Map<String, dynamic> requestBody = {
        'users': shareUserIds,
        'myStory': myStory,
        "mediaType": mediaTypeValues.reverse[mediaType], //"image","video"
        "mediaDuration": mediaDuration ?? 5, //"image","video"
        "mediaUrl": mediaUrl,
        "thumbnail": thumbnailUrl, //"image","video"
      };
      var result = await PostRequests.postStory(requestBody);
      if (result != null) {
        if (result.success) {
          getMyStories();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }

      await Future.delayed(const Duration(seconds: 4));
      await Future.delayed(const Duration(seconds: 4));
    } finally {
      isLoadingPostStory.value = false;
    }
  }

  List<List<CustomStoryItem>> setupMyStoryData(List<Story> storiesData) {
    List<List<CustomStoryItem>> outList = [];
    debugPrint("StoriesData = ${storiesData.length}");

    List<CustomStoryItem> stories = [];

    for (var element in storiesData) {
      int duration = element.mediaDuration ?? AppConsts.defaultMediaDuration;
      duration = duration < AppConsts.defaultMediaDuration
          ? AppConsts.defaultMediaDuration
          : duration;
      stories.add(CustomStoryItem.content(
          user: PreferenceManager.user!,
          story: element,
          controller: storyController,
          duration: Duration(seconds: duration)));
      debugPrint("Stories = ${element.mediaUrl}");
    }

    debugPrint("Stories = ${stories.length}");
    if (stories.isNotEmpty) {
      outList.add(stories);
    }
    return outList;
  }

  List<List<CustomStoryItem>> setupStoryData(List<User> users) {
    List<List<CustomStoryItem>> outList = [];
    for (int i = 0; i < users.length; i++) {
      if ((users[i].stories ?? []).isEmpty) continue;
      List<CustomStoryItem> stories = [];
      for (int j = 0; j < (users[i].stories?.length ?? 0); j++) {
        Story? element = users[i].stories![j];
        //todo if duration is less then 5(default duration) then duration should be 5(default duration)
        int duration = element.mediaDuration ?? AppConsts.defaultMediaDuration;
        duration = duration < AppConsts.defaultMediaDuration
            ? AppConsts.defaultMediaDuration
            : duration;

        stories.add(CustomStoryItem.content(
            user: users[i],
            story: element,
            controller: storyController,
            duration: Duration(seconds: duration)));
      }
      debugPrint("Stories = ${stories.length}");
      if (stories.isNotEmpty) {
        outList.add(stories);
      }
    }
    return outList;
  }

  // setupConnectionsStoriesData(List<User> users ){
  //   for(int i =0;i<users.length ; i++){
  //     List<CustomStoryItem> stories = [];
  //     for (int j = 0;j <(users[i].stories?.length??0);j++) {
  //       Story? element = users[i].stories![j];
  //       stories.add(CustomStoryItem.content(
  //           user: users[i],
  //           story: element,
  //           controller: storyController,
  //           duration: Duration(seconds:  element.mediaDuration??AppConsts.defaultMediaDuration)
  //       ));
  //     }
  //     debugPrint("Stories = ${stories.length}");
  //
  //     connectionStories.add(stories);
  //
  //
  //
  //   }
  //   debugPrint("ConnectionStoriesLength = ${connectionStories.length}");
  // }

  showDeleteStoryAlert() {
    storyController.pause();
    CommonAlertDialog.showDialog(
      onPop: () {
        storyController.play();
      },
      barrierDismissible: false,
      title: 'delete_this_story'.tr,
      message: 'message_sure_delete_post'.tr,
      positiveText: 'dismiss'.tr,
      negativeText: 'delete'.tr,
      positiveBtCallback: () {
        Get.back();
        storyController.play();
      },
      negativeBtCallback: () {
        deleteStory(currentShowingStory.value?.story.id ?? '');
        Get.back();
      },
    );
  }

  deleteStory(String storyId) async {
    debugPrint("deletedStoryId= $storyId");
    try {
      isLoading.value = true;
      var result = await DeleteRequests.deleteStory(storyId);
      if (result != null) {
        if (result.success) {
          if (myStories.isNotEmpty) {
            var stories = myStories.first;
            if (stories.length == 1) {
              myStories.clear();
              Get.back();
            }
            stories.removeWhere((element) => element.story.id == storyId);
          }
          getMyStories();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      storyController.play();
      isLoading.value = false;
    }
  }

  viewStory() async {
    try {
      Map<String, dynamic> requestBody = {
        "storyId": currentShowingStory.value?.story.id
      };
      debugPrint(requestBody.toString());
      await GetRequests.viewStory(
          PreferenceManager.user?.id, currentShowingStory.value?.story.id);
    } finally {}
  }
}
