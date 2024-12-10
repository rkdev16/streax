import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_curve_appbar.dart';
import '../../../config/app_colors.dart';
import '../../../route/app_routes.dart';


class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () { 
        return Future(() => false);
      },
      child: Scaffold(
        appBar:  CommonCurveAppBar(
          systemUiOverlayStyle: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: AppColors.kPrimaryColor),
          leading: const SizedBox(),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:  EdgeInsets.only(top: SizeConfig.heightMultiplier *16),
              child: SvgPicture.asset(AppIcons.icCheckCircle,),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                "password_changed".tr,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                      color: AppColors.colorTextPrimary,
                      fontSize: 24.fontMultiplier,
                    ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "password_change_successfully".tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.colorTextSecondary,
                      fontSize: 16.fontMultiplier,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0,vertical: 16),
              child: CommonButton(
                  text: "back_to_sign_in".tr,
                  onPressed: () {
                   Get.until((route) => route.settings.name == AppRoutes.routeSignInScreen);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
