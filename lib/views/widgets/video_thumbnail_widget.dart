import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatelessWidget {
  const VideoThumbnailWidget({super.key, required this.videoUrl});

  final String videoUrl;

  Future<String> getThumbnail() async {

    String? result;

    try {
      result = await VideoThumbnail.thumbnailFile(
        video: Helpers.getCompleteUrl(videoUrl),

        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        //  maxHeight: 64,
        // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
    } on Exception catch (e) {
      debugPrint("Exception = $e");
      result = 'Error';
    }

    return result ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getThumbnail(),
        initialData: 'Hihihih',
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CommonProgressBar();

            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.kPrimaryColor,
                        size: 50,
                      ),
                      Text(
                        'error_loading_media'.tr,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 14.fontMultiplier,
                                  color: AppColors.kPrimaryColor,
                                ),
                      ),
                    ],
                  ),
                );
              }
              return Stack(
                fit: StackFit.expand,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOver),
                    child: Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Icon(
                    Icons.play_circle,
                    color: AppColors.colorF3,
                    size: 50,
                  )
                ],
              );
          }
        });
  }
}
