import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/network/get_requests.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/preference_manager.dart';
import 'package:streax/views/pages/story/components/share_user_list_tile.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

class ShareStoryScreen extends StatefulWidget {
  ShareStoryScreen({super.key});

  @override
  State<ShareStoryScreen> createState() => _ShareStoryScreenState();
}

class _ShareStoryScreenState extends State<ShareStoryScreen> {
  final _connectionsController = Get.find<ConnectionsController>();
  final searchTextController = TextEditingController();

  List<User> mutualConnections = [];
  List<User> filteredMutualConnections = [];
  List<User> searchFilteredMutualConnections = [];

  bool addStory = true;

  @override
  void initState() {
    super.initState();
    getConnections();
  }

  void getConnections() async{
    try{
      var result = await GetRequests.fetchConnections();
      if(result !=null){
        if(result.success){
          mutualConnections.assignAll(result.connectionsData?.mutual??[]);
          filteredMutualConnections.assignAll(result.connectionsData?.mutual??[]);
          searchFilteredMutualConnections.assignAll(result.connectionsData?.mutual??[]);
          for (var element in filteredMutualConnections) {
            element.isSelected = false;
          }
          setState(() {

          });
        }else{
          AppAlerts.error(message: result.message);
        }
      }else{
        AppAlerts.error(message: 'message_server_error'.tr);
      }

    }finally{
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '',
        onBackTap: () {
          Get.back();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                          BorderSide(color: AppColors.kPrimaryColor))),
                  child: CommonImageWidget(
                    url: PreferenceManager.user?.image,
                    borderRadius: 100,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'my_story'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 20.fontMultiplier,
                              color: AppColors.colorTextPrimary,
                              fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      addStory = !addStory;
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      addStory
                          ? AppIcons.icCheckCircle
                          : AppIcons.icUnCheckCircle,
                      height: 24,
                    ))
              ],
            ),
          ),
          CommonInputField(
            controller: searchTextController,
            hint: 'search'.tr,
            onChanged: (value) {
              if (filteredMutualConnections.isNotEmpty) {
                if (value != '') {
                  searchFilteredMutualConnections = filteredMutualConnections
                      .where((element) => (element.fullName!
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          element.userName!
                              .toLowerCase()
                              .contains(value.toLowerCase())))
                      .toList();
                } else {
                  searchFilteredMutualConnections = filteredMutualConnections;
                }
              } else {
                searchFilteredMutualConnections = filteredMutualConnections;
              }
              setState(() {});
            },
            leading: Container(
              height: 24,
              width: 24,
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(AppIcons.icSearch),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          ),
          Expanded(
            child: searchFilteredMutualConnections.isEmpty
                ? const EmptyScreenWidget()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return ShareUserListTile(
                        user: searchFilteredMutualConnections[index],
                        onUserTapped: () {
                          searchFilteredMutualConnections[index].isSelected =
                              !(searchFilteredMutualConnections[index]
                                  .isSelected!);
                          setState(() {});
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 16,
                      );
                    },
                    itemCount: searchFilteredMutualConnections.length,
                  ),
          ),
          CommonButton(
              text: 'send'.tr,
              margin: const EdgeInsets.all(16),
              onPressed: () {
                List<String?> sharedUserIds = searchFilteredMutualConnections
                    .where((element) => element.isSelected == true)
                    .map((e) => e.id)
                    .toList();
                Get.back(result: {
                  'addStory': addStory,
                  'sharedUserIds': sharedUserIds
                });
              })
        ],
      ),
    );
  }
}
