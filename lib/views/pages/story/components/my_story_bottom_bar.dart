import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/story/stories_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class MyStoryBottomBar extends StatelessWidget {
  const MyStoryBottomBar({
    super.key,
    required this.users

  });

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    debugPrint("View = ${users.length}");
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           ViewerImageWidget(
            users: users,
          ),
          InkWell(
            onTap: () {
              Get.find<StoriesController>().showDeleteStoryAlert();
            },
            child: Column(
              children: [
                SvgPicture.asset(AppIcons.icBin),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'delete'.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 12.fontMultiplier, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ViewerImageWidget extends StatelessWidget {
  const ViewerImageWidget({super.key,required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context) {

    return users.isEmpty
        ? const SizedBox.shrink()
        : InkWell(
      onTap: (){

        Get.toNamed(AppRoutes.routeStoryViewersScreen,arguments: {
          AppConsts.keyListData : users
        });
      },
          child: Column(
              children: [

                if (users.length == 1)

                  imageWidget(url: users.first.image),
                if (users.length == 2)
                  Stack(
                    children: [
                      imageWidget(url:users.first.image),
                      imageWidget(
                          url: users.last.image, paddingLeft: 20),
                    ],
                  ),
                if (users.length >= 3)
                  Stack(
                    children: [
                      imageWidget(url: users.first.image),
                      imageWidget(
                          url: users[1].image, paddingLeft: 20),
                      imageWidget(
                          url: users[2].image, paddingLeft: 40),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '${users.length} ${'views'.tr}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 12.fontMultiplier, color: Colors.white),
                  ),
                )
              ],
            ),
        );
  }

  Widget imageWidget({String? url, double? paddingLeft}) {
    return Padding(
      padding: EdgeInsets.only(left: paddingLeft ?? 0),
      child: CommonImageWidget(
        url: url,
        borderRadius: 100,
        height: 30,
        width: 30,
      ),
    );
  }
}
