import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/story/story.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class StoryActionWidget extends StatefulWidget {
  //if viewing another persons story

  StoryActionWidget({
    super.key,
    required this.connectionType,
    required this.story,
    required this.user,
    this.onInstantChatTap,
    this.onSuperLikeTap,
  });

  final ConnectionType connectionType;
  final VoidCallback? onInstantChatTap;
  final VoidCallback? onSuperLikeTap;
  final User user;
  final Story story;

  @override
  State<StoryActionWidget> createState() => _StoryActionWidgetState();
}

class _StoryActionWidgetState extends State<StoryActionWidget> {
  final TextEditingController controller = TextEditingController();

  bool isLoading = false;
  bool chatLoading = false;
  bool loadingLike = false;

  Future<bool> addCommentOnStory(
      String? message, String? roomId, String? storyId) async {
    if (storyId == null || roomId == null) return false;

    bool isCommentSent = false;

    Map<String, dynamic> requestBody = {
      "message": message,
      "story": storyId,
      "instantChat": false,
      "type": messageTypeValues.reverse[
          MessageType.story], //["IMAGE", "VIDEO", "AUDIO", "LOCATION", "TEXT"],
    };
    try {
      var result = await PostRequests.sendMessage(roomId, requestBody);
      if (result != null) {
        if (result.success) {
          isCommentSent = true;
          AppAlerts.success(message: '${'sent'.tr}...');
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {}

    return isCommentSent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.centerRight,
      child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(50)),

          //color: Colors.black,
          child: widget.connectionType == ConnectionType.mutual
              ? CommonInputField(
                  controller: controller,
                  hint: 'send_message'.tr,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: Colors.transparent,
                  margin: EdgeInsets.zero,
                  suffixIcon: isLoading
                      ? const SizedBox(
                          width: 20,
                          child: CommonProgressBar(
                            strokeWidth: 3,
                          ))
                      : InkWell(
                          onTap: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              var message = controller.text.toString().trim();
                              if (message.isNotEmpty) {
                                debugPrint('id=======> ${widget.user.id}');
                                var chatController =
                                    Get.put<ChatController>(ChatController());
                                String? roomId = await chatController
                                    .createRoom(widget.user.id ?? "");
                                bool isCommentSent = await addCommentOnStory(
                                    message, roomId, widget.story.id);
                                if (isCommentSent) {
                                  controller.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              }
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Container(
                              margin: const EdgeInsets.all(6),
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kPrimaryColor),
                              child: SvgPicture.asset(
                                AppIcons.icNavigation,
                              )),
                        ),
                )
              : widget.connectionType == ConnectionType.likedMe
                  ? InkWell(
                      onTap: () async {
                        debugPrint("OnLikeClick");
                        setState(() {
                          widget.user.iLiked = widget.user.iLiked == 1 ? 0 : 1;
                        });
                        int status = await Get.find<ConnectionsController>()
                            .toggleLike(widget.user.id ?? "");
                        setState(() {
                          widget.user.iLiked = status;
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              widget.user.iLiked == 0
                                  ? AppIcons.icHeartOutline
                                  : AppIcons.icHeartFilled,
                              height: 24,
                              color: AppColors.kPrimaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'like'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontSize: 14.fontMultiplier,
                                        color: AppColors.colorTextPrimary),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : widget.connectionType == ConnectionType.iLiked
                      ? //also add check if user having subscription
                      SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: chatLoading == true
                                            ? () {}
                                            : () async {
                                                if (Helpers.canUsePremium(
                                                    PremiumType.instantChat)) {
                                                  try {
                                                    setState(() {
                                                      chatLoading = true;
                                                    });
                                                    ChatController controller =
                                                        Get.find<
                                                            ChatController>();
                                                    String? roomId =
                                                        await controller
                                                            .createRoom(widget
                                                                    .user.id ??
                                                                "");
                                                    ChatDialog? roomDetail =
                                                        await controller
                                                            .getRoomDetail(
                                                                roomId ?? "");
                                                    if (roomDetail != null) {
                                                      controller
                                                              .selectedChatDialog =
                                                          roomDetail;
                                                      Get.toNamed(
                                                          AppRoutes
                                                              .routeChatScreen,
                                                          arguments: {
                                                            'isOnline': controller
                                                                    .selectedChatDialog
                                                                    ?.isOnline ??
                                                                false
                                                          });
                                                      Get.find<
                                                              ProfileController>()
                                                          .getUserProfile();
                                                    }
                                                  } finally {
                                                    setState(() {
                                                      chatLoading = false;
                                                    });
                                                  }
                                                } else {
                                                  Get.toNamed(AppRoutes
                                                      .routeOneTimePurchaseScreen);
                                                }
                                              },
                                        icon: SvgPicture.asset(
                                          AppIcons.icInstantChat2,
                                          height: 24,
                                        )),
                                    IconButton(
                                        onPressed: loadingLike == true
                                            ? () {}
                                            : () async {
                                                if (Helpers.canUsePremium(
                                                    PremiumType.crush)) {
                                                  //superLike
                                                  try {
                                                    setState(() {
                                                      loadingLike = true;
                                                    });
                                                    widget.user.superLike =
                                                        await Get.find<
                                                                ConnectionsController>()
                                                            .superLike(widget
                                                                    .user.id ??
                                                                '');
                                                  } finally {
                                                    setState(() {
                                                      loadingLike = false;
                                                    });
                                                  }
                                                } else {
                                                  Get.toNamed(AppRoutes
                                                      .routeOneTimePurchaseScreen);
                                                }
                                              },
                                        icon: SvgPicture.asset(
                                          AppIcons.icLoveEyesEmoji,
                                          height: 24,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink()),
    );
  }
}
