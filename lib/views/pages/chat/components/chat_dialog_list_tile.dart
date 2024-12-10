import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class ChatDialogListTile extends StatelessWidget {
  const ChatDialogListTile(
      {super.key, required this.chatDialog, required this.onTap});

  final ChatDialog chatDialog;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CommonImageWidget(
                  url: chatDialog.image,
                  width: 50,
                  height: 50,
                  borderRadius: 100,
                ),
                if (chatDialog.isOnline == true)
                  Positioned(
                    right: 5,
                    bottom: 1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppColors.colorGreen),
                    ),
                  )
                else
                  SizedBox(),
              ],
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        chatDialog.fullName ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 14.fontMultiplier,
                                fontWeight: FontWeight.w600,
                                color: AppColors.colorTextPrimary),
                      ),
                      const Gap(8),
                      chatDialog.role == "ADMIN"
                          ? SizedBox()
                          : (chatDialog.streak ?? 0) >= 2
                              ? Row(
                                  children: [
                                    Image.asset(
                                      AppIcons.icStreak,
                                      height: 15,
                                    ),
                                    const Gap(3),
                                    Text("${(chatDialog.streak ?? 0) - 1}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                    const Gap(3),
                                    (chatDialog.streakReminder ?? false)
                                        ? Image.asset(
                                      AppIcons.icSandGlass,
                                      height: 12,
                                    )
                                        : SizedBox(),
                                  ],
                                )
                              : SizedBox()
                    ],
                  ),
                  LastMessage(dialog: chatDialog),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      Helpers.getTimeAgo(chatDialog.chatMessage?.time),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 10.fontMultiplier,
                              color: AppColors.color6F),
                    ),
                    InkWell(
                      onTap: () {
                        CommonOptionsBottomSheet.show(options: [
                          OptionModel('block'.tr, () {
                            Get.find<ChatController>().blockUser(chatDialog);
                          }),
                          OptionModel('report'.tr, () {
                            Get.toNamed(AppRoutes.routeReportScreen,
                                arguments: {
                                  AppConsts.keyUser: User(
                                      id: chatDialog.id,
                                      userName: chatDialog.userName,
                                      fullName: chatDialog.fullName)
                                });
                          }),
                        ]);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.more_vert_rounded,
                          size: 18,
                          color: AppColors.color6F,
                        ),
                      ),
                    )
                  ],
                ),
                (chatDialog.unreadMessage ?? 0) > 0
                    ? Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        decoration: const BoxDecoration(
                            color: AppColors.kPrimaryColor,
                            shape: BoxShape.circle),
                        child: Text(
                          (chatDialog.unreadMessage ?? '').toString(),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 10.fontMultiplier,
                                color: Colors.white,
                              ),
                        ),
                      )
                    : const SizedBox(
                        height: 24,
                        width: 24,
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LastMessage extends StatelessWidget {
  const LastMessage({super.key, required this.dialog});
  final ChatDialog dialog;

  @override
  Widget build(BuildContext context) {
    MessageType? type = dialog.chatMessage?.type;
    Message? message = dialog.chatMessage;
    return Text(
      type == MessageType.text
          ? message?.message ?? ""
          : type == MessageType.hangoutRequest
              ? 'hangout_request'.tr
              : type == MessageType.story
                  ? 'sent_story_comment'.tr
                  : type == MessageType.video || type == MessageType.image
                      ? 'media'.tr
                      : '',
      maxLines: 2,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: (dialog.unreadMessage ?? 0) > 0
              ? 12.5.fontMultiplier
              : 12.fontMultiplier,
          color: AppColors.colorTextSecondary,
          fontWeight: (dialog.unreadMessage ?? 0) > 0
              ? FontWeight.w700
              : FontWeight.w400),
    );
  }
}
