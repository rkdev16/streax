import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/main.dart';
import 'package:streax/utils/custom_gallery/media_picker_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/video_trimmer.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:video_player/video_player.dart';
import 'dart:typed_data';

import 'package:streax/config/app_colors.dart';

import '../../controller/home/home_controller.dart';

class MediaData {
  String? mediaPath;
  String? uploadVideoPath;
  MediaType mediaType;
  int mediaDuration = 5; //default to 5 seconds
  MediaSource? mediaSource;

  MediaData(
      {this.mediaPath,
      this.uploadVideoPath,
      required this.mediaType,
      required this.mediaDuration,
      this.mediaSource = MediaSource.gallery});
}

class CustomMediaPicker {
  static pickMedia(Function(MediaData media) onComplete) {
    Get.to(() => _CustomGalleryScreen(
          onComplete: onComplete,
        ));
  }
}

class _CustomGalleryScreen extends StatelessWidget {
  _CustomGalleryScreen({required this.onComplete});

  final _galleryController = Get.put(MediaPickerController());
  final Function(MediaData media) onComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        leading: IconButton(
            onPressed: () {
              if(Get.find<DashBoardController>().currentTabIndex.value == 0){
                Get.find<HomeController>().playControllerAtIndex(
                    Get.find<HomeController>().focusedIndex);
              }
              Get.back();
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.black,
              size: 28,
            )),
        title: 'new_post'.tr,
        actions: [
          TextButton(
              onPressed: () async {
                var asset = _galleryController.selectedAsset.value;
                if (asset != null) {
                  var mediaType = asset.type == AssetType.video
                      ? MediaType.video
                      : MediaType.image;
                  var file = await asset.file;
                  if (file != null) {
                    var dirPath = await getApplicationCacheDirectory();
                    if (mediaType == MediaType.video) {
                      debugPrint('videooo ------->>>>>>${file.path}');
                      final Map<String, dynamic>? data =
                          await Get.to(() => TrimmerView(File(file.path)));
                      if (data != null) {
                        CommonLoader.show();
                        final trimmedVideo = data[AppConsts.keyVideoPath];
                        File trimmedVideoFile = File(trimmedVideo);
                        final videoDuration = data[AppConsts.keyDuration];
                        final trimmedVideoPath = File(
                          '${dirPath.path}/${file.path.toString().split('/').last}',
                        );
                        await trimmedVideoFile.copy(trimmedVideoPath.path);

                        debugPrint(
                            'Original size: common ================>>>>>>>>>>>> ${getVideoSize(file: File(trimmedVideoPath.path))}');
                        var dirPath2 = await getApplicationDocumentsDirectory();

                        String command =
                            '-y -i ${trimmedVideoPath.path} -r 30 -b:v 3120k -b:a 128k -q:v 21 -c:a aac ${Platform.isAndroid ? dirPath.path : dirPath2.path}/${file.path.toString().split('/').last}';
                        await FFmpegKit.execute(command);

                        debugPrint(
                            'Size after compression: ================>>>>>>>>>>>> ${getVideoSize(file: File('${Platform.isAndroid ? dirPath.path : dirPath2.path}/${file.path.toString().split('/').last}'))}');

                        debugPrint("Video_duration = $videoDuration");

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                        CommonLoader.dismiss();

                        onComplete(MediaData(
                            uploadVideoPath: Platform.isAndroid
                                ? '${dirPath.path}/${file.path.toString().split('/').last}'
                                : '${dirPath2.path}/${file.path.toString().split('/').last}',
                            mediaPath: Platform.isAndroid
                                ? '${dirPath.path}/${file.path.toString().split('/').last}'
                                : '${dirPath2.path}/${file.path.toString().split('/').last}',
                            mediaType: MediaType.video,
                            mediaSource: MediaSource.gallery,
                            mediaDuration: videoDuration));
                      }
                    } else {
                      debugPrint(
                          'Original size: ================>>>>>>>>>>>> ${getVideoSize(file: File(file.path))}');
                      CommonLoader.show();

                      final compressedFile =
                          await FlutterImageCompress.compressAndGetFile(
                        file.path,
                        '${dirPath.path}/${file.path.toString().split('/').last.split('.').first}.jpg',
                        quality: 95,
                      );
                      debugPrint(
                          'Size after compression: ================>>>>>>>>>>>> ${getVideoSize(file: File(compressedFile!.path))}');
                      CommonLoader.dismiss();

                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                      onComplete(MediaData(
                          mediaPath: compressedFile.path,
                          mediaType: mediaType,
                          mediaSource: MediaSource.gallery,
                          mediaDuration: AppConsts.defaultMediaDuration));
                    }
                  }
                }
              },
              child: Text(
                'next'.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14.fontMultiplier,
                    color: AppColors.kPrimaryColor,
                    fontWeight: FontWeight.w700),
              ))
        ],
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: _galleryController.isLoading.value
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 45,
                      child: Obx(
                        () => AssetPreview(
                          asset: _galleryController.selectedAsset.value,
                          controller: _galleryController.videoController,
                          isPlayerInitialized:
                              _galleryController.isPlayerInitialized.value,
                          onComplete: onComplete,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Obx(
                        () => GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            var asset = _galleryController.assets[index];
                            return InkWell(
                                onTap: () {
                                  // setState(() {
                                  _galleryController.selectAsset(asset);
                                  // });
                                },
                                child: AssetThumbnail(asset: asset));
                          },
                          itemCount: _galleryController.assets.length,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({super.key, required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: asset.thumbnailData,
        builder: (context, snapshot) {
          final bytes = snapshot.data;
          if (bytes == null) return const CupertinoActivityIndicator();

          return Stack(
            fit: StackFit.expand,
            children: [
              ExtendedImage.memory(
                bytes,
                fit: BoxFit.cover,
              ),
              if (asset.type == AssetType.video)
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.kPrimaryColor.withOpacity(0.4),
                          shape: BoxShape.circle),
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(1.0),
                      child: const Icon(
                        Icons.play_circle_filled_rounded,
                        color: AppColors.kPrimaryColor,
                        size: 16,
                      ),
                    ))
            ],
          );
        });
  }
}

class AssetPreview extends StatelessWidget {
  const AssetPreview(
      {super.key,
      this.asset,
      this.controller,
      required this.isPlayerInitialized,
      required this.onComplete});

  final AssetEntity? asset;
  final VideoPlayerController? controller;
  final bool isPlayerInitialized;
  final Function(MediaData media) onComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Stack(
          children: [
            asset?.type == AssetType.video
                ? Center(
                    child: isPlayerInitialized
                        ? GestureDetector(
                            onTap: () {
                              if (isPlayerInitialized) {
                                if (controller!.value.isPlaying) {
                                  controller?.pause();
                                } else {
                                  controller?.play();
                                }
                              }
                            },
                            child: AspectRatio(
                                aspectRatio: controller!.value.aspectRatio,
                                child: VideoPlayer(controller!)))
                        : Text(
                            'loading'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontSize: 16.fontMultiplier,
                                    color: Colors.white),
                          ))
                : asset?.type == AssetType.image
                    ? Center(
                        child: FutureBuilder<File?>(
                            future: asset?.originFile,
                            builder: (context, snapShot) {
                              final file = snapShot.data;
                              if (file == null) return Container();
                              return ExtendedImage.file(
                                file,
                              );
                            }),
                      )
                    : const SizedBox(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () async {
                    var controller = Get.find<MediaPickerController>();
                    MediaData? media = await controller.openCameraKitLenses();
                    if (media != null && context.mounted) {
                      Navigator.of(context).pop();
                      onComplete(media);
                    }
                  },
                  icon: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: SvgPicture.asset(AppIcons.icCameraFilled))),
            )
          ],
        ));
  }
}
