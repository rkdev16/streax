import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/app_images.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/story/story.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/bottomsheets/center_stage_bottom_sheet.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/bottomsheets/hangout_request_bottom_sheet.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class ConnectionTile extends StatefulWidget {
  const ConnectionTile(
      {Key? key, required this.user, required this.connectionType, this.width})
      : super(key: key);

  final User user;
  final ConnectionType connectionType;
  final double? width;

  @override
  State<ConnectionTile> createState() => _ConnectionTileState();
}

class _ConnectionTileState extends State<ConnectionTile> {
  //final  stories= <List<CustomStoryItem>>[];
  final _storyController = Get.find<StoriesController>();
  final _connectionsController = Get.find<ConnectionsController>();

  Widget getBackgroundImage() {
    var stories = widget.user.stories;

    debugPrint("getBackgroundImage ${stories != null && stories.isNotEmpty}");

    if (stories != null &&
        stories.isNotEmpty &&
        stories.last.thumbnail != null) {
      Story lastStory = stories.last;
      return CommonImageWidget(
        url: lastStory.thumbnail,
        borderRadius: 20,
      );
    } else {
      return CommonImageWidget(
        url: (widget.user.gallery ?? []).isNotEmpty
            ? widget.user.gallery?.first
            : '',
        borderRadius: 20,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          if (widget.user.stories != null && widget.user.stories!.isNotEmpty) {
            Get.toNamed(AppRoutes.routeStoryViewerPagerScreen, arguments: {
              AppConsts.keyIsMyStory: false,
              AppConsts.keyStoriesData:
                  _storyController.setupStoryData([widget.user]),
            });
          }
        },
        child: Container(
          width: 140,
          height: 180,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ShaderMask(
                blendMode: BlendMode.overlay,
                shaderCallback: (Rect bounds) {
                  return AppColors.gradientImgOverlay.createShader(bounds);
                },
                child: getBackgroundImage(),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.routePublicProfileScreen,
                            arguments: {AppConsts.keyUser: widget.user});
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12.0, top: 16.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(2.5),
                                      height: 41,
                                      width: 41,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: (widget.user.stories
                                                            ?.length ??
                                                        0) >
                                                    0
                                                ? (widget.user.stories?.last
                                                            .seenStory ??
                                                        false)
                                                    ? Colors.grey
                                                    : AppColors.kPrimaryColor
                                                : Colors.transparent,
                                            width: 2),
                                      ),
                                      child: CommonImageWidget(
                                        borderRadius: 100,
                                        url: widget.user.image ?? "",
                                      )),
                                ),
                                if (widget.user.superLike == 1 &&
                                    widget.connectionType ==
                                        ConnectionType.likedMe)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: SvgPicture.asset(
                                          AppIcons.icLoveEyesEmoji,
                                          height: 12,
                                        )),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          CommonOptionsBottomSheet.show(
                              height: 200.0,
                              options: [
                                OptionModel(
                                    widget.connectionType ==
                                            ConnectionType.likedMe
                                        ? 'like'.tr
                                        : widget.connectionType ==
                                                ConnectionType.iLiked
                                            ? 'unlike'
                                            : "unmatch".tr,
                                    () => _connectionsController
                                        .toggleLike(widget.user.id ?? '')),
                                OptionModel("block", () {
                                  AppAlerts.blockUserAlert(
                                      user: widget.user,
                                      onBlockTap: () {
                                        _connectionsController.toggleBlock(
                                            userId: widget.user.id ?? '',
                                            isBlocked: true);
                                      });
                                }),
                                OptionModel(
                                    "report",
                                    () => Get.toNamed(
                                            AppRoutes.routeReportScreen,
                                            arguments: {
                                              AppConsts.keyUser: widget.user
                                            }))
                              ]);
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          weight: 0.5,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.user.fullName ?? 'NA',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.fontMultiplier,
                              color: Colors.white),
                    ).paddingSymmetric(horizontal: 10),
                    if (widget.connectionType == ConnectionType.mutual)
                      _ChatBtnWidget(
                        user: widget.user,
                        width: widget.width,
                      )
                    else if (widget.connectionType == ConnectionType.likedMe)
                      _LikeBtnWidget(
                        user: widget.user,
                        width: widget.width,
                      )
                    else if (widget.connectionType == ConnectionType.iLiked)
                      _LikedActionWidget(
                        user: widget.user,
                        width: widget.width,
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBtnWidget extends StatefulWidget {
  const _ChatBtnWidget({required this.user, this.width});

  final User user;
  final double? width;

  @override
  State<_ChatBtnWidget> createState() => _ChatBtnWidgetState();
}

class _ChatBtnWidgetState extends State<_ChatBtnWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          setState(() {
            loading = true;
          });
          ChatController controller = Get.find<ChatController>();
          String? roomId = await controller.createRoom(widget.user.id ?? "");
          ChatDialog? roomDetail = await controller.getRoomDetail(roomId ?? "");
          if (roomDetail != null) {
            // ChatDialog dialog = ChatDialog(
            //     id: roomDetail.id,
            //     userName: roomDetail.userName,
            //     fullName: roomDetail.fullName,
            //     image: roomDetail.image,
            //     chatMessage: Message(room: roomId)
            // );
            controller.selectedChatDialog = roomDetail;
            Get.toNamed(AppRoutes.routeChatScreen, arguments: {
              'isOnline': controller.selectedChatDialog?.isOnline ?? false
            });

            //
          }
        } finally {
          setState(() {
            loading = false;
          });
        }
      },
      child: _CommonBtnBg(
        width: widget.width,
        child: loading
            ? const CommonProgressBar(
                size: 12,
                strokeWidth: 2,
              )
            : Container(
                height: 35,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppIcons.icChatFilled,
                      width: 14,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'chat'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 12.fontMultiplier, color: Colors.white),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class _LikeBtnWidget extends StatefulWidget {
  const _LikeBtnWidget({required this.user, this.width});

  final User user;
  final double? width;

  @override
  State<_LikeBtnWidget> createState() => _LikeBtnWidgetState();
}

class _LikeBtnWidgetState extends State<_LikeBtnWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          setState(() {
            loading = true;
          });

          await Get.find<ConnectionsController>()
              .toggleLike(widget.user.id ?? '');
        } finally {
          setState(() {
            loading = false;
          });
        }
      },
      child: _CommonBtnBg(
        width: widget.width,
        child: loading
            ? const CommonProgressBar(
                size: 12,
                strokeWidth: 2,
              )
            : Container(
                height: 35,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppIcons.icAppHeartRed,
                      width: 14,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'like'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 12.fontMultiplier, color: Colors.white),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

//Btn for profiles i liked
class _LikedActionWidget extends StatefulWidget {
  const _LikedActionWidget({required this.user, this.width});

  final User user;
  final double? width;

  @override
  State<_LikedActionWidget> createState() => _LikedActionWidgetState();
}

class _LikedActionWidgetState extends State<_LikedActionWidget> {
  bool loadingLike = false;
  bool loadingChat = false;
  bool loadingCenterStage = false;
  bool loadingHangout = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: _CommonBtnBg(
          width: widget.width,
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(
                color: Colors.white,
              ),
              popupMenuTheme: PopupMenuThemeData(),
            ),
            child: PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 18,
                      child: loadingChat
                          ? const CommonProgressBar(
                              size: 12,
                              strokeWidth: 2,
                            )
                          : Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.icInstantChat2,
                                  width: 14,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'instant_chat'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontSize: 12.fontMultiplier,
                                          color: Colors.white),
                                )
                              ],
                            ),
                    )),
                PopupMenuDivider(
                  height: 1,
                ),
                if (widget.user.superLike != 1)
                  PopupMenuItem(
                      value: 2,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 18,
                        child: loadingLike
                            ? const CommonProgressBar(
                                size: 12,
                                strokeWidth: 2,
                              )
                            : Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.icLoveEyesEmoji,
                                    width: 14,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'crush'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontSize: 12.fontMultiplier,
                                            color: Colors.white),
                                  )
                                ],
                              ),
                      )),
                if (widget.user.superLike != 1)
                  PopupMenuDivider(
                    height: 1,
                  ),
                PopupMenuItem(
                    value: 3,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 18,
                      child: loadingHangout
                          ? const CommonProgressBar(
                              size: 13,
                              strokeWidth: 2,
                            )
                          : Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcons.icGlassSvg,
                                  width: 13,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'hangout'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                          fontSize: 12.fontMultiplier,
                                          color: Colors.white),
                                )
                              ],
                            ),
                    )),
                if (widget.user.isCenterStage != 1)
                  PopupMenuDivider(
                    height: 1,
                  ),
                if (widget.user.isCenterStage != 1)
                  PopupMenuItem(
                      value: 4,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 18,
                        child: loadingCenterStage
                            ? const CommonProgressBar(
                                size: 12,
                                strokeWidth: 2,
                              )
                            : Row(
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.icStarCenterStage,
                                    width: 14,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'center_stage'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            fontSize: 12.fontMultiplier,
                                            color: Colors.white),
                                  )
                                ],
                              ),
                      )),
              ],
              padding: EdgeInsets.zero,
              icon: Container(
                height: 35,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.moreIcon,
                      height: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'more'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 12.5.fontMultiplier, color: Colors.white),
                    ),
                  ],
                ),
              ),
              position: PopupMenuPosition.under,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              popUpAnimationStyle: AnimationStyle(
                  curve: Curves.ease, duration: const Duration(milliseconds: 800)),
              color: Colors.black54,
              elevation: 4,
              onSelected: (value) async {
                if (value == 1) {
                  if (Helpers.canUsePremium(PremiumType.instantChat)) {
                    try {
                      setState(() {
                        loadingChat = true;
                      });
                      ChatController controller = Get.find<ChatController>();
                      String? roomId =
                          await controller.createRoom(widget.user.id ?? "");
                      ChatDialog? roomDetail =
                          await controller.getRoomDetail(roomId ?? "");
                      if (roomDetail != null) {
                        controller.selectedChatDialog = roomDetail;
                        Get.toNamed(AppRoutes.routeChatScreen, arguments: {
                          'isOnline':
                              controller.selectedChatDialog?.isOnline ?? false
                        });
                        Get.find<ProfileController>().getUserProfile();
                      }
                    } finally {
                      setState(() {
                        loadingChat = false;
                      });
                    }
                  } else {
                    Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                  }
                } else if (value == 2) {
                  if (Helpers.canUsePremium(PremiumType.crush)) {
                    //superLike
                    try {
                      setState(() {
                        loadingLike = true;
                      });
                      widget.user.superLike =
                          await Get.find<ConnectionsController>()
                              .superLike(widget.user.id ?? '');
                    } finally {
                      setState(() {
                        loadingLike = false;
                      });
                    }
                  } else {
                    Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                  }
                } else if (value == 3) {
                  if (Helpers.canUsePremium(PremiumType.dateRequest)) {
                    //superLike
                    try {
                      setState(() {
                        loadingHangout = true;
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
                        loadingHangout = false;
                      });
                    }
                  } else {
                    Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                  }
                } else if (value == 4) {
                  if (Helpers.canUsePremium(PremiumType.centerStage)) {
                    CenterStageBottomSheet.show(
                        user: User(
                          id: widget.user.id,
                          userName: widget.user.userName,
                          fullName: widget.user.fullName,
                          image: widget.user.image,
                        ),
                        onActivate: () async {
                          Get.back();
                          try {
                            setState(() {
                              loadingCenterStage = true;
                            });
                            var result =
                                await PostRequests.centerStage(widget.user.id!);
                            if (result != null) {
                              widget.user.isCenterStage = 1;
                              Get.find<ProfileController>().getUserProfile();
                              setState(() {
                                loadingCenterStage = false;
                              });
                            }
                          } on Exception catch (e) {
                            debugPrint(e.toString());
                          }
                        });
                  } else {
                    Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                  }
                }
              },
            ),
          )),
    );
  }
}

class _CommonBtnBg extends StatelessWidget {
  const _CommonBtnBg({required this.child, this.width});

  final Widget child;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 140,
      height: 35,
      margin: const EdgeInsets.only(top: 8),
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //   gradient: AppColors.gradientBlurOverlay,
      // ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), child: child),
      ),
    );
  }
}
