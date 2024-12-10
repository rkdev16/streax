import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/views/pages/home/components/profile_widget.dart';
import 'package:streax/views/pages/home/components/video_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class ImagesWidget extends StatefulWidget {
  ImagesWidget({
    super.key,
    required this.urls,
    this.introVideo,
    this.videoController,
  });

  final List<String> urls;
  final String? introVideo;
  CachedVideoPlayerController? videoController;

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  late PageController pageController;
  List<String> get urls => widget.urls;

  String? get introVideo => widget.introVideo;

  CachedVideoPlayerController? get videoPlayerController =>
      widget.videoController;

  bool isPlaying = true;
  bool isMute = false;
  bool isInitialized = false;

  onPageChanged(int position) {}

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {});
    isMute = Get.find<HomeController>().profileSuggestions[Get.find<HomeController>().focusedIndex].user.videoMuted;
    if(isMute == false){
      videoPlayerController?.setVolume(1.0);
    }else{
      videoPlayerController?.setVolume(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("gallery = $urls");
    debugPrint("gallery = $introVideo");

    return Swiper(
      itemHeight: double.infinity,
      itemWidth: double.infinity,
      itemCount: introVideo != null && introVideo.toString().isNotEmpty
          ? widget.urls.length + 1
          : widget.urls.length,
      loop: false,
      pagination: const SwiperPagination(
          alignment: Alignment.topCenter, builder: SwiperPagination.dots),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            introVideo != null &&
                    introVideo.toString().isNotEmpty &&
                    index == 0
                ? GestureDetector(
                    onTap: () {
                      togglePlayPause();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoWidget(controller: videoPlayerController ?? CachedVideoPlayerController.network(
                            introVideo!)),
                        isPlaying
                            ? const SizedBox()
                            : Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ).paddingAll(12),
                              ),
                        if (videoPlayerController != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      toggleVolume();
                                    },
                                    icon: SvgPicture.asset(
                                      isMute
                                          ? AppIcons.icVolumeOff
                                          : AppIcons.icVolumeUp,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ))

                                // PlayerControllers(
                                //   controller: videoPlayerController!,
                                //   isPlaying: isPlaying,
                                //   isMute: isMute,
                                //   onTogglePlaybackTap: () {
                                //     togglePlayPause();
                                //   },
                                //   onToggleVolumeTap: () {
                                //     toggleVolume();
                                //   },
                                // ),
                                ),
                          ),
                      ],
                    ))
                : CommonImageWidget(
                    url: urls[
                        introVideo != null && introVideo.toString().isNotEmpty
                            ? index - 1
                            : index]),

            // to show  overlay over media
            const OverlayWidget(),
          ],
        );
      },
    );

    // return Stack(
    //
    //   children: [
    //
    //     PageView(
    //       controller: PageController,
    //       onPageChanged: (int index),
    //       children: widget.urls.map((e) => CommonImageWidget(url: e)).toList(growable: false),),
    //   ],
    // );
  }

  toggleVolume() {
    if (videoPlayerController == null) return;

    if (videoPlayerController!.value.isInitialized) {
      double volume = videoPlayerController!.value.volume;
      if (volume > 0.0) {
        videoPlayerController!.setVolume(0.0);
      } else {
        videoPlayerController!.setVolume(1.0);
      }

      if (mounted) {
        setState(() {
          isMute = videoPlayerController!.value.volume == 0.0;
        });
        debugPrint('$isMute valueeeee ==>>>>>>' );
        Get.find<HomeController>().audioMuted(isMute);
      }
    }
  }

  togglePlayPause() {
    if (videoPlayerController == null) return;
    debugPrint("PlayPause====");
    if (videoPlayerController!.value.isInitialized) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      } else {
        videoPlayerController!.play();
      }
      if (mounted) {
        setState(() {
          isPlaying = videoPlayerController!.value.isPlaying;
        });
      }
    }
  }
}
