import 'package:flutter/material.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class CommonUserListTile extends StatelessWidget {
  const CommonUserListTile({
    super.key,
    required this.user,
    this.fromSearch = false,
    this.onTap
  });


  final User user;
  final bool fromSearch;
  final Function(User user)? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onTap !=null ? onTap!(user) : (){};
      },
      child: Row(
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

                      fontSize: 20.fontMultiplier,
                      color: AppColors.colorTextPrimary,
                      fontWeight: FontWeight.w600
                  ),),
                  fromSearch == true? Text(user.userName??'',style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16.fontMultiplier,
                      color: AppColors.colorTextSecondary,
                      fontWeight: FontWeight.w600
                  ),): Container()
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}