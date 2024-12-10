import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button_outline.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class IntroVideoWidget extends StatelessWidget {
  const IntroVideoWidget(
      {super.key,
      this.videoUrl,
      this.thumbnailUrl,
      this.onRemoveTap,
      this.onTap,
      this.onAddIntroTap});

  final String? videoUrl;
  final String? thumbnailUrl;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onTap;
  final VoidCallback? onAddIntroTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: CommonCardWidget(
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.colorF3,
        child: videoUrl == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppIcons.icVideo,
                    height: 31.17,
                    width: 31.17,
                  ),
                  CommonButtonOutline(
                      width: 150,
                      height: 35,
                      margin: const EdgeInsets.all(8),
                      text: 'add_intro_video'.tr,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      textStyle: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: AppColors.colorTextPrimary,
                              fontSize: 12.fontMultiplier),
                      onPressed: onAddIntroTap)
                ],
              )
            : GestureDetector(
                onTap: onTap,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // VideoThumbnailWidget(videoUrl: videoUrl!),
                        CommonImageWidget(url: thumbnailUrl),
                        if (onRemoveTap != null)
                          Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: onRemoveTap,
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  )))
                      ],
                    )),
              ),
      ),
    );
  }
}
