import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/controller/notification/notification_controller.dart';
import 'package:streax/views/pages/notifications/components/notification_list_tile.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final _notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          systemUiOverlayStyle:
              SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
          backgroundColor: Colors.white,
          title: 'notifications'.tr,
          onBackTap: () {
            Get.back();
          },
        ),
        body: Obx(() => _notificationController.isLoading.value
            ? const CommonProgressBar()
            : _notificationController.notifications.isEmpty
                ?  const EmptyScreenWidget()
                : ListView.separated(
          padding:  const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      final notification = _notificationController.notifications[index];
                      return NotificationListTile(
                        notification: notification,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const  Divider(
                        height: 24,
                        indent: 20,
                        endIndent: 20,
                      );
                    },
                    itemCount: _notificationController.notifications.length)));
  }
}
