import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:streax/consts/app_consts.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/controller/location/location_controller.dart';
import 'package:streax/controller/settings/settings_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/pages/settings/block/components/setting_option_list_tile.dart';
import 'package:streax/views/pages/settings/components/premium_data_list_tile.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/common_range_slider.dart';
import 'package:streax/views/widgets/common_slider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../config/app_colors.dart';
import '../../../model/common_options_model.dart';
import '../../../route/app_routes.dart';
import '../../bottomsheets/common_options_bottom_sheet.dart';
import '../../widgets/common_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final _settingsController = Get.find<SettingsController>();
  final _locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          appBar: CommonAppBar(
            onBackTap: () {
              Navigator.of(context).pop();
            },
            systemUiOverlayStyle: SystemUiOverlayStyle.dark
                .copyWith(statusBarColor: Colors.white),
            backgroundColor: Colors.white,
            title: 'settings'.tr,
          ),
          body: Obx(
            () => _settingsController.isLoading.value
                ? const CommonProgressBar()
                : SmartRefresher(
                    enablePullDown: true,
                    controller: _settingsController.refreshController,
                    onRefresh: () {
                      debugPrint("onRefresh");
                      _settingsController.setupProfileData();
                    },
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      shrinkWrap: true,
                      children: [
                        CommonCardWidget(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          onTap: () {
                            CommonOptionsBottomSheet.show(
                                height: 200.0,
                                options: [
                                  OptionModel("men", () {
                                    _settingsController.interestedIn.value =
                                        Gender.men;
                                    _settingsController.updateInterest();
                                  }),
                                  OptionModel("women", () {
                                    _settingsController.interestedIn.value =
                                        Gender.women;
                                    _settingsController.updateInterest();
                                  }),
                                  OptionModel("everyone", () {
                                    _settingsController.interestedIn.value =
                                        Gender.everyone;
                                    _settingsController.updateInterest();
                                  }),
                                ]);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "interested_in".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(
                                    () => Text(
                                        (AppConsts.interestedInTitleMap[
                                                    _settingsController
                                                        .interestedIn.value] ??
                                                '')
                                            .tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                fontSize: 14.fontMultiplier,
                                                color:
                                                    AppColors.kPrimaryColor)),
                                  )
                                ],
                              ),
                              const Gap(8),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                        CommonCardWidget(
                          margin:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          padding: const EdgeInsets.only(
                              left: 16, right: 8, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "current_location".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                        ),
                                  ),
                                  TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero)),
                                      onPressed: () {
                                        if (Helpers.canUsePremium(
                                            PremiumType.travelMode)) {
                                          Get.toNamed(AppRoutes
                                              .routeSearchLocationScreen);
                                        } else {
                                          Get.toNamed(AppRoutes
                                              .routeOneTimePurchaseScreen);
                                        }
                                      },
                                      child: Text(
                                        'change'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.fontMultiplier,
                                                color: AppColors.kPrimaryColor),
                                      ))
                                ],
                              ),
                              Obx(
                                () => Text(
                                  _locationController.currentCity.value ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: 14.fontMultiplier,
                                          color: AppColors.colorTextPrimary),
                                ),
                              )
                            ],
                          ),
                        ),
                        CommonRangeSlider(
                          title: 'age_preference'.tr,
                          values: _settingsController.ageRangeValues.value,
                          min: 18.0,
                          max: 80.0,
                          onChange: (SfRangeValues values) {
                            _settingsController.ageRangeValues.value = values;
                          },
                        ),
                        CommonSlider(
                          title: 'distance_preference'.tr,
                          value:
                              _settingsController.distancePreferenceValue.value,
                          min: 0.0,
                          max: 100.0,
                          valuesUnit: 'miles'.tr,
                          onChange: (num values) {
                            _settingsController.distancePreferenceValue.value =
                                values;
                          },
                        ),
                        _SubscriptionPlanCard(
                            settingsController: _settingsController),
                        _OneTimePlanCard(
                            settingsController: _settingsController),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              OptionModel option =
                                  _settingsController.settingOptions[index];
                              return SettingsOptionListTile(option: option);
                            },
                            separatorBuilder: (context, index) {
                              return const Gap(8);
                            },
                            itemCount:
                                _settingsController.settingOptions.length),
                        const Gap(20),
                        Align(
                          alignment: Alignment.center,
                          child: Text('Streax v01.00.00',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                        ),
                        const Gap(30),
                      ],
                    ),
                  ),
          )),
    );
  }
}

class _SubscriptionPlanCard extends StatelessWidget {
  const _SubscriptionPlanCard({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("subscriptions".tr,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 16,
                        )),
              ),
              CommonButton(
                  width: 100,
                  height: 30,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  text: 'browse_store'.tr,
                  onPressed: () {
                    Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                  })
            ],
          ),
          const SizedBox(height: 12.0),
          const Divider(
            thickness: 1.5,
            color: AppColors.dividerColor,
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'account_type'.tr,
                icon: AppIcons.icCheckList,
                value: settingsController.userSubscription.value?.plan ??
                    'no_plan_active'.tr),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'instant_chat'.tr,
                icon: AppIcons.icInstantChat2,
                value:
                    (settingsController.userSubscription.value?.instantChat ??
                            0)
                        .toString()),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'crush'.tr,
                icon: AppIcons.icLoveEyesEmoji,
                value: (settingsController.userSubscription.value?.crush ?? 0)
                    .toString()),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'center_stage'.tr,
                icon: AppIcons.icStarCenterStage,
                value:
                    (settingsController.userSubscription.value?.centerStage ??
                            0)
                        .toString()),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'hangout'.tr,
                icon: AppIcons.icGlassSvg,
                value:
                    (settingsController.userSubscription.value?.dateRequest ??
                            0)
                        .toString()),
          ),
          Obx(() => PremiumDataListTile(
                title: 'travel_mode'.tr,
                icon: AppIcons.icPlaneTravelMode,
                value: settingsController.userSubscription.value == null
                    ? 'not_available'.tr
                    : 'available'.tr,
              ))
        ],
      ),
    );
  }
}

class _OneTimePlanCard extends StatelessWidget {
  const _OneTimePlanCard({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text("one_time_purchase".tr,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 16,
                        )),
              ),
              CommonButton(
                  width: 100,
                  height: 30,
                  elevation: 0,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  text: 'browse_store'.tr,
                  onPressed: () {
                    Get.toNamed(AppRoutes.routeOneTimePurchaseScreen);
                  })
            ],
          ),
          const SizedBox(height: 12.0),
          const Divider(
            thickness: 1.5,
            color: AppColors.dividerColor,
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'instant_chat'.tr,
                icon: AppIcons.icInstantChat2,
                value:
                    settingsController.oneTimeInstantChatLeft.value.toString()),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'crush'.tr,
                icon: AppIcons.icLoveEyesEmoji,
                value: settingsController.oneTimeCrushLeft.value.toString()),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'center_stage'.tr,
                icon: AppIcons.icStarCenterStage,
                value:
                    settingsController.oneTimeCenterStageLeft.value.toString()),
          ),
          Obx(
            () => PremiumDataListTile(
                title: 'hangout'.tr,
                icon: AppIcons.icGlassSvg,
                value: settingsController.oneTimeDateRequestsLeft.value
                    .toString()),
          )
        ],
      ),
    );
  }
}
