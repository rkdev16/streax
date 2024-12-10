

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/story/story_views_controller.dart';
import 'package:streax/model/common_options_model.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/views/bottomsheets/common_options_bottom_sheet.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/common_user_list_tile.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

class StoryViewsScreen extends StatelessWidget {
   StoryViewsScreen({super.key});

  final _storyViewersController = Get.find<StoryViewsController>();

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CommonAppBar(title: 'story_views'.tr,onBackTap: (){
          Get.back();
        },),

        body: Column(
          children: [
            CommonInputField(
                controller: _storyViewersController.searchTextController,
                hint: 'search'.tr,

              leading: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(AppIcons.icSearch),
              ),


                suffixIcon: IconButton(onPressed: (){
                  CommonOptionsBottomSheet.show(options: [
                    OptionModel('all'.tr, () {
                      _storyViewersController.filterUsers(FilterType.all);
                    }),
                    OptionModel('mutual'.tr, () {
                      _storyViewersController.filterUsers(FilterType.mutual);
                    }),
                    OptionModel('liked_me'.tr, () {
                      _storyViewersController.filterUsers(FilterType.likedMe);
                    }),
                    OptionModel('i_liked'.tr, () {
                      _storyViewersController.filterUsers(FilterType.iLiked);
                    }),

                  ]);
                },
                    icon: SvgPicture.asset(AppIcons.icFilter)),
              margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            ),


            Expanded(
              child: Obx(
                  ()=>_storyViewersController.filteredUsers.isEmpty ? const  EmptyScreenWidget(): ListView.separated(
                  padding: const  EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                    itemBuilder: (context,index){
                 var user = _storyViewersController.filteredUsers[index];
                 return CommonUserListTile(user: user,
                   onTap: (User user){
                   Get.toNamed(AppRoutes.routePublicProfileScreen,arguments: {
                     AppConsts.keyUser:user
                   });
                   },
                 );
                 },
                   separatorBuilder: (context,index){
                 return  const SizedBox(height: 16,);
                   },
                   itemCount: _storyViewersController.filteredUsers.length),
              ),
            )

          ],
        ),
      ),
    );
  }
}



