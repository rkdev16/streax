import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/main.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/video_trimmer.dart';
import 'package:streax/views/bottomsheets/skip_intro_bottom_sheet.dart';
import 'package:streax/views/dialogs/common/common_loader.dart';
import 'package:streax/views/widgets/common_button.dart';

class IntroVideoGuidelineScreen extends StatefulWidget {
  const IntroVideoGuidelineScreen({super.key});

  @override
  State<IntroVideoGuidelineScreen> createState() =>
      _IntroVideoGuidelineScreenState();
}

class _IntroVideoGuidelineScreenState extends State<IntroVideoGuidelineScreen> {
  RecordVideoFor? recordVideoFor;
  static const platform = MethodChannel(AppConsts.methodChannelName);

  getArguments() {
    Map<String, dynamic>? data = Get.arguments;
    if (data != null) {
      recordVideoFor = data[AppConsts.keyRecordVideoFor];
    }
  }

  recordVideo() async {
    try {
      final result = await platform.invokeMethod('openCameraKitLenses');
      var trimmedVideoPath;
      File compressedFile;
      var dirPath = await getApplicationCacheDirectory();
      var dirPath2 = await getApplicationDocumentsDirectory();

      final Map<String, dynamic>? data = await Get.to(() => TrimmerView(File(
            result['path'],
          )));

      if (data != null) {
        var trimmedVideo = data[AppConsts.keyVideoPath];
        File trimmedVideoFile = File(trimmedVideo);
        trimmedVideoPath = File(
          '${dirPath.path}/${result['path'].toString().split('/').last}',
        );
        await trimmedVideoFile.copy(trimmedVideoPath.path);

        debugPrint(
            'Original size: ================>>>>>>>>>>>> ${getVideoSize(file: File(result['path']!))}');
        CommonLoader.show();

        String command =
            '-y -i ${trimmedVideoPath.path} -vf "scale=1080:1920" -r 30 -b:v 3120k -b:a 128k -q:v 21 -c:a aac ${Platform.isAndroid ? dirPath.path : dirPath2.path}/${result['path'].toString().split('/').last}';

        await FFmpegKit.execute(command);
        debugPrint(
            'Size after compression: ================>>>>>>>>>>>> ${getVideoSize(file: File('${Platform.isAndroid ? dirPath.path : dirPath2.path}/${result['path'].toString().split('/').last}'))}');

        compressedFile = File(
            '${Platform.isAndroid ? dirPath.path : dirPath2.path}/${result['path']!.toString().split('/').last}');

        final String path = compressedFile.path;
        final String mimeType = result['mime_type'];
        debugPrint("MimeType = $mimeType");
        debugPrint("path = $path");

        CommonLoader.dismiss();

        Get.offNamed(AppRoutes.routeVideoPlaybackScreen, arguments: {
          AppConsts.keyVideoPath: path,
          AppConsts.keyRecordVideoFor: recordVideoFor
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Platform Exception $e");
      return null;
    }

    //mime type = video || image
  }

  @override
  void initState() {
    super.initState();
    getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.kPrimaryColor,
        body: Column(
          // fit: StackFit.expand,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 50),
                  child: Text(
                    'one_last_thing'.tr,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: AppColors.colorF3),
                  ),
                ),
                CommonButton(
                    width: 80,
                    height: 30,
                    borderRadius: 100,
                    backgroundColor: Colors.white,
                    textColor: AppColors.kPrimaryColor,
                    text: 'skip'.tr,
                    onPressed: () {
                      SkipIntroBottomSheet.show(
                          context: context,
                          onSkipTap: () {
                            Get.back();
                            switch (recordVideoFor) {
                              case RecordVideoFor.editProfile:
                                Get.back();
                                break;
                              case RecordVideoFor.profileSetup:
                                Get.offAllNamed(AppRoutes.routeDashBoardScreen);
                                break;

                              default:
                                Get.back();
                            }
                          });
                    }),
              ],
            ),
            Expanded(
                child: SizedBox(
                    child: SvgPicture.asset(
              AppImages.imgCaptureVideo,
              height: 300,
            ))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 172,
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
              child: Column(
                children: [
                  CommonButton(
                      text: 'record'.tr,
                      borderRadius: 24,
                      onPressed: () {
                        recordVideo();
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'description_record_intro'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 14.fontMultiplier, color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
