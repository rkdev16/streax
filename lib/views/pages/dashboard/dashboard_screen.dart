import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/profile/profile_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import '../../../config/app_colors.dart';
import '../../../controller/dashboard/dashboard_controller.dart';

class DashBoardScreen extends StatelessWidget {
  DashBoardScreen({super.key});
  final _dashboardController = Get.find<DashBoardController>();

  var bottomNavItems = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.icHome,
        height: iconSize,
        colorFilter: colorNormal,
      ),
      activeIcon: SvgPicture.asset(AppIcons.icHome,
          height: iconSize, colorFilter: colorActive),
      label: ''.tr,
    ),
    BottomNavigationBarItem(
        icon: Obx( () => (Get.find<DashBoardController>()
                        .messageCount
                        .value
                        .totalUnreadMessages ??
                    0) >
                0
            ? Badge(
                backgroundColor: AppColors.kPrimaryColor,
                label: Text(
                  Get.find<DashBoardController>()
                      .messageCount
                      .value
                      .totalUnreadMessages
                      .toString(),
                  style: TextStyle(
                      fontSize: 9.fontMultiplier, color: Colors.white),
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(AppIcons.icChatOutline,
                    height: iconSize, colorFilter: colorNormal),
              )
            : SvgPicture.asset(AppIcons.icChatOutline,
                height: iconSize, colorFilter: colorNormal) ),
        activeIcon:Obx( () =>  (Get.find<DashBoardController>()
                        .messageCount
                        .value
                        .totalUnreadMessages ??
                    0) >
                0
            ? Badge(
                backgroundColor: AppColors.kPrimaryColor,
                label: Text(
                  Get.find<DashBoardController>()
                      .messageCount
                      .value
                      .totalUnreadMessages
                      .toString(),
                  style: TextStyle(
                      fontSize: 9.fontMultiplier, color: Colors.white),
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(AppIcons.icChatOutline,
                    height: iconSize, colorFilter: colorNormal),
              )
            : SvgPicture.asset(AppIcons.icChatOutline,
                height: iconSize, colorFilter: colorActive)),
        label: ''.tr ) ,
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.icAddSquare,
        height: iconSize,
        colorFilter: colorNormal,
      ),
      activeIcon: SvgPicture.asset(AppIcons.icAddSquare,
          height: iconSize, colorFilter: colorActive),
      label: ''.tr,
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppIcons.icProfile,
        height: iconSize,
        colorFilter: colorNormal,
      ),
      activeIcon: SvgPicture.asset(AppIcons.icProfile,
          height: iconSize, colorFilter: colorActive),
      label: ''.tr,
    ),
    BottomNavigationBarItem(
      icon: Obx(
        () => CommonImageWidget(
          url: Get.find<ProfileController>().user.value?.image,
          width: 32,
          height: 32,
          borderRadius: 12,
        ),
      ),
      activeIcon: Obx(
        () => CommonImageWidget(
          url: Get.find<ProfileController>().user.value?.image,
          width: 32,
          height: 32,
          borderRadius: 12,
        ),
      ),
      label: ''.tr,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.white));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
              backgroundColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: AppColors.colorTextPrimary,
              selectedItemColor: AppColors.kPrimaryColor,
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                      fontSize: 12.fontMultiplier, fontWeight: FontWeight.w600),
              selectedLabelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                      fontSize: 12.fontMultiplier, fontWeight: FontWeight.w600),
              items: bottomNavItems,
              currentIndex: _dashboardController.currentTabIndex.value,
              onTap: _dashboardController.changeBottomNavBarItem),
        ),
        body: Obx(() => _dashboardController.pages
            .elementAt(_dashboardController.currentTabIndex.value)),
      ),
    );
  }
}

// InkWell(
// onTap: () {
// var storyController = Get.find<StoriesController>();
// if(!storyController.isLoadingPostStory.value){
// storyController.pickMediaForPost();
// }
//
// },
// child: Container(
// color: Colors.white,
// padding: const EdgeInsets.only(
// left: 24, right: 24, bottom: 20, top: 17),
// child: Obx(
// () => Get.find<StoriesController>()
//     .isLoadingPostStory
//     .value
// ? const SizedBox(
// height: 25,
// child: CommonProgressBar(
// size: 25,
// strokeWidth: 3,
// ))
//     : SvgPicture.asset(
// AppIcons.icAddSquare,
// height: 25,
// width: 25,
// colorFilter: const ColorFilter.mode(
// AppColors.kPrimaryColor, BlendMode.srcIn),
// ),
// )),
// ),
