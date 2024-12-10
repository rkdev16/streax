import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';

class BrowseStoreWidget extends StatelessWidget {
  const BrowseStoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
      },
      child: Container(
        margin: const  EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        padding: const  EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: const  Border.fromBorderSide(BorderSide(color: AppColors.kPrimaryColor))
        ),
        child: Row(children: [

          Text('😊',style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 32
          ),),

       const    Gap(8),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('streax_store'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16.fontMultiplier,
                  fontWeight: FontWeight.w600,
                color: AppColors.colorTextPrimary
              ),),
              Text('subtitle_browse_store'.tr,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 10.fontMultiplier,
                  color: AppColors.colorTextPrimary
              ),),



            ],),
          ),

        const   Gap(8),

          CommonButton(
            width: 100,
            height: 30,
              elevation: 0,
              margin: const  EdgeInsets.symmetric(horizontal: 0),
              text: 'browse_store'.tr,
              onPressed: (){
                Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
              })



        ],),
      ),
    );
  }
}
