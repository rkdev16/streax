import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/main.dart';
import 'package:streax/utils/custom_gallery/custom_media_picker.dart';
import 'package:streax/utils/video_trimmer.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import 'package:video_player/video_player.dart';

class MediaPickerController extends GetxController {
  var assets = <AssetEntity>[].obs;

  RxBool isHeavingPermission = true.obs;
  RxBool isPlayerInitialized = false.obs;

  RxBool isLoading = true.obs;
  Rx<AssetEntity?> selectedAsset = Rx<AssetEntity?>(null);
  VideoPlayerController? videoController;
  static const platform = MethodChannel(AppConsts.methodChannelName);

  MediaSource mediaSource = MediaSource.gallery;

  @override
  void onInit() {
    super.onInit();
    requestPermission();
  }

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }

  requestPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    debugPrint("Permission_state = $ps");
    if (ps.isAuth) {
      // Granted
      // You can to get assets here.
      _fetchAssets();
    } else if (ps.hasAccess) {
      _fetchAssets();
      // Access will continue, but the amount visible depends on the user's selection.
    } else {
      isHeavingPermission.value = false;

      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
      //  await   PhotoManager.openSetting();
      // requestPermission();
    }
  }

  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage

    try {
      final album = await PhotoManager.getAssetPathList(onlyAll: true);
      final recentAlbum = album.first;

      // Now that we got the album, fetch all the assets it contains

      final recentAssets = await recentAlbum.getAssetListRange(
          start: 0,
          end: 1000000); //end at a very big index (to get all the assets)

      assets.value = recentAssets;
      if (assets.isNotEmpty) {
        selectAsset(assets.first);
        isLoading.value = false;
      }
      debugPrint("RecentAssetsCount = ${assets.length}");
    } on Exception catch (e) {
      debugPrint("Exception_while_fetching_assets = $e");
    }
  }

  initPlayerController(String path) async {
    isPlayerInitialized.value = false;
    videoController = VideoPlayerController.file(File(path));
    videoController
        ?.initialize()
        .then((value) => isPlayerInitialized.value = true);
    videoController?.play();
  }

  selectAsset(AssetEntity asset) async {
    selectedAsset.value = asset;
    if (selectedAsset.value?.type == AssetType.video) {
      final file = await asset.file;
      if (file == null) return;
      initPlayerController(file.path);
    } else {
      isPlayerInitialized.value = false;
      videoController?.dispose();
    }
  }

  Future<MediaData?> openCameraKitLenses() async {
    try {
      final result = await platform.invokeMethod('openCameraKitLenses');

      var compressedFile;
      var videoDuration;

      var dirPath = await getApplicationCacheDirectory();
      var dirPath2 = await getApplicationDocumentsDirectory();
      if (result['mime_type'] == 'video') {
        final Map<String, dynamic>? data = await Get.to(() => TrimmerView(File(
              result['path'],
            )));
        if (data != null) {
          var trimmedVideo = data[AppConsts.keyVideoPath];
          File trimmedVideoFile = File(trimmedVideo);
          videoDuration = data[AppConsts.keyDuration];
          File trimmedVideoPath = File(
            '${dirPath.path}/${result['path'].toString().split('/').last}',
          );
          await trimmedVideoFile.copy(trimmedVideoPath.path);
          CommonLoader.show();

          debugPrint(
              'Original size: ================>>>>>>>>>>>> ${result['path']}');
          debugPrint(
              'Original size: ================>>>>>>>>>>>> ${getVideoSize(file: File(result['path']!))}');

          String command =
              '-y -i ${trimmedVideoPath.path} -vf "scale=1080:1920" -r 30 -b:v 3120k -b:a 128k -q:v 21 -c:a aac ${dirPath2.path}/${result['path'].toString().split('/').last}';

          await FFmpegKit.execute(command);

          debugPrint(
              'Size after compression: ================>>>>>>>>>>>> ${getVideoSize(file: File('${dirPath2.path}/${result['path'].toString().split('/').last}'))}');

          compressedFile = File(
              '${dirPath2.path}/${result['path']!.toString().split('/').last}');
          CommonLoader.dismiss();

          return MediaData(
              mediaPath:  compressedFile.path,
              uploadVideoPath: compressedFile.path,
              mediaSource: MediaSource.camera,
              mediaType: MediaType.video,
              mediaDuration: videoDuration);
        }
      } else {
        debugPrint(
            'Original size: ================>>>>>>>>>>>> ${result['path']}');
        debugPrint(
            'Original size: ================>>>>>>>>>>>> ${getVideoSize(file: File(result['path']!))}');
        CommonLoader.show();

        compressedFile = await FlutterImageCompress.compressAndGetFile(
          result['path']!,
          '${dirPath2.path}/${result['path']!.toString().split('/').last.split('.').first}.jpg',
          quality: 95,
        );

        debugPrint(
            'Size after compression: ================>>>>>>>>>>>> ${File(compressedFile!.path).path}');
        debugPrint(
            'Size after compression: ================>>>>>>>>>>>> ${getVideoSize(file: File(compressedFile!.path))}');

        final String path = compressedFile.path as String;
        final String mimeType = result['mime_type'] as String;
        debugPrint("MimeType = $mimeType");
        debugPrint("path = $path");

        CommonLoader.dismiss();

        return MediaData(
            mediaPath: path,
            mediaSource: MediaSource.camera,
            mediaType: MediaType.image,
            mediaDuration: mimeType == 'video'
                ? videoDuration
                : AppConsts.defaultMediaDuration);
      }
    } on PlatformException catch (e) {
      debugPrint("Platform Exception $e");
      return null;
    }
    return null;
  }

  Future<void> encodeVideo(String inputPath, String outputPath) async {
    // Define FFmpeg commands for different quality levels
    List<String> commands = [
      // Low quality
      '-i $inputPath -vf "scale=w=640:h=360:force_original_aspect_ratio=decrease" -c:a aac -ar 48000 -b:a 96k -c:v h264 -profile:v main -crf 20 -g 48 -b:v 800k -maxrate 856k -bufsize 1200k -hls_time 6 -hls_playlist_type vod -hls_segment_filename ${outputPath}stream_360p_%03d.ts ${outputPath}stream_360p.m3u8',
      // Medium quality
      '-i $inputPath -vf "scale=w=842:h=480:force_original_aspect_ratio=decrease" -c:a aac -ar 48000 -b:a 128k -c:v h264 -profile:v main -crf 20 -g 48 -b:v 1400k -maxrate 1498k -bufsize 2100k -hls_time 6 -hls_playlist_type vod -hls_segment_filename ${outputPath}stream_480p_%03d.ts ${outputPath}stream_480p.m3u8',
      // High quality
      '-i $inputPath -vf "scale=w=1280:h=720:force_original_aspect_ratio=decrease" -c:a aac -ar 48000 -b:a 128k -c:v h264 -profile:v main -crf 20 -g 48 -b:v 2800k -maxrate 2996k -bufsize 4200k -hls_time 6 -hls_playlist_type vod -hls_segment_filename ${outputPath}stream_720p_%03d.ts ${outputPath}stream_720p.m3u8',
    ];

    for (String command in commands) {
      // String? result = await executeFFmpegCommand(command);
      // print('$result');
      await FFmpegKit.execute(command).then((session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          debugPrint('Encoding completed successfully.');
        } else {
          debugPrint('Encoding failed.');
        }
      });
    }

    // Create master playlist
    String masterPlaylistContent = '''#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=856000,RESOLUTION=640x360
${outputPath}stream_360p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1498000,RESOLUTION=842x480
${outputPath}stream_480p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2996000,RESOLUTION=1280x720
${outputPath}stream_720p.m3u8
''';

    // Write the master playlist to a file
    final masterPlaylistFile = File('${outputPath}master.m3u8');
    await masterPlaylistFile.writeAsString(masterPlaylistContent);
    debugPrint(
        'ppfgsdfs ------- >>>>> ${getVideoSize(file: masterPlaylistFile)}');

    debugPrint('------------>>>');
  }
}
