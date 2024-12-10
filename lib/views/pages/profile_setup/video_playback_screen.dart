import 'dart:io';

import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';

class VideoPlaybackScreen extends StatefulWidget {
  const VideoPlaybackScreen({super.key});

  @override
  State<VideoPlaybackScreen> createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  String? videoPath;
  RecordVideoFor? recordVideoFor;
  CachedVideoPlayerController? vController;

  VoidCallback? videoPlayerListener;

  getArguments() {
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      videoPath = data[AppConsts.keyVideoPath];
      recordVideoFor = data[AppConsts.keyRecordVideoFor];
    }

    debugPrint('VideoPath = $videoPath');
  }

  @override
  void initState() {
    super.initState();
    getArguments();
    _startVideoPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // fit: StackFit.expand,
      children: [
        Expanded(
            child: GestureDetector(
                onTap: () {
                  toggleVideoPlayback();
                },
                child: CachedVideoPlayer(vController!))),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: AppColors.kPrimaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Get.offNamed(AppRoutes.routeIntroVideoGuidelineScreen,
                          arguments: {
                            AppConsts.keyRecordVideoFor: recordVideoFor
                          });
                    },
                    child: Text(
                      'retake'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorF6,
                              fontWeight: FontWeight.w600),
                    )),
                TextButton(
                    onPressed: () async {
                      pauseVideo();
                      debugPrint(
                          "video uploading  ================>>>>>>>>>>>>");
                      updateIntroVideo(videoPath);
                    },
                    child: Text(
                      'done'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: AppColors.colorF6,
                              fontWeight: FontWeight.w600),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    vController?.dispose();
    super.dispose();
  }

  Future<void> _startVideoPlayer() async {
    if (videoPath == null) {
      return;
    }

    vController = CachedVideoPlayerController.file(File((videoPath)!))
      ..initialize().then((_) => setState(() {}));

    // vController = CachedVideoPlayerController.file(File((videoPath)!))
    //   ..initialize().then((value) {
    //     setState(() {
    //       vController?.play();
    //     });
    //   });
    // await vController?.initialize();
    await vController?.setLooping(true);

    if (mounted) {
      setState(() {
        vController = vController;
      });
    }
    await vController?.play();
  }

  toggleVideoPlayback() {
    if (vController != null && vController!.value.isInitialized) {
      if (vController!.value.isPlaying) {
        vController?.pause();
      } else {
        vController?.play();
      }
    }
  }

  playVideo() {
    if (vController != null &&
        vController!.value.isInitialized &&
        !vController!.value.isPlaying) {
      vController?.play();
    }
  }

  pauseVideo() {
    if (vController != null &&
        vController!.value.isInitialized &&
        vController!.value.isPlaying) {
      vController?.pause();
    }
  }

  // Future<void> uploadFile(String? path) async {
  //
  //    debugPrint("videoPath = $videoPath");
  //
  //    if(path ==null) return;
  //
  //    try{
  //      CommonLoader.show();
  //      var result = await PostRequests.uploadFiles(paths: [path]);
  //      if (result != null) {
  //        if (result.success) {
  //          CommonLoader.dismiss();
  //          updateIntroVideo(result.data?.first);
  //
  //
  //        } else {
  //          AppAlerts.error(message: result.message);
  //        }
  //      } else {
  //        AppAlerts.error(message: 'message_server_error'.tr);
  //      }
  //    }finally{
  //      CommonLoader.dismiss();
  //    }
  //
  //
  //
  //  }

  updateIntroVideo(String? path) async {
    if (path == null) return;
    try {
      CommonLoader.show();
      String? mediaUrl = await uploadFile([path]);
      String? thumbnailUrl;
      debugPrint("thumbnail ======>>>> start $path");

      String? thumbnailPath = await Helpers.createVideoThumbnail(path);
      if (thumbnailPath != null) {
        thumbnailUrl = await uploadFile([thumbnailPath]);
      }
      Map<String, dynamic> requestBody = {
        "introVideo": mediaUrl,
        "introVideoThumbnail": thumbnailUrl,
      };
      debugPrint("thumbnail ======>>>> uploaded $thumbnailUrl");

      var result = await PutRequests.updateProfile(requestBody);
      debugPrint("RecordVideoFor = $recordVideoFor");
      if (result != null) {
        if (result.success) {
          switch (recordVideoFor) {
            case RecordVideoFor.profileSetup:
              Get.offAllNamed(AppRoutes.routeDashBoardScreen);
              break;
            case RecordVideoFor.editProfile:
              Get.find<ProfileController>().getUserProfile();
              Get.until((route) =>
                  route.settings.name == AppRoutes.routeDashBoardScreen);
              break;
            default:
              Get.back();
          }
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } on Exception catch (e) {
      CommonLoader.dismiss();
      debugPrint(e.toString());
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
}
