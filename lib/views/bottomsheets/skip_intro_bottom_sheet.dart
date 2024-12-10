import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';

class SkipIntroBottomSheet {
  static show({required BuildContext context,required VoidCallback onSkipTap}) {
    Get.bottomSheet(SkipIntroContent(onSkipTap: onSkipTap,),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))));
  }
}

class SkipIntroContent extends StatelessWidget {
  const  SkipIntroContent({
    super.key,
    required this.onSkipTap
  });

 final  VoidCallback onSkipTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: 126,
            height: 8,
            margin: const  EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
                color: AppColors.colorF3,
                borderRadius: BorderRadius.circular(24)
            ),),

          Padding(
            padding: const EdgeInsets.only(left: 24.0,right: 24),
            child: Text(
              "you_want_to_skip".tr,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                color: AppColors.colorTextPrimary,
                  fontSize: 16.fontMultiplier,
              fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              children: [
                Expanded(
                    child: CommonButton(
                        backgroundColor: AppColors.colorC2,
                      text: "skip_for_now".tr,
                      onPressed:onSkipTap,)),
                Expanded(
                    child: CommonButton(
                        text: "record_intro".tr,
                        onPressed: () {
                          Get.back();
                        }))
              ],
            ),
          )
        ],
      ),
    );
  }
}
class ShowDatePicker{
  static show(){


  }
}