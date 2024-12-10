import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/controller/premium/subscription_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/permium/components/subscription_plan_widget.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import 'package:streax/views/widgets/empty_screen_widget.dart';
import 'package:streax/views/widgets/page_indicator.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  SubscriptionPlansScreen({super.key});

  final _subscriptionsController = Get.find<SubscriptionsController>();

  @override
  Widget build(BuildContext context) {
    _subscriptionsController.selectedSubscriptionIndex.value  =1;
    return Scaffold(
      appBar: CommonAppBar(
        onBackTap: () {
          Get.back();
        },
        titleWidget: RichText(
          text: TextSpan(
              text: 'streax'.tr,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.fontMultiplier,
                  color: AppColors.colorTextPrimary,
                  fontWeight: FontWeight.w700),
              children:  [
                TextSpan(text: '+',style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24.fontMultiplier,
                  color: AppColors.kPrimaryColor,
                  fontWeight: FontWeight.w700

                )),

              ]),
        ),
      ),
      body: Obx(
        () => _subscriptionsController.isLoadingSubscriptions.value
            ? const CommonProgressBar()
            : _subscriptionsController.subscriptionPlans.isEmpty
                ? EmptyScreenWidget(
                    title: 'message_no_subscription_plans_available'.tr,
                  )
                : Stack(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16, right: 16, top: 16),
                            child: Text(
                              "subscription_plans".tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 20.fontMultiplier,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.colorTextPrimary),
                            ),
                          ),

                          SizedBox(
                            height: 420,
                            child: PageView(
                              controller: _subscriptionsController.pageController,
                              onPageChanged: (index) {
                                _subscriptionsController
                                    .selectedSubscriptionIndex.value = index;
                              },
                              children: _subscriptionsController.subscriptionPlans
                                  .map((plan) => SubscriptionPlanWidget(plan: plan))
                                  .toList(growable: false),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 24, bottom: 0, top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 8,
                                  margin: const EdgeInsets.only(left: 8),
                                  child: Obx(
                                    () => PageIndicator(
                                        selectedIndex: _subscriptionsController
                                            .selectedSubscriptionIndex.value,
                                        length: _subscriptionsController
                                            .subscriptionPlans.length),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
                        child: Text('subscription_disclaimer'.tr,
                          textAlign: TextAlign.justify,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 8.fontMultiplier,
                          color: AppColors.colorTextPrimary
                        ),),
                      ),
                    )
                  ],
                ),
      ),
    );
  }
}
