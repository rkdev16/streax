import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/utils/custom_gallery/custom_media_picker.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:video_player/video_player.dart';

class MediaPreview {
  MediaPreview.preview(
      {required MediaData media,
      Function(MediaData media)? onDone,
      VoidCallback? onRetake}) {
    Get.to(() =>
        _MediaPreviewWidget(media: media, onDone: onDone, onRetake: onRetake));
  }
}

class _MediaPreviewWidget extends StatefulWidget {
  const _MediaPreviewWidget({
    required this.media,
    this.onRetake,
    this.onDone,
  });

  // final MediaType mediaType;
  // final String? mediaPath;
  final MediaData media;
  final Function(MediaData media)? onDone;
  final VoidCallback? onRetake;

  @override
  State<_MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<_MediaPreviewWidget>
    with TickerProviderStateMixin {
  VideoPlayerController? vController;
  late AnimationController fadeInOutAnimationController;
  late Animation<double> fadeInOutAnimation;

  double aspectRatio = 0.0;

  @override
  void initState() {
    super.initState();
    debugPrint('Url = ${widget.media.mediaPath}');
    if (widget.media.mediaType == MediaType.image) {

    } else if (widget.media.mediaType == MediaType.video) {
      _startVideoPlayer();
    }
    FocusManager.instance.primaryFocus?.unfocus();
    fadeInOutAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    fadeInOutAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(fadeInOutAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        appBar: CommonAppBar(
          systemUiOverlayStyle: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: AppColors.kPrimaryColor),
          backgroundColor: AppColors.kPrimaryColor,
          leadingIconColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onRetake ?? ();
              },
              icon: const Icon(Icons.close_rounded)),
          title: 'preview'.tr,
          titleTextStyle: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontSize: 18.fontMultiplier, color: Colors.white),
          actions: [
            if (widget.onDone != null)
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.media.mediaDuration =
                        vController?.value.duration.inSeconds ??
                            AppConsts.defaultMediaDuration;
                    widget.onDone!(widget.media);
                  },
                  child: Text(
                    'done'.tr,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 14.fontMultiplier,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ))
          ],
        ),
        body: Center(
          child: widget.media.mediaType == MediaType.video
              ? handleVideo()
              : widget.media.mediaType == MediaType.image
                  ? handleImage()
                  : Container(),
        ));
  }

  @override
  void dispose() {
    if (widget.media.mediaType == MediaType.video) {
      vController?.dispose();
    }
    fadeInOutAnimationController.dispose();
    super.dispose();
  }

  handleVideo() {
    return widget.media.mediaPath == null
        ? errorWidget()
        : GestureDetector(
            onTap: () {
              toggleVideoPlayback();
              setState(() {});
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                aspectRatio != 0.0 ? AspectRatio(
                  aspectRatio: vController!.value.aspectRatio,
                  child: VideoPlayer(
                    vController!,
                  ),
                ) : SizedBox(),
                FadeTransition(
                    opacity: fadeInOutAnimation,
                    child: Icon(
                      vController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow_rounded,
                      size: 100,
                      color: AppColors.colorF3,
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(vController!,
                      colors: VideoProgressColors(
                        playedColor: AppColors.kPrimaryColor
                      ),
                      allowScrubbing: true),
                ),
              ],
            ));
  }

  handleImage() {
    final mediaPath = widget.media.mediaPath;
    debugPrint("MediaPath = $mediaPath");
    if (mediaPath == null) {
      return errorWidget();
    } else {
      if (mediaPath.startsWith('http')) {
        return CommonImageWidget(
            width: double.infinity, height: double.infinity, url: mediaPath,fit: BoxFit.contain,);
      } else {
        return Image.file(
          File(widget.media.mediaPath!),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        );
      }
    }
  }

  errorWidget() {
    return Center(
        child: Text('error_loading_media'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 16.fontMultiplier,
                color: AppColors.colorTextSecondary)));
  }

  Future<void> _startVideoPlayer() async {
    String? mediaPath = widget.media.mediaPath;
    if (mediaPath == null) {
      return;
    }

    if (mediaPath.startsWith('http')) {
      vController = VideoPlayerController.network(
        mediaPath,
      );
    } else {
      vController = VideoPlayerController.file(File(mediaPath));
    }

    await vController?.initialize();
    await vController?.setLooping(false);

    final width = vController!.value.size.width;
    final height = vController!.value.size.height;
    aspectRatio = width > height ? width / height : height / width;

    debugPrint('======> ${vController!.value.aspectRatio}');
    debugPrint('======> ${width > height}');

    debugPrint(
        'aspectRatio ======> ${width > height ? width / height : height / width}');


    if (mounted) {
      setState(() {
        vController = vController;
      });
    }

    await vController?.play();
    vController?.addListener(() {
      setState(() {
        monitorVideoPosition();
      });
    });
  }

  toggleVideoPlayback() {
    if (vController != null && vController!.value.isInitialized) {
      if (vController!.value.isPlaying) {
        fadeInOutAnimationController.forward();

        vController?.pause();
      } else {
        fadeInOutAnimationController.reverse();
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

  monitorVideoPosition() {
    // Implement your calls inside these conditions' bodies :
    if (vController!.value.position ==
        const Duration(seconds: 0, minutes: 0, hours: 0)) {
      fadeInOutAnimationController.reverse();
      debugPrint('video Started');
    }

    if (vController!.value.position == vController!.value.duration) {
      debugPrint('video Ended');
      fadeInOutAnimationController.forward();
    }
  }
}
