
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/consts/app_icons.dart';
import '../../config/app_colors.dart';
import '../../config/size_config.dart';
import '../../utils/custom_painters/custom_shape.dart';

class CommonCurveAppBar extends StatelessWidget implements PreferredSizeWidget{
   CommonCurveAppBar({super.key,this.onBackTap,this.leading,this.systemUiOverlayStyle});
Function()? onBackTap;
final Widget? leading;

   final SystemUiOverlayStyle? systemUiOverlayStyle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: systemUiOverlayStyle ??
          Theme.of(context).appBarTheme.systemOverlayStyle,
      automaticallyImplyLeading: false,
      toolbarHeight: 150,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: ClipPath(
        clipper: CustomShape(),
        child: Container(
          height: 200,
          width: SizeConfig.widthMultiplier*100,
          color: AppColors.kPrimaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                  child: leading ?? BackButton(onPressed: onBackTap,color: Colors.white)),
              Row(
                children: [
                  Image.asset(AppIcons.icAppHeartWhiteOutline,height: 48,width: 48),
                  Text(
                    'streax'.tr,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 33,
                        fontFamily: 'Inter',
                        color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                width: 50,
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(150);
}
