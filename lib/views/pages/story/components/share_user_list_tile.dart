

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class ShareUserListTile extends StatelessWidget {
  const ShareUserListTile({
    super.key,
    required this.user,
    required this.onUserTapped
  });


  final User user;
  final onUserTapped;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          padding: const  EdgeInsets.all(3),
          decoration: const  BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(BorderSide(color: AppColors.kPrimaryColor))
          ),
          child: CommonImageWidget(url: user.image,
            borderRadius: 100,),),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName??'',style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                    fontSize: 18.fontMultiplier,
                    color: AppColors.colorTextPrimary,
                    fontWeight: FontWeight.w600
                ),),
                Text(user.userName??'',style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                    fontSize: 12.fontMultiplier,
                    color: AppColors.colorTextSecondary,
                    fontWeight: FontWeight.w600
                ),),
              ],
            ),
          ),
        ),
        InkWell(
            onTap: onUserTapped,
            child: SvgPicture.asset((user.isSelected!) ? AppIcons.icCheckCircle : AppIcons.icUnCheckCircle,height: 24,))
      ],
    );
  }
}
