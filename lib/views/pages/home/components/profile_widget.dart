import 'package:cached_video_player_fork/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/bottomsheets/center_stage_bottom_sheet.dart';
import 'package:streax/views/bottomsheets/hangout_request_bottom_sheet.dart';
import 'package:streax/views/pages/home/components/images_widget.dart';
import 'package:streax/views/pages/home/components/profile_actions_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:vibration/vibration.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({super.key, required this.user, this.videoPlayerController});

  final User user;
  CachedVideoPlayerController? videoPlayerController;

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  User get user => widget.user;

  CachedVideoPlayerController? get videoPlayerController =>
      widget.videoPlayerController;

  bool isLoadingHangout = false;

  toggleLike() async {
    Get.find<HomeController>().isLoadingLike.value = true;
    if (user.id != null) {
      var controller = Get.find<ConnectionsController>();
      var newLikeStatus = user.iLiked == 1 ? 0 : 1;
      // HapticFeedback.mediumImpact();
      //  Vibrate.vibrate();
      // Vibrate.feedback(FeedbackType.medium);
      Vibration.vibrate(
        duration: 1000
      );
      // SystemSound.play(SystemSoundType.click);
      if (mounted) {
        setState(() {
          user.iLiked = newLikeStatus;
        });
      }

      var status = await controller.toggleLike(user.id!);

      if (status != newLikeStatus) {
        if (mounted) {
          setState(() {
            user.iLiked = status;
          });
        }
      } else {
        Get.find<HomeController>().checkForMatchRemove(user.id ?? '');
      }
    }
  }

  sendSuperLike() async {
    if (user.id != null) {
      var controller = Get.find<ConnectionsController>();
      var newLikeStatus = user.superLike == 1 ? 0 : 1;
      // Vibrate.feedback(FeedbackType.medium);
      Vibration.vibrate(duration: 1000);
      // SystemSound.play(SystemSoundType.click);
      if (mounted) {
        setState(() {
          user.superLike = newLikeStatus;
        });
      }

      var status = await controller.superLike(user.id!);
      if (status != newLikeStatus) {
        if (mounted) {
          setState(() {
            user.superLike = status;
          });
        }
      } else {
        Get.find<HomeController>().checkForMatchRemove(user.id ?? '');
        Get.find<ProfileController>().getUserProfile();
      }
    }
  }

  sendCenterStage() async {
    if (user.id != null) {
      try{
        // Vibrate.feedback(FeedbackType.medium);
        Vibration.vibrate(duration: 1000);
        // SystemSound.play(SystemSoundType.click);
        if (mounted) {
          setState(() {
            user.isCenterStage =  user.isCenterStage == 1 ? 0 : 1;
          });
        }
        var result = await PostRequests.centerStage(user.id!);
        if(result !=null){
          Get.find<ProfileController>().getUserProfile();
          Get.find<HomeController>().checkForMatchRemove(user.id ?? '');
        }
      } on Exception catch(e){
        user.isCenterStage = 0;
            debugPrint(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onDoubleTap: () {
          toggleLike();
        },
        child: Stack(
          children: [
            /*if (user.introVideo != null &&
                user.introVideo.toString().isNotEmpty)
              VideoWidget(controller: videoPlayerController!)
            // StoryVideo.url(Helpers.getCompleteUrl(user.introVideo),controller: StoryController())
            else*/
            if (user.gallery != null && user.gallery!.isNotEmpty)
              ImagesWidget(
                urls: user.gallery!,
                introVideo: user.introVideo,
                videoController: videoPlayerController,
              )
            else
              Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomCenter,
                children: [
                  CommonImageWidget(
                    url: user.image,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  // to show  overlay over media
                  const OverlayWidget(),
                ],
              ),
            ProfileActionsWidget(
              user: user,
              onLikeTap: () {
                toggleLike();
              },
              onInstantChatTap: () async {
                if (Helpers.canUsePremium(PremiumType.instantChat)) {
                  try {
                    ChatController controller = Get.find<ChatController>();
                    String? roomId = await controller.createRoom(user.id ?? "");
                    ChatDialog? roomDetail =
                        await controller.getRoomDetail(roomId ?? "");

                    if (roomDetail != null) {
                      controller.selectedChatDialog = roomDetail;
                      Get.toNamed(AppRoutes.routeChatScreen, arguments: {
                        'isOnline':
                            controller.selectedChatDialog?.isOnline ?? false,
                        'fromHome': true
                      });
                    }
                  } finally {
                  }
                } else {
                  Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                }
              },
              onCenterStageTap: () async {
                if (Helpers.canUsePremium(PremiumType.centerStage)) {
                   CenterStageBottomSheet.show(
                       user: user,
                       onActivate: () {
                         Get.back();
                       sendCenterStage();
                       });
                } else {
                  Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                }
              },
              onSuperLikeTap: () {
                if (Helpers.canUsePremium(PremiumType.crush)) {
                  sendSuperLike();
                } else {
                  Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                }
              },
              onHangoutTap: () async {
                if (isLoadingHangout) return;
                if (Helpers.canUsePremium(PremiumType.dateRequest)) {
                  try {
                    setState(() {
                      isLoadingHangout = true;
                    });

                    ChatController controller = Get.find<ChatController>();
                    String? roomId =
                        await controller.createRoom(widget.user.id ?? "");
                    ChatDialog? roomDetail =
                        await controller.getRoomDetail(roomId ?? "");
                    if (roomDetail != null) {
                      controller.selectedChatDialog = roomDetail;
                      HangoutRequestBottomSheet.show(
                          user: User(
                        id: controller.selectedChatDialog?.id,
                        userName: controller.selectedChatDialog?.userName,
                        fullName: controller.selectedChatDialog?.fullName,
                        image: controller.selectedChatDialog?.image,
                      ));
                    }
                  } finally {
                    setState(() {
                      isLoadingHangout = false;
                    });
                  }
                } else {
                  Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                }
              },
              isLoadingHangout: isLoadingHangout,
            ),
            UserInfoWidget(
              user: user,
            ),
          ],
        ),
      ),
    );
  }
}

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )
        ),
        width: SizeConfig.screenWidth,
        height: SizeConfig.heightMultiplier * 20,
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 55,
      left: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.routePublicProfileScreen,
                  arguments: {AppConsts.keyUser: user});
            },
            child: Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CommonImageWidget(
                url: user.image,
                borderRadius: 100,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.routePublicProfileScreen,
                  arguments: {AppConsts.keyUser: user});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.fullName ?? 'user'.tr}, ${Helpers.calculateAge(user.dob)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16.fontMultiplier,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.icMarkerOutlined,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          user.livesIn ?? 'NA',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontSize: 14.fontMultiplier,
                                color: Colors.white.withOpacity(0.8),
                              ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
