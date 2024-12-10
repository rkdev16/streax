import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/views/pages/profile_setup/components/step_widget.dart';
import 'package:streax/views/widgets/common_curve_appbar.dart';

class CommonBgProfileSetup extends StatelessWidget {
  const CommonBgProfileSetup(
      {super.key, required this.child, required this.pageNo});

  final Widget child;

  final int pageNo; //page starts from 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonCurveAppBar(
        systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: AppColors.kPrimaryColor
        ),
        onBackTap: (){
         debugPrint("PreviousRoute = ${Get.previousRoute}");

           Get.offAllNamed(AppRoutes.routeSignInScreen);
        },
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: SizeConfig.widthMultiplier * 70,
              margin: const  EdgeInsets.symmetric(vertical: 16),

              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            height: 0,
                            indent: SizeConfig.widthMultiplier * 6,
                            color: pageNo == 2 || pageNo ==3
                                ? AppColors.kPrimaryColor
                                : AppColors.colorC2,
                          ),
                        ),
                        Expanded(
                          child: Divider(

                            thickness: 1,
                            height: 0,
                            endIndent: SizeConfig.widthMultiplier * 8,
                            color: pageNo == 3
                                ? AppColors.kPrimaryColor
                                : AppColors.colorC2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      StepWidget(
                          stepNo: 1, title: 'basics'.tr, isSelected: pageNo == 1 || pageNo ==2 || pageNo == 3),
                      StepWidget(
                          stepNo: 2,
                          title: 'pictures'.tr,
                          isSelected:  pageNo ==2 || pageNo ==3),
                      StepWidget(
                          stepNo: 3,
                          title: 'few_extras'.tr,
                          isSelected:  pageNo == 3)
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: child)
        ],
      ),
    );
  }
}
