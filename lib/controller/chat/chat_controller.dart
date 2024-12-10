import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/network/post_requests.dart';
import 'package:streax/network/put_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/custom_gallery/custom_media_picker.dart';
import 'package:streax/utils/custom_gallery/media_preview.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/utils/socket_helper.dart';
import 'package:streax/views/dialogs/common/common_alert_dialog.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatController extends GetxController {
  //final isLoading = RxBool(false);
  Rx<ChatState?> chatState = Rx<ChatState?>(null);
  final isLoading = false.obs;
  final isLoadingMedia = false.obs;
  final isOnline = false.obs;
  final isStreaxChat = false.obs;
  final isFromHome = false.obs;
  final List<ChatDialog> chatDialogs = [];
  final filteredChatDialogs = <ChatDialog>[].obs;
  final chatRequests = <ChatDialog>[].obs;
  final messages = <Message>[].obs;
  final selectedMessage = Rx<Message?>(null);

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  late ScrollController scrollController;

  late TextEditingController searchTextController;
  late TextEditingController messageTextController;

  IO.Socket? socket;
  ChatDialog? selectedChatDialog;

  int chatPageNum = 0;

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
    initScrollController();
    socket = SocketHelper.getInstance();
    debugPrint('Room created');

    socket?.on('dialogs', (data) {
      try {
        debugPrint('Room created');
        getChatDialogs();
      } on Exception catch (e) {
        debugPrint('Room created $e');
      }
    });

    if (Get.arguments != null) {
      if (Get.arguments['isOnline'] != null) {
        isOnline.value = Get.arguments['isOnline'] ?? false;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    getChatDialogs();
    getChatRequests();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }

  void initTextEditingControllers() {
    searchTextController = TextEditingController();
    messageTextController = TextEditingController();
    searchTextController.addListener(() {
      var keyword = searchTextController.text.toString().trim();
      if (keyword.isEmpty) {
        filteredChatDialogs.assignAll(chatDialogs);
      } else {
        List<ChatDialog> filteredList = chatDialogs
            .where((element) => (element.userName ?? '')
                .toLowerCase()
                .contains(keyword.toLowerCase()))
            .toList();
        filteredChatDialogs.assignAll(filteredList);
      }
    });
  }

  seenStatus() {
    if (messages.isNotEmpty) {
      debugPrint('=====> ${jsonEncode(messages.first)}');
      if (messages.first.user?.id == PreferenceManager.user?.id) {
        var lastMessages = messages.takeWhile((messageElement) =>
            messageElement.user?.id == PreferenceManager.user?.id);

        if (lastMessages.isNotEmpty) {
          var lastSeenMessage = lastMessages.firstWhere(
              (localMessageListElement) =>
                  localMessageListElement.isSeen == true,
              orElse: () => Message());
          debugPrint('===> lastSeenMessage ${lastSeenMessage.isSeen}');
          debugPrint('===> lastSeenMessage ${lastSeenMessage.message}');
          if (lastSeenMessage.id != null) {
            for (var element in messages) {
              if (element.id == lastSeenMessage.id) {
                element.isSeenStatus = true;
              } else {
                element.isSeenStatus = false;
              }
            }
          }
        }
      }
    }
    messages.refresh();
  }

  disposeTextEditingControllers() {
    searchTextController.dispose();
    messageTextController.dispose();
  }

  initScrollController() {
    scrollController = ScrollController();
    scrollController.addListener(() => loadMoreChat());
    // scrollController.addListener(() {
    //
    //
    //   //
    //   // if(scrollController.position.atEdge){
    //   //   bool isTop = scrollController.position.pixels ==0;
    //   //   if(isTop){
    //   //     debugPrint('At Top');
    //   //   }else{
    //   //     debugPrint('At Bottom');
    //   //   }
    //   // }
    // });
  }

  loadMoreChat() {
    if (scrollController.position.pixels ==
        scrollController.position.minScrollExtent) {
      chatPageNum = chatPageNum + 1;
      debugPrint("Load More For page $chatPageNum");
      if (isStreaxChat.value) {
        getTeamStreaxChat();
      } else {
        getRoomChat();
      }
    }
  }

  refreshDialogs() {
    getChatDialogs();
  }

  getChatState() {
    var dialog = selectedChatDialog;
    if (dialog == null) {
      chatState(null);
      return;
    }

    debugPrint("dialog.iLiked = ${dialog.iLiked}");
    debugPrint("dialog.likedMe = ${dialog.likedMe}");
    if (dialog.iLiked == 1 && dialog.likedMe == 1) {
      chatState(ChatState.allowChat);
      return;
    }
    else if (dialog.likedMe == 1) {
      chatState(ChatState.acceptRequest);
      return;
    }
    else if (dialog.iLiked == 1 && messages.isNotEmpty) {
      chatState(ChatState.pendingRequest);
      return;
    }
    else {
      debugPrint("MessageIsEmpty  = ${messages.isEmpty}");
      if (messages.isNotEmpty) {
        debugPrint("firstMessageUserId = ${messages.first.id}");
        debugPrint("CurrentUserId = ${PreferenceManager.user?.id}");
        if (messages.first.user?.id == PreferenceManager.user?.id) {
          chatState(ChatState.pendingRequest);
          FocusManager.instance.primaryFocus?.unfocus();
        } else {
          chatState(ChatState.acceptRequest);
          FocusManager.instance.primaryFocus?.unfocus();
        }
      } else {
        chatState(null);
      }
    }

    debugPrint("ChatState=== ${chatState.value}");
  }

  getChatDialogs() async {
    try {
      if (filteredChatDialogs.isEmpty) {
        isLoading.value = true;
      }

      var result = await GetRequests.fetchChatDialogs();
      if (result != null) {
        if (result.success) {
          // var adminChatIndex = result.chatDialogs!
          //     .indexWhere((element) => element.role == "ADMIN");
          // if (adminChatIndex != -1) {
          //   result.chatDialogs![adminChatIndex].chatMessage?.type = MessageType.text;
          //   var adminChat = result.chatDialogs![adminChatIndex];
          //   result.chatDialogs!.removeAt(adminChatIndex);
          //   result.chatDialogs!.insert(0, adminChat);
          // }
          chatDialogs.assignAll(result.chatDialogs ?? []);
          filteredChatDialogs.assignAll(chatDialogs);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: "message_server_error".tr);
      }
    } finally {
      refreshController.refreshCompleted();
      isLoading.value = false;
    }
  }

  getStreakCount() async {
    var result = await GetRequests.streakCount();
    if (result != null) {
      if (result.success) {
      } else {
        AppAlerts.error(message: result.message);
      }
    } else {
      AppAlerts.error(message: "message_server_error".tr);
    }
  }

  getChatRequests() async {
    try {
      var result = await GetRequests.fetchChatRequests();
      if (result != null) {
        if (result.success) {
          chatRequests.assignAll(result.chatDialogs ?? []);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> createRoom(String userId) async {
    String? roomId;
    try {
      var result = await GetRequests.createRoom(userId);
      if (result != null) {
        if (result.success) {
          roomId = result.roomData?.id;
          debugPrint('Room created');
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }

    return roomId;
  }

  Future<ChatDialog?> getRoomDetail(String roomId) async {
    ChatDialog? roomDetail;
    try {
      var result = await GetRequests.fetchRoomDetail(roomId);
      if (result != null) {
        if (result.success) {
          roomDetail = result.dialog;
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }

    return roomDetail;
  }

  getRoomChat() async {
    try {
      isLoading.value = true;
      debugPrint("room id = ${selectedChatDialog?.roomId}");
      var result = await GetRequests.fetchRoomChat(
          selectedChatDialog?.roomId ?? "", chatPageNum);
      if (result != null) {
        if (result.success) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            List<Message> chat = result.messages ?? [];
            if (chatPageNum == 0) {
              messages.assignAll(chat);
              getChatState();
              scrollToEnd();
              seenStatus();
              if (isFromHome.value) {
                Get.find<HomeController>()
                    .checkForMatchRemove(selectedChatDialog?.id ?? '');
              }
            } else {
              messages.insertAll(0, chat);
              messages.refresh();
            }
            //List<Message> chat = (result.messages??[]).reversed.toList();
            // messages.assignAll(chat);
            //    messages.assignAll(result.messages??[]);
          });
          messages.refresh();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  getTeamStreaxChat() async {
    try {
      isLoading.value = true;
      var result = await GetRequests.teamStreaxChat();
      if (result != null) {
        if (result.success) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            List<Message> chat = result.messages ?? [];
            if (chatPageNum == 0) {
              messages.assignAll(chat);
              chatState(ChatState.adminChat);
              scrollToEnd();
            } else {
              messages.insertAll(0, chat);
              messages.refresh();
            }
          });
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: "message_server_error".tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 400), () {
      try {
        if (scrollController.hasClients) {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 1),
              curve: Curves.fastOutSlowIn);
        }
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  sendTextMessage() {
    String message = messageTextController.text.toString().trim();
    if (message.isEmpty) return;
    Map<String, dynamic> requestBody = {
      "message": message,
      "type": messageTypeValues.reverse[MessageType.text],
      "instantChat":
          (selectedChatDialog?.iLiked == 1 && selectedChatDialog?.likedMe == 1)
              ? false
              : true,
      //["IMAGE", "VIDEO", "AUDIO", "LOCATION", "TEXT"],
    };
    debugPrint("selectedChatDialog?.iLiked = ${selectedChatDialog?.iLiked}");
    debugPrint("selectedChatDialog?.likedMe = ${selectedChatDialog?.likedMe}");
    messageTextController.clear();
    _sendMessage(requestBody);
  }

  sendHangoutRequest(String requestId) {
    Map<String, dynamic> requestBody = {
      "hangoutRequest": requestId,
      "type": messageTypeValues.reverse[MessageType.hangoutRequest],
      "dateRequest": true,
      "instantChat": false,
      //["IMAGE", "VIDEO", "AUDIO", "LOCATION", "TEXT"],
    };

    _sendMessage(requestBody)
        .then((value) => Get.find<ProfileController>().getUserProfile());
  }

  sendMediaMessage(MediaData media) async {
    try {
      isLoadingMedia.value = true;
      String? mediaUrl = await uploadFile(media.mediaPath ?? "");

      String? thumbnailUrl;
      if (media.mediaType == MediaType.video) {
        String? thumbnailPath =
            await Helpers.createVideoThumbnail(media.mediaPath!);
        if (thumbnailPath != null) {
          thumbnailUrl = await uploadFile(thumbnailPath);
        }
      }
      Map<String, dynamic> requestBody = {
        "mediaUrl": mediaUrl,
        "thumbnail":
            media.mediaType == MediaType.image ? mediaUrl : thumbnailUrl,
        "type": messageTypeValues.reverse[media.mediaType == MediaType.image
            ? MessageType.image
            : MessageType.video],
        "instantChat": (selectedChatDialog?.iLiked == 1 &&
                selectedChatDialog?.likedMe == 1)
            ? false
            : true,
        'camera': media.mediaSource == MediaSource.camera ? true : false
        //["IMAGE", "VIDEO", "AUDIO", "LOCATION", "TEXT"],
      };
      _sendMessage(requestBody);
    } finally {
      isLoadingMedia.value = false;
    }
  }

  Future<void> _sendMessage(Map<String, dynamic> requestBody) async {
    try {
      var result = await PostRequests.sendMessage(
          selectedChatDialog?.roomId ?? '', requestBody);
      if (result != null) {
        if (result.success) {
          if (result.chatMessage != null) {
            if (result.chatMessage?.key == "Unmatched") {
              chatState.value = ChatState.pendingRequest;
            } else {
              debugPrint("Adding");
              messages.insert(
                  messages.isEmpty ? 0 : messages.length, result.chatMessage!);
              messages.refresh();
              seenStatus();
              getChatState();
              scrollToEnd();
            }
          }
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      Get.find<ProfileController>().getUserProfile();
    }
  }

  deleteMessage(Message message, DeleteMessageType deleteMessageType) async {
    try {
      Map<String, dynamic> requestBody = {
        if (deleteMessageType == DeleteMessageType.deleteForMe)
          "deleteForMe": true,
        if (deleteMessageType == DeleteMessageType.deleteForEveryone)
          "deleteEveryone": true,
      };
      debugPrint("RequestBody = $requestBody");
      messages.removeWhere((element) => element.id == message.id);
      await PutRequests.deleteMessage(message.id ?? "", requestBody);
    } finally {}
  }

  pickMedia() {
    CustomMediaPicker.pickMedia((media) => MediaPreview.preview(
        media: media,
        onDone: (MediaData media) async {
          sendMediaMessage(MediaData(
              mediaType: media.mediaType,
              mediaDuration: media.mediaDuration,
              mediaPath: media.mediaPath,
              mediaSource: media.mediaSource));
        },
        onRetake: () {
          pickMedia();
        }));
  }

  Future<String?> uploadFile(String path) async {
    String? mediaUrl;

    try {
      var result = await PostRequests.uploadFiles(paths: [path]);
      mediaUrl = result?.data?.first.name;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    return mediaUrl;
  }

  readMessages() async {
    debugPrint('RoomId = ${selectedChatDialog?.roomId ?? ''}');

    try {
      await GetRequests.readMessages(selectedChatDialog?.roomId ?? '');
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  blockUser(ChatDialog dialog) {
    CommonAlertDialog.showDialog(
        title: '${'block'.tr} ${dialog.userName}? ',
        message: 'message_block_user'.tr,
        negativeText: 'block',
        positiveText: 'dismiss'.tr,
        positiveBtCallback: () {
          Get.back();
        },
        negativeBtCallback: () {
          Get.back();
          _blockUnblock(dialog);
        });
  }

  _blockUnblock(ChatDialog dialog) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> requestBody = {
        "block": dialog.id,
      };

      var result = await PostRequests.blockUnBlock(requestBody);
      if (result != null) {
        if (result.success) {
          Get.back();
          chatDialogs.remove(dialog);
          Get.find<StoriesController>().getConnectionsStories();
          Get.find<ConnectionsController>().getConnections();
          getChatDialogs();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptChatRequest() async {
    try {
      Map<String, dynamic> requestBody = {
        "accept": true,
        "connection": selectedChatDialog?.id
      };
      var result = await PostRequests.acceptChatRequest(requestBody);
      if (result != null) {
        if (result.success) {
          selectedChatDialog?.likedMe = 1;
          selectedChatDialog?.iLiked = 1;
          getChatState();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  viewChatMedia(String messageId) async {
    try {
      await PutRequests.viewChatMedia(messageId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
