import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import '../../../controller/notification/notification_controller.dart';



class NotificationsSettingScreen extends StatefulWidget {
  const NotificationsSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingScreen> createState() =>
      _NotificationsSettingScreenState();
}

class _NotificationsSettingScreenState
    extends State<NotificationsSettingScreen> {
  final _notificationController = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _notificationController.getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        backgroundColor: Colors.white,
        title: 'notifications'.tr,
        onBackTap: () {
          Get.back();
        },
      ),
      body: CommonCardWidget(
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
            ()=> NotificationSettingOption(
                  title: 'mutual_match'.tr,
                  isChecked:
                      _notificationController.mutualMatchNotification.value,
                  onChanged: (val) {
                    _notificationController.updateMutualMatchNotification();
                  }),
            ),
            const Divider(thickness: 1.0),
            Obx(
                  ()=> NotificationSettingOption(
                  title: 'liked_me'.tr,
                  isChecked:
                  _notificationController.likedMeNotification.value,
                  onChanged: (val) {
                    _notificationController.updateLikedMeNotification();
                  }),
            ),
            const Divider(thickness: 1.0),
            Obx(
                  ()=> NotificationSettingOption(
                  title: 'chat'.tr,
                  isChecked:
                  _notificationController.chatNotification.value,
                  onChanged: (val) {
                    _notificationController.updateChatNotification();
                  }),
            ),
            const Divider(thickness: 1.0),

            Obx(
                  ()=> NotificationSettingOption(
                  title: 'story'.tr,
                  isChecked:
                  _notificationController.storyNotification.value,
                  onChanged: (val) {
                    _notificationController.updateStoryNotification();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingOption extends StatelessWidget {
  const NotificationSettingOption(
      {super.key,
      required this.title,
      required this.isChecked,
      required this.onChanged});

  final String? title;
  final bool isChecked;
  final Function(bool isChecked) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title??'',
            style:
                Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 16),
          ),
        ),


        Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
                  activeColor: AppColors.kPrimaryColor,
                  trackColor: AppColors.color95.withOpacity(0.6),
                  value: isChecked,
                  onChanged: onChanged),

        )

      ],
    );
  }
}
