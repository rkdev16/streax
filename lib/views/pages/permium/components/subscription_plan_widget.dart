import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/config/size_config.dart';
import 'package:streax/controller/premium/subscription_controller.dart';
import 'package:streax/model/subscription_plans_res_model.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';

class SubscriptionPlanWidget extends StatelessWidget {
  const SubscriptionPlanWidget({super.key, required this.plan});

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0))),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            height: 80,
            width: SizeConfig.widthMultiplier * 100,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name ?? '',
                            style:
                                Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: AppColors.colorTextPrimary,
                                      fontSize: 16,
                                    ),
                          ),
                       if(plan.savingBy !=null)   SavingWidget(plan: plan)
                        ],
                      ),

                      RichText(text: TextSpan(text: plan.pricePerWeek ==null ? Helpers.formatPrice(plan.price) : '${Helpers.formatPrice(plan.pricePerWeek??0)}/' ,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            color: AppColors.colorTextPrimary,
                            fontSize: 24.fontMultiplier,
                            fontWeight: FontWeight.w700) ,

                        children: [
                          if(plan.pricePerWeek !=null)  TextSpan(text: 'week'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                  color: AppColors.colorTextPrimary,
                                  fontSize: 12.fontMultiplier,
                                  fontWeight: FontWeight.w700))
                        ]
                      ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: Text(
                    plan.description ?? '',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
          ),

          ListView(
            shrinkWrap: true,
            children:  (plan.features ?? [])
                  .map((featureName) => FeatureListTile(featureName: featureName)).toList(growable: false),).paddingOnly(bottom: 10),

          CommonButton(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              text: '${"subscribe".tr} - ${Helpers.formatPrice(plan.price)}',
              // isLoading: RxBool(Get.find<SubscriptionsController>().subscriptionPlans[Get.find<SubscriptionsController>().selectedSubscriptionIndex.value].id == plan.id),
              isLoading: Get.find<SubscriptionsController>().isSubscriptionLoading,
              onPressed: () {
                Get.find<SubscriptionsController>().purchaseSubscriptionPlan(plan);
              })
        ],
      ),
    );


  }
}

class FeatureListTile extends StatelessWidget {
  const FeatureListTile({super.key, required this.featureName});

  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.done, color: AppColors.kPrimaryColor),
          const Gap(8),
          Flexible(
            child: Text(featureName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14.fontMultiplier,
                    fontWeight: FontWeight.w700,
                    color: AppColors.colorTextPrimary)),
          ),
        ],
      ),
    );
  }
}

class SavingWidget extends StatelessWidget {
  const SavingWidget({super.key, required this.plan});

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.kPrimaryColor))),
      child: Text(
        '${'save'.tr} ${plan.savingBy}%',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 8.fontMultiplier,
          fontWeight: FontWeight.w600,
          color: AppColors.kPrimaryColor,
        ),
      ),
    );
  }
}
