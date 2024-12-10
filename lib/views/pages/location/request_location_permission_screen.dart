import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/controller/home/home_controller.dart';
import 'package:streax/controller/location/location_controller.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/widgets/common_button.dart';

class RequestLocationPermissionScreen extends StatelessWidget {
  RequestLocationPermissionScreen({super.key});

  final _locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'title_request_location'.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 24.fontMultiplier,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorTextPrimary,
                    ),
              ),
              const Gap(16),
              Text(
                'description_request_location'.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 16.fontMultiplier,
                      color: AppColors.colorTextPrimary,
                    ),
              ),

              Container(
                padding: const EdgeInsets.all(60),
                margin:  const  EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: const Border.fromBorderSide(
                        BorderSide(color: AppColors.kPrimaryColor)),
                    color: AppColors.kPrimaryColor.withOpacity(
                      0.2,
                    )),
                child: SvgPicture.asset(
                  AppIcons.icMarkerFilled,
                  height: 100,
                  colorFilter: const ColorFilter.mode(
                      AppColors.kPrimaryColor, BlendMode.srcIn),
                ),
              ),
              CommonButton(text: 'allow'.tr, onPressed: () {
                _locationController.getCurrentLocation().then((value) {
                  if(value) {
                    Navigator.of(context).pop();
                  }
                  else {
                    Get.back();
                  }
                  debugPrint('Location Permission  = ${value}');
                  Get.find<HomeController>().isHavingPermission.value = value;
                  Get.find<HomeController>().getProfileSuggestions();
                });
              },
                borderRadius: 24,
              ),
              /*InkWell(
                onTap: (){
                  Get.back();
                },
                child: Text(
                  'skip'.tr,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.fontMultiplier,
                    color: AppColors.colorTextPrimary,
                  ),
                ).paddingOnly(top: 20),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
