import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class PremiumDataListTile extends StatelessWidget {
  const PremiumDataListTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.value});

  final String title;
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const  EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 14.fontMultiplier,
            color: AppColors.colorTextSecondary

          ),),
         const  Gap(4),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            SvgPicture.asset(icon),
             const  Gap(8),
              Text(value,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 16.fontMultiplier,
                  color: AppColors.colorTextSecondary

              ),),
          ],)
        ],
      ),
    );
  }
}
