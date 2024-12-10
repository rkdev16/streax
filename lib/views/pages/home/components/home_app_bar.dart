import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/notification_widget.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle:
          SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      centerTitle: false,
      surfaceTintColor: Colors.white,

      title: Container(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppIcons.icAppHeartRedOutline, height:36),
            const SizedBox(width: 5.0),
            Text(
              'streax'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: AppColors.colorTextPrimary,
                    fontSize: 28.fontMultiplier,
                  ),
            ),
          ],
        ),
      ),
      actions: [
      const NotificationWidget(),

        IconButton(
            padding: const EdgeInsets.only(right: 8),
            onPressed: () {
              Get.toNamed(AppRoutes.routeSettingsScreen);
            },
            icon: SvgPicture.asset(
              AppIcons.icSettings,
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                height: 22,
            )),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
