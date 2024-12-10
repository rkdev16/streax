import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/model/user.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/connections/component/connection_tile.dart';

class ConnectionsSectionWidget extends StatelessWidget {
  const ConnectionsSectionWidget(
      {super.key,
      required this.title,
      required this.connections,
      required this.connectionType,
      this.padding});

  final String title;
  final List<User> connections;
  final ConnectionType connectionType;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.colorTextPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.fontMultiplier,
                    ),
              ),
              if (connections.length > 1)
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.routeViewAllConnectionsScreen,
                        arguments: {
                          AppConsts.keyConnectionsType: connectionType
                        });
                  },
                  child: Text(
                    'view_all'.tr,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.kPrimaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.kPrimaryColor,
                          fontSize: 14.fontMultiplier,
                        ),
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: 200,
          width: Get.width,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            itemCount: connections.length > 7 ? 7 : connections.length,
            itemBuilder: (context, index) {
              return ConnectionTile(
                  user: connections[index], connectionType: connectionType);
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Gap(10);
            },
          ),
        )
      ],
    );
  }
}
