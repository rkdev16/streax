import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/chat/components/chat_dialog_list_tile.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

import '../../../config/app_colors.dart';
import '../../../controller/chat/chat_controller.dart';

class RecentChatDialogsScreen extends StatefulWidget {
  const RecentChatDialogsScreen({super.key});

  @override
  State<RecentChatDialogsScreen> createState() =>
      _RecentChatDialogsScreenState();
}

class _RecentChatDialogsScreenState extends State<RecentChatDialogsScreen> {
  final _chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CommonAppBar(
          systemUiOverlayStyle:
              SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
          backgroundColor: Colors.white,
          title: 'chat'.tr,
          centerTitle: false,
          leadingWidth: 16,
          titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 28.fontMultiplier,
              color: AppColors.colorTextPrimary,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter'),
          leading: const SizedBox.shrink(),
          actions: const [MessageRequestBtn()],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CommonInputField(
                leading: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SvgPicture.asset(
                    AppIcons.icSearch,
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                clearFieldEnable: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                // backgroundColor: AppColors.colorF6,
                controller: _chatController.searchTextController,
                hint: 'search'.tr),
            Expanded(
              child: Obx(
                () => _chatController.isLoading.value
                    ? const CommonProgressBar()
                    : _chatController.filteredChatDialogs.isEmpty
                        ? const EmptyScreenWidget()
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: false,
                            controller: _chatController.refreshController,
                            onRefresh: () {
                              _chatController.refreshDialogs();
                            },
                            child: SingleChildScrollView(
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  itemBuilder: (context, index) {
                                    var dialog = _chatController
                                        .filteredChatDialogs[index];

                                    return ChatDialogListTile(
                                      chatDialog: dialog,
                                      onTap: () {
                                        _chatController.selectedChatDialog =
                                            dialog;
                                        Get.toNamed(AppRoutes.routeChatScreen,
                                            arguments: {
                                              'isOnline': _chatController
                                                      .selectedChatDialog
                                                      ?.isOnline ??
                                                  false,
                                              'isStreaxChat': _chatController
                                                      .selectedChatDialog
                                                      ?.role == 'ADMIN' ? true :
                                                  false
                                            });
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const Gap(16);
                                  },
                                  itemCount: _chatController
                                      .filteredChatDialogs.length),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageRequestBtn extends StatelessWidget {
  const MessageRequestBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(()=> TextButton(
            onPressed: () {
              Get.toNamed(AppRoutes.routeChatRequestsScreen);
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            child: Text(
              '${'requests'.tr}(${(Get.find<DashBoardController>().messageCount.value.requestCount ?? 0) > 0 ? Get.find<DashBoardController>().messageCount.value.requestCount : '0'})',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16.fontMultiplier,
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeight.w700),
            )),
      ),
    );
  }
}
