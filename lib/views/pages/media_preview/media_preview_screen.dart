import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewScreen extends StatefulWidget {
  const MediaPreviewScreen({super.key,
    required this.mediaType,
    this.mediaUrl,
    this.sourceType,
    this.isAppBarVisible
  });

  final MediaType mediaType;
  final String? mediaUrl;
  final SourceType? sourceType;
  final bool? isAppBarVisible;

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? vController;
  late AnimationController fadeInOutAnimationController;
  late Animation<double> fadeInOutAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == MediaType.image) {
    } else if (widget.mediaType == MediaType.video) {
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
        appBar: widget.isAppBarVisible == false? AppBar(
          toolbarHeight: 0,
        ) :  CommonAppBar(
          systemUiOverlayStyle: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: AppColors.kPrimaryColor),
          backgroundColor: AppColors.kPrimaryColor,
          leadingIconColor: Colors.white,
          onBackTap: () {
            Get.back();
          },
          title: '',
        ),
        body: Center(
          child: widget.mediaType == MediaType.video
              ? handleVideo()
              : widget.mediaType == MediaType.image
                  ? handleImage()
                  : Container(),
        ));
  }

  @override
  void dispose() {
    if (widget.mediaType == MediaType.video) {
      vController?.dispose();
    }
    super.dispose();
  }

  handleVideo() {
    return widget.mediaUrl == null
        ? errorWidget()
        : GestureDetector(
            onTap: () {
              toggleVideoPlayback();
              setState(() {});
            },
            child: AspectRatio(
                aspectRatio: vController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(vController!),
                    Center(
                      child: FadeTransition(
                          opacity: fadeInOutAnimation,
                          child: Icon(
                            vController!.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow_rounded,
                            size: 100,
                            color: AppColors.colorF3,
                          )),
                    ),
                    VideoProgressIndicator(vController!, allowScrubbing: true),
                  ],
                )));
  }

  handleImage() {
    
    return widget.mediaUrl == null
        ? errorWidget()
        : widget.sourceType == SourceType.local ? Image.asset(widget.mediaUrl!) :  CommonImageWidget(
            url: widget.mediaUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fitWidth,
          );
  }

  errorWidget() {
    return Center(
        child: Text('error_loading_media'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 16.fontMultiplier,
                color: AppColors.colorTextSecondary)));
  }

  Future<void> _startVideoPlayer() async {
    if (widget.mediaUrl == null) {
      return;
    }

    if(widget.sourceType == SourceType.local){

      vController = VideoPlayerController.file(File(widget.mediaUrl!));
      
    }else{
      vController = VideoPlayerController.network(Helpers.getCompleteUrl(widget.mediaUrl!));
    }



    await vController?.initialize();
    await vController?.setLooping(false);

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
