import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/story/story.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/custom_gallery/custom_media_picker.dart';
import 'package:streax/utils/custom_gallery/media_preview.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class MessageListTile extends StatelessWidget {
  const MessageListTile({
    super.key,
    required this.message,
    required this.userType,
    required this.isSeen,
  });

  final Message message;
  final ChatUserType userType;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        Get.find<ChatController>().selectedMessage.value = message;
        CommonOptionsBottomSheet.show(
            onPopInvoked: (value) {
              Get.find<ChatController>().selectedMessage.value = null;
            },
            options: [
              OptionModel('delete_for_me'.tr, () {
                Get.find<ChatController>()
                    .deleteMessage(message, DeleteMessageType.deleteForMe);
              }),
              if (userType == ChatUserType.local)
                OptionModel('delete_for_everyone'.tr, () {
                  Get.find<ChatController>().deleteMessage(
                      message, DeleteMessageType.deleteForEveryone);
                }),
              if (userType == ChatUserType.remote)
                            OptionModel('report'.tr, () async {
                              var data = await Get.toNamed(AppRoutes.routeReportScreen,
                                  arguments: {
                                "message" : message.id,
                                    AppConsts.keyUser: User(
                                        id: message.user?.id,
                                        userName: message.user?.userName,
                                        fullName: message.user?.fullName,
                                    )
                                  });
                              debugPrint('Data --> ${data}');
                              if(data != null){
                                Get.back();
                              }
                            }),
            ]);
      },
      child: Obx(
        () => Container(
          color:
              Get.find<ChatController>().selectedMessage.value?.id == message.id
                  ? AppColors.kPrimaryColor.withOpacity(0.1)
                  : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          margin: const EdgeInsets.symmetric(vertical: 4),
          width: double.infinity,
          child: userType == ChatUserType.remote
              ? RemoteMessage(message: message)
              : LocalMessage(
                  message: message,
                  isSeen: isSeen,
                ),
        ),
      ),
    );
  }
}

class LocalMessage extends StatelessWidget {
  const LocalMessage({super.key, required this.message, required this.isSeen});

  final Message message;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: SizeConfig.widthMultiplier * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.type == MessageType.text)
                TextMessage(userType: ChatUserType.local, message: message),
              if (message.type == MessageType.video ||
                  message.type == MessageType.image)
                MediaWidget(
                  message: message,
                  userType: ChatUserType.local,
                ),
              if (message.type == MessageType.hangoutRequest)
                HangoutReqListTile(
                  message: message,
                  userType: ChatUserType.local,
                ),
              if (message.type == MessageType.story)
                StoryCommentWidget(
                    userType: ChatUserType.local, message: message),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isSeen
                      ? Text(
                          'Seen',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 12.fontMultiplier,
                                  color: AppColors.color6F),
                        )
                      : SizedBox(),
                  TimeWidget(
                    dateTime: message.time,
                    isSeen: isSeen,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class RemoteMessage extends StatelessWidget {
  const RemoteMessage({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonImageWidget(
          url: Get.find<ChatController>().selectedChatDialog?.image ?? '',
          height: 40,
          width: 40,
          borderRadius: 100,
        ),
        const Gap(8),
        Container(
          constraints:
              BoxConstraints(maxWidth: SizeConfig.widthMultiplier * 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.type == MessageType.text)
                TextMessage(userType: ChatUserType.remote, message: message),
              if (message.type == MessageType.video ||
                  message.type == MessageType.image)
                MediaWidget(
                  message: message,
                  userType: ChatUserType.local,
                ),
              if (message.type == MessageType.hangoutRequest)
                HangoutReqListTile(
                  message: message,
                  userType: ChatUserType.remote,
                ),
              if (message.type == MessageType.story)
                StoryCommentWidget(
                    userType: ChatUserType.remote, message: message),
              TimeWidget(
                dateTime: message.time,
                isSeen: false,
              )
            ],
          ),
        )
      ],
    );
  }
}

class MessageBackground extends StatelessWidget {
  const MessageBackground(
      {super.key, required this.userType, required this.child});

  final ChatUserType userType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 100),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(userType == ChatUserType.local ? 16 : 0),
            topRight: Radius.circular(userType == ChatUserType.local ? 0 : 16),
            bottomLeft: const Radius.circular(16),
            bottomRight: const Radius.circular(16),
          ),
          color: userType == ChatUserType.local
              ? AppColors.kPrimaryColor
              : AppColors.colorCE),
      child: child,
    );
  }
}

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key, required this.dateTime, required this.isSeen});

  final DateTime? dateTime;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: SizedBox(
        height: 10,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: DateFormat('hh:mm aa')
                  .format(dateTime?.toLocal() ?? DateTime.now()),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 10.fontMultiplier,
                  color: AppColors.color6F,
                  height: 0),
            ),
          ]),
        ),
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage({super.key, required this.userType, required this.message});

  final Message message;
  final ChatUserType userType;

  @override
  Widget build(BuildContext context) {
    return MessageBackground(
        userType: userType,
        child: Text(
          message.message ?? "",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 14.fontMultiplier,
              color: userType == ChatUserType.local
                  ? Colors.white
                  : AppColors.color6F),
        ));
  }
}

class MediaWidget extends StatelessWidget {
  const MediaWidget({super.key, required this.message, required this.userType});

  final Message message;
  final ChatUserType userType;

  Widget cameraMediaWidget(BuildContext context, Message message) {
    return MessageBackground(
      userType: userType,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            message.type == MessageType.image
                ? Icons.image_rounded
                : Icons.play_arrow_rounded,
            size: 24,
            color: (message.isMediaViewed ?? false)
                ? Colors.white.withOpacity(0.5)
                : Colors.white,
          ),
          Text(
            message.type == MessageType.image ? 'photo'.tr : 'video'.tr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 14.fontMultiplier,
                color: (message.isMediaViewed ?? false)
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if ((message.camera ?? false) && (message.isMediaViewed ?? false)) {
          return;
        }
        if ((message.camera ?? false) && message.user?.id == PreferenceManager.user?.id) {
          return;
        }
        Get.find<ChatController>().viewChatMedia(message.id ?? '');
        MediaPreview.preview(
          media: MediaData(
              mediaPath: message.story != null ? message.story?.mediaUrl : Helpers.getCompleteUrl(message.mediaUrl),
              mediaType: message.type == MessageType.image
                  ? MediaType.image
                  : MediaType.video,
              mediaDuration: AppConsts.defaultMediaDuration),
        );
        message.isMediaViewed = true;
      },
      child: (message.camera ?? false)
          ? cameraMediaWidget(context, message)
          : Stack(
              alignment: Alignment.center,
              children: [
                CommonImageWidget(
                  width: 120,
                  height: 200,
                  url:  message.story != null ? Helpers.getCompleteUrl(message.story?.thumbnail) : Helpers.getCompleteUrl(message.thumbnail),
                  borderRadius: 8,
                ),
                if (message.type == MessageType.video)
                  Container(
                      height: 32,
                      width: 32,
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.kPrimaryColor),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 24,
                        color: Colors.white,
                      ))
              ],
            ),
    );
  }
}

class HangoutReqListTile extends StatelessWidget {
  const HangoutReqListTile(
      {super.key, required this.message, required this.userType});

  final Message message;
  final ChatUserType userType;

  String getTitle(ChatUserType chatUserType) {
    if (userType == ChatUserType.local) {
      return '${'you_have_invited'.tr} ${Get.find<ChatController>().selectedChatDialog?.fullName ?? ""} ${'to_hangout'.tr}';
    } else {
      return '${Get.find<ChatController>().selectedChatDialog?.fullName ?? ""} ${'wants_to_hangout'.tr}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Hangout? hangout = message.hangout;
    return Container(
      width: SizeConfig.screenWidth - 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade50, blurRadius: 4, spreadRadius: 4)
          ]),
      child: Column(
        children: [
          Text(
            getTitle(userType),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.kPrimaryColor,
                fontSize: 18.fontMultiplier),
          ),
          HangoutInfoTile(
            icon: AppIcons.icMarkerOutlined,
            text: hangout?.location != '' ? "${hangout?.place ?? ''} \n${hangout?.location ?? ''}" : hangout?.place ?? '',
          ),
          HangoutInfoTile(
            icon: AppIcons.icCalender,
            text: DateFormat('MMM dd').format(hangout?.date ?? DateTime.now()),
          ),
          HangoutInfoTile(
            icon: AppIcons.icClock,
            text:
                DateFormat('hh:mm aa').format(hangout?.date ?? DateTime.now()),
          ),
          hangout?.comment != '' ? HangoutInfoTile(
            icon: AppIcons.icComment,
            text: hangout?.comment ?? '',
          ) : Container()
        ],
      ),
    );
  }
}

class HangoutInfoTile extends StatelessWidget {
  const HangoutInfoTile({super.key, required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: const ColorFilter.mode(
                AppColors.kPrimaryColor, BlendMode.srcIn),
            height: 18,
          ),
          const Gap(8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 14.fontMultiplier,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorTextPrimary),
            ),
          )
        ],
      ),
    );
  }
}

class StoryCommentWidget extends StatelessWidget {
  const StoryCommentWidget(
      {super.key, required this.userType, required this.message});

  final ChatUserType userType;
  final Message message;

  @override
  Widget build(BuildContext context) {
    Story? story = message.story;
    return SizedBox(
      height: 200,
      width: 120,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                MediaPreview.preview(
                  media: MediaData(
                      mediaPath: Helpers.getCompleteUrl(story?.mediaUrl),
                      mediaType: message.story?.mediaType == MediaType.image
                          ? MediaType.image
                          : MediaType.video,
                      mediaDuration: AppConsts.defaultMediaDuration),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CommonImageWidget(
                    width: 120,
                    height: 200,
                    url: story?.thumbnail,
                    borderRadius: 8,
                  ),
                  if (message.type == MessageType.video)
                    Container(
                        height: 32,
                        width: 32,
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.kPrimaryColor),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          size: 24,
                          color: Colors.white,
                        ))
                ],
              ),
            ),
          ),
          message.message != null
              ? Align(
                  alignment: userType == ChatUserType.local
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: MessageBackground(
                    userType: userType,
                    child: Text(
                      message.message ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 14.fontMultiplier,
                              color: userType == ChatUserType.local
                                  ? Colors.white
                                  : AppColors.color6F),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
