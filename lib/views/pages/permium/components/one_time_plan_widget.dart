import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/premium/subscription_controller.dart';
import 'package:streax/model/one_time_purchases_res_model.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/helpers.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_image_widgets.dart';

class OneTimePlanWidget extends StatelessWidget {
  const OneTimePlanWidget({
    super.key,
    required this.plan,
  });

  final OneTimePlan plan;

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 24, bottom: 8),
      margin: const EdgeInsets.only(top: 10, bottom: 10, left: 4.0, right: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonImageWidget(
                            url: plan.image,
                            height: 24,
                            width: 24,
                          ),
                          const Gap(8),
                          Text(
                            plan.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    fontSize: 16.fontMultiplier,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.colorTextPrimary),
                          ),
                          if (plan.savingBy != null)
                            SavingWidget(
                              plan: plan,
                            )
                        ],
                      ),
                      const Gap(10),
                      Text(
                        plan.description ?? '',
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 14.fontMultiplier,
                                color: AppColors.colorTextPrimary),
                      )
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  flex: 1,
                  child: (plan.quantity ?? 0) == 0
                      ? const AvailableOnSubscription()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${plan.quantity} ${'for'.tr.toLowerCase()} ${Helpers.formatPrice(plan.price)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                      fontSize: 14.fontMultiplier,
                                      color: AppColors.colorTextPrimary),
                            ),
                            const Gap(16),
                            CommonButton(
                                height: 30,
                                width: 90,
                                margin: EdgeInsets.zero,
                                isLoading: Get.find<SubscriptionsController>()
                                        .isSubscriptionLoading
                                        .value
                                    ? null
                                    : plan.loading,
                                padding: EdgeInsets.zero,
                                text: 'Buy'.tr,
                                onPressed: Get.find<SubscriptionsController>()
                                        .isSubscriptionLoading
                                        .value
                                    ? () {}
                                    : () {
                                        Get.find<SubscriptionsController>()
                                            .isSubscriptionLoading
                                            .value = true;
                                        Get.find<SubscriptionsController>()
                                            .purchaseOneTimePlan(
                                          plan,
                                        );
                                      })
                          ],
                        ),
                )
              ],
            ),
          ),
          // const Gap(8),
          Text(
            plan.promotionalTag ?? '',
            maxLines: 1,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.fontMultiplier,
                color: AppColors.colorTextPrimary),
          ).paddingOnly(right: 4, bottom: 4)
        ],
      ),
    );
  }
}

class AvailableOnSubscription extends StatelessWidget {
  const AvailableOnSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
            text: 'available_only'.tr,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 14.fontMultiplier, color: AppColors.colorTextPrimary),
            children: [
              TextSpan(text: '\n${'on'.tr} '),
              TextSpan(
                  text: 'streax'.tr,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14.fontMultiplier,
                      fontWeight: FontWeight.w700,
                      color: AppColors.colorTextPrimary)),
              TextSpan(
                  text: '+',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14.fontMultiplier,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kPrimaryColor)),
            ]));
  }
}

class SavingWidget extends StatelessWidget {
  const SavingWidget({super.key, required this.plan});

  final OneTimePlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.colorTextPrimary))),
      child: Text(
        '${'save'.tr} ${plan.savingBy}%',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 8.fontMultiplier,
              fontWeight: FontWeight.w600,
              color: AppColors.colorTextPrimary,
            ),
      ),
    );
  }
}
