


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/controller/settings/block/blocked_users_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/views/pages/settings/block/components/blocked_user_list_tile.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

class BlockedUsersScreen extends StatelessWidget {
   BlockedUsersScreen({super.key});

  final _blockedUsersController = Get.find<BlockedUsersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'blocked'.tr,
      systemUiOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white
      ),
      onBackTap: (){
        Navigator.of(context).pop();
      },),
      body: Obx(
          ()=> _blockedUsersController.isLoading.value? const  CommonProgressBar():
              _blockedUsersController.blockedUsers.isEmpty ?   EmptyScreenWidget(
                title: 'message_empty_blocked_list'.tr,
              ) :
          ListView.separated(
          padding: const EdgeInsets.all(16),
            itemBuilder:
            (context,index){

            User user = _blockedUsersController.blockedUsers[index];

          return  BlockedUserListTile(user: user,);
            },
            separatorBuilder: (context,index){
          return const Gap(16);
            },
            itemCount: _blockedUsersController.blockedUsers.length),
      ),
    );
  }
}
