import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/message_sent_res_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/bottomsheets/hangout_request_bottom_sheet.dart';
import 'package:streax/views/pages/chat/components/chat_app_bar.dart';
import 'package:streax/views/pages/chat/components/chat_time_list_tile.dart';
import 'package:streax/views/pages/chat/components/message_list_tile.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = Get.find<ChatController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.arguments != null) {
        _chatController.isOnline.value = Get.arguments['isOnline'];
        _chatController.isStreaxChat.value = Get.arguments['isStreaxChat'] ?? false;
        _chatController.isFromHome.value = Get.arguments['fromHome'] ?? false;
      }
      if(_chatController.isStreaxChat.value == true){
        _chatController.getTeamStreaxChat();
      }else{
        _chatController.getRoomChat();
        _chatController.readMessages();
        _chatController.messages.refresh();
      }
      _chatController.chatState(ChatState.allowChat);
      _chatController.chatPageNum = 0;
      _chatController.messages.clear();
    });

    _chatController.socket?.on('message', (data) {
      try {
        debugPrint("DataInSocket = $data");
        MessageSentResModel model =
            messageSentResModelFromJson(json.encode(data));
        if (model.chatMessage != null) {
          _chatController.messages.add(model.chatMessage!);
          _chatController.messages.refresh();
          _chatController.scrollToEnd();
        }

        // var locationId = data['data']['location'];
        //  debugPrint("location_id = $locationId");

        // if (locationId == PreferenceManager.restaurantLocation?.id) {
        //  getOrders();
        //  }
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void dispose() {
    _chatController.socket?.off('message');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: ChatAppBar(),
          body: Column(
            children: [
              Expanded(
                child: Obx(
                  () => GroupedListView(
                      controller: _chatController.scrollController,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elements: _chatController.messages.value,
                      groupBy: (Message element) =>
                          DateUtils.dateOnly(element.time ?? DateTime.now()),
                      groupSeparatorBuilder: (DateTime? groupByValue) =>
                          ChatTimeListTile(dateTime: groupByValue),
                      itemComparator: (message1, message2) =>
                          message1.time != null && message2.time != null
                              ? message1.time!.compareTo(message2.time!)
                              : 0,
                      itemBuilder: (context, element) {
                        return MessageListTile(
                          message: element,
                          userType: element.user?.id == PreferenceManager.user?.id
                              ? ChatUserType.local
                              : ChatUserType.remote,
                          isSeen: element.isSeenStatus!,
                        );
                      }),
                ),
              ),
              BottomBar(
                controller: _chatController,
              )
            ],
          ),
        );
      }
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.controller});

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.chatState.value) {
        case ChatState.pendingRequest:
          // return const RequestPendingWidget();
          // ChatBottomBar(chatController: controller);
          return const RequestPendingWidget();
        case ChatState.acceptRequest:
          return ChatRequestBottomBar(chatController: controller);
        case ChatState.allowChat:
          return ChatBottomBar(chatController: controller);
        case ChatState.adminChat:
          return const SizedBox.shrink();
        default:
          return const SizedBox.shrink();
      }
    });

    // return GetBuilder<ChatController>(builder: (ChatController controller) {
    //   debugPrint("ControllerCalled");
    //
    // });
  }
}

class ChatBottomBar extends StatelessWidget {
  const ChatBottomBar({super.key, required this.chatController});

  final ChatController chatController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(
            color: AppColors.dividerColor,
            height: 0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      if (!chatController.isLoadingMedia.value) {
                        chatController.pickMedia();
                      }
                    },
                    customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() => chatController.isLoadingMedia.value
                          ? const CommonProgressBar(
                              size: 24,
                              strokeWidth: 2,
                            )
                          : SvgPicture.asset(AppIcons.icCameraOutlined)),
                    )),
                InkWell(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (Helpers.canUsePremium(PremiumType.dateRequest)) {
                        HangoutRequestBottomSheet.show(
                            user: User(
                          id: chatController.selectedChatDialog?.id,
                          userName: chatController.selectedChatDialog?.userName,
                          fullName: chatController.selectedChatDialog?.fullName,
                          image: chatController.selectedChatDialog?.image,
                        ));
                      } else {
                        Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                      }
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppIcons.icGlassSvg),
                    )),
                Expanded(
                  child: CommonInputField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: chatController.messageTextController,
                      hint: 'type_here'.tr),
                ),
                IconButton(
                    onPressed: () {
                      chatController.sendTextMessage();
                    },
                    icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            shape: BoxShape.circle),
                        child: SvgPicture.asset(AppIcons.icPlaneSvg)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatRequestBottomBar extends StatelessWidget {
  ChatRequestBottomBar({
    super.key,
    required this.chatController,
  });

  final ChatController chatController;

  RxBool isLoadingBlock = false.obs;
  RxBool isLoadingAccept = false.obs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
              height: 40,
              backgroundColor: AppColors.colorC2,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              text: 'block'.tr,
              isLoading: isLoadingBlock,
              onPressed: () {
                var user = User(
                  id: chatController.selectedChatDialog?.id,
                  userName: chatController.selectedChatDialog?.userName,
                  fullName: chatController.selectedChatDialog?.fullName,
                );
                AppAlerts.blockUserAlert(
                    user: user,
                    onBlockTap: () {
                      try {
                        isLoadingBlock.value = true;
                        var connectionsController =
                            Get.find<ConnectionsController>();
                        connectionsController.toggleBlock(
                            userId: user.id ?? "", isBlocked: true);
                        Navigator.of(context).pop();
                        chatController.getChatRequests();
                      } finally {
                        isLoadingBlock.value = false;
                      }
                    });

                //  _connectionController.blockUser(user);
              }),
        ),
        // contact.appdeft@gmail.com
        Expanded(
          child: CommonButton(
              height: 40,
              isLoading: isLoadingAccept,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              text: 'accept'.tr,
              onPressed: () async {
                try {
                  isLoadingAccept.value = true;
                  await chatController.acceptChatRequest();
                  chatController.getChatRequests();
                } finally {
                  isLoadingAccept.value = false;
                }
              }),
        )
      ],
    );
  }
}

class RequestPendingWidget extends StatelessWidget {
  const RequestPendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.kPrimaryColor.withOpacity(0.2),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        'message_request_pending'.tr,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 14.fontMultiplier, color: AppColors.kPrimaryColor),
      ),
    );
  }
}
