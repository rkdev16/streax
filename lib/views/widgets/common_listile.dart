import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

import 'common_button.dart';
import 'common_card_widget.dart';

class CommonListTile extends StatelessWidget {
  CommonListTile({super.key,required this.title,
    required this.subTitle,
    required this.image,
    required this.price,
    this.icon,
  });
  String title;
  String subTitle;
  String price;
  String image;
  Widget? icon;




  @override
  Widget build(BuildContext context) {
    return  CommonCardWidget(
      padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0,top: 8.0),
      margin: const EdgeInsets.only(top: 10,bottom: 10,left: 4.0,right: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minLeadingWidth: 0.0,
            contentPadding: EdgeInsets.zero,
            trailing:  Text(price.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14.0.fontMultiplier,fontWeight: FontWeight.w500
              ),),
            title:  Text(title.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16.0.fontMultiplier,fontWeight: FontWeight.w500
              ),),
            leading: Image.asset(
              image,
              //AppIcons.icMessageMinus,
              height: 30,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subTitle.tr,

                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14.0.fontMultiplier,fontWeight: FontWeight.w400,color: AppColors.color6F
                ),),
              icon?? CommonButton(
                  margin: EdgeInsets.zero,
                  height: 29,
                  width: 60,
                  text: "buy".tr,
                  onPressed: () {

                  })
            ],
          )
        ],
      ),
    );
  }
}
