

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class InfoListTile extends StatelessWidget {
  const InfoListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

 final  String title;
 final  String subtitle;
 final  String icon;

  @override
  Widget build(BuildContext context) {
    return  ListTile(
      dense: true,
      title: Text(
        title.tr,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(
            fontSize: 14.fontMultiplier,
            color: AppColors.colorTextSecondary),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 8.0),
            Text(
              subtitle.tr,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(
                  fontSize: 16.fontMultiplier,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorTextPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
