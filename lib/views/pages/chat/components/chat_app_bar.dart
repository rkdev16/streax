import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/model/chat_dialogs_res_model.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  ChatAppBar({super.key});

  final _chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    ChatDialog? dialog = _chatController.selectedChatDialog;

    return AppBar(
      leadingWidth: 0,
      scrolledUnderElevation: 0,
      leading: const SizedBox.shrink(),
      title: Container(
        decoration: BoxDecoration(),
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
                onPressed: () {
                  Get.find<ChatController>().getChatDialogs();
                  Get.find<DashBoardController>().fetchChatCount();
                  Get.find<DashBoardController>().messageCount.refresh();
                  Get.back();
                },
                icon: SvgPicture.asset(AppIcons.icBack,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn))),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CommonImageWidget(
                  url: dialog?.image,
                  height: 40,
                  width: 40,
                  borderRadius: 100,
                ),
                Obx(() => _chatController.isOnline.value == true
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.colorGreen),
                      )
                    : SizedBox()),
              ],
            ),
            const Gap(12),
            Obx(
              () => Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dialog?.fullName ?? '',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 16.fontMultiplier,
                          color: AppColors.colorTextPrimary),
                    ),
                    _chatController.isOnline.value == true
                        ? Text(
                            'active_now'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontSize: 12.fontMultiplier,
                                    color: AppColors.colorTextPrimary),
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                CommonOptionsBottomSheet.show(options: [
                  OptionModel('block'.tr, () {
                    Get.find<ChatController>().blockUser(dialog!);
                  }),
                  OptionModel('report'.tr, () async {
                    var data = await Get.toNamed(AppRoutes.routeReportScreen,
                        arguments: {
                          AppConsts.keyUser: User(
                              id: dialog!.id,
                              userName: dialog.userName,
                              fullName: dialog.fullName
                          )
                        });
                    debugPrint('Data --> ${data}');
                    if(data != null){
                      Get.back();
                    }
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
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(70);
}
