import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/controller/chat/chat_controller.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/views/pages/chat/components/chat_dialog_list_tile.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

class ChatRequestsScreen extends StatefulWidget {
   ChatRequestsScreen({super.key});

  @override
  State<ChatRequestsScreen> createState() => _ChatRequestsScreenState();
}

class _ChatRequestsScreenState extends State<ChatRequestsScreen> {
  final _chatController = Get.find<ChatController>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _chatController.getChatRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CommonAppBar(
          systemUiOverlayStyle:
          SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
          backgroundColor: Colors.white,
          title: 'chat_requests'.tr,
          onBackTap: (){
            Get.back();
            Get.find<DashBoardController>().fetchChatCount();
            Get.find<DashBoardController>().messageCount.refresh();
          },
          centerTitle: true,

        ),
        body: Obx(
              ()=>_chatController.isLoading.value ? const  CommonProgressBar(): _chatController.chatRequests.isEmpty? const  EmptyScreenWidget() :   ListView.separated(
              padding: const  EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context,index){

                var dialog = _chatController.chatRequests[index];
                return ChatDialogListTile(
                  chatDialog: dialog,
                  onTap: () {
                    _chatController.selectedChatDialog = dialog;
                    Get.toNamed(AppRoutes.routeChatScreen, arguments: {
                      'isOnline': _chatController
                          .selectedChatDialog
                          ?.isOnline ??
                          false
                    });
                  },
                );
              },
              separatorBuilder: (context,index){
                return const  Gap(16);
              },
              itemCount: _chatController.chatRequests.length),
        ),
      ),
    );
  }
}
