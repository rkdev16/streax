import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/connections/connections_controller.dart';
import 'package:streax/controller/settings/block/blocked_users_controller.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/app_alerts.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button_outline.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class BlockedUserListTile extends StatelessWidget {
  const BlockedUserListTile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        CommonImageWidget(
          url: user.image,
          borderRadius: 100,
          height: 52,
          width: 52,
        ),
        const Gap(16),
        Expanded(
          child: Text(
            user.userName ?? "",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600, fontSize: 16.fontMultiplier),
          ),
        ),
        const Gap(8),
        UnblockBtnWidget(
          user: user,
        )
      ],
    );
  }
}

class UnblockBtnWidget extends StatefulWidget {
  const UnblockBtnWidget({super.key, required this.user});

  final User user;

  @override
  State<UnblockBtnWidget> createState() => _UnblockBtnWidgetState();
}

class _UnblockBtnWidgetState extends State<UnblockBtnWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const SizedBox(
            width: 82,
            height: 29,
            child: CommonProgressBar(
              strokeWidth: 3,
              size: 30,
            ),
          )
        : CommonButtonOutline(
            width: 82,
            height: 29,
            elevation: 0,
            margin: EdgeInsets.zero,
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 14.fontMultiplier, color: AppColors.kPrimaryColor),
            text: 'unblock'.tr,
            onPressed: () {
              AppAlerts.unblockUserAlert(
                  user: widget.user,
                  onUnblockTap: () async {
                    var controller = Get.find<ConnectionsController>();


                    setState(() {
                      loading = true;
                    });
                    var blockedStatus = await controller.toggleBlock(
                        userId: widget.user.id ?? '', isBlocked: false);
                    setState(() {
                      loading = false;
                    });

                    if (!blockedStatus) {
                      Get.find<BlockedUsersController>()
                          .blockedUsers
                          .removeWhere(
                              (element) => element.id == widget.user.id);
                    }
                  });
            });
  }
}
