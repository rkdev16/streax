import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/dashboard/dashboard_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.routeNotificationScreen);
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              SvgPicture.asset(
                AppIcons.icNotifications,
                colorFilter:
                    const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                height: 24,
              ).paddingSymmetric(horizontal: 6,vertical: 4),
              (Get.find<DashBoardController>()
                              .notificationCount
                              .value
                              .notificationCount ??
                          0) >
                      0
                  ? Container(
                      height: 14,
                      width: 14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.kPrimaryColor),
                      alignment: Alignment.center,
                      child: Text(
                        Get.find<DashBoardController>()
                            .notificationCount
                            .value
                            .notificationCount
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                                color: Colors.white,
                                fontSize: 8.fontMultiplier),
                      ))
                  : const SizedBox(
                height: 14,
                width: 14,
              ),
            ],
          ),
        ));
  }
}
