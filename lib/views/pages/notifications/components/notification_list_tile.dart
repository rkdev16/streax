import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/model/notifications_res_model.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class NotificationListTile extends StatelessWidget {
  const NotificationListTile({super.key, required this.notification});

  final AppNotification notification;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: CommonImageWidget(
              url: notification.image,
              borderRadius: 100,
            ),
          ).paddingOnly(right: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title ?? '',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 14.fontMultiplier,
                    color: AppColors.colorTextPrimary),
              ),
              Text(
                Helpers.getTimeAgo(notification.time),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 12.fontMultiplier,
                    color: AppColors.colorTextSecondary),
              )
            ],
          ),
        ],
      ),
    );
  }
}
