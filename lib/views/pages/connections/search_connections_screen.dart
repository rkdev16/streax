
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/controller/connections/search_connections_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/common_search_app_bar.dart';
import 'package:streax/views/widgets/common_user_list_tile.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

class SearchConnectionsScreen extends StatelessWidget {
   SearchConnectionsScreen({super.key});

  final _searchConnectionsController = Get.find<SearchConnectionsController>();

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CommonSearchAppBar(
          hint:'search'.tr,
          onBackTap: (){
            Get.back();
          },
          searchInputController: _searchConnectionsController.searchTextController,
          onSearchKeywordChange: (String value){
            _searchConnectionsController.searchKeyword.value =value;
          },
        ),

        body: Obx(
              ()=>_searchConnectionsController.isLoading.value ? const  CommonProgressBar():_searchConnectionsController.users.isEmpty ? const  EmptyScreenWidget(): ListView.separated(
              padding: const  EdgeInsets.symmetric(horizontal: 16,vertical: 24 ),
              shrinkWrap: true,
              itemBuilder: (context,index){
                var user = _searchConnectionsController.users[index];

                return CommonUserListTile(user: user,
                  fromSearch: true,
                  onTap: (User user){
                  FocusManager.instance.primaryFocus?.unfocus();
                    Get.toNamed(AppRoutes.routePublicProfileScreen,arguments: {
                      AppConsts.keyUser:user
                    });
                  },
                );
              },
              separatorBuilder: (context,index){
                return  const SizedBox(height: 16,);
              },
              itemCount: _searchConnectionsController.users.length),
        ),
      ),
    );
  }
}
