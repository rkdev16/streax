import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/model/user.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class CenterStageBottomSheet {
  static show({required User user, required onActivate}) {
    Get.bottomSheet(
      _CenterStageBottomSheetContent(
        user: user,
        onTap: onActivate,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
    );
  }
}

class _CenterStageBottomSheetContent extends StatelessWidget {
  _CenterStageBottomSheetContent({required this.user, required this.onTap});

  final User? user;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 126,
                  height: 6,
                  decoration: BoxDecoration(
                      color: AppColors.colorEF,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.icStarCenterStage, height: 20,),
                    const Gap(8),
                    Text(
                      'center_stage'.tr,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                          fontSize: 20.fontMultiplier,
                          fontWeight: FontWeight.w600,
                          color: AppColors.colorTextPrimary),
                    ),
                  ],
                ),
              ),
              CommonImageWidget(
                url: user?.image ?? '',
                height: 100,
                width: 100,
                borderRadius: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, top: 8, bottom: 24),
                child: Text(
                  '${user?.fullName ?? ''},${Helpers.calculateAge(user?.dob)}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorTextPrimary,
                      fontSize: 16.fontMultiplier),
                ),
              ),
          Text(
            '${'boost_visibility'.tr}${user?.fullName ?? ''}${'increase_chances_matching'.tr}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.colorTextPrimary,
                fontSize: 14.fontMultiplier),
        ).paddingOnly(bottom: 15),
              CommonButton(text: 'activate'.tr, onPressed: onTap).paddingSymmetric(vertical: 10)
            ],
          ),
        ),
      ),
    );
  }
}
