import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/controller/premium/subscription_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/pages/permium/components/one_time_plan_section_widget.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';
import '../../../config/app_colors.dart';
import '../../../route/app_routes.dart';

class OneTimePurchaseScreen extends StatelessWidget {
  OneTimePurchaseScreen({super.key});

  final _subscriptionsController = Get.find<SubscriptionsController>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
      child: Scaffold(
        appBar: CommonAppBar(
          onBackTap: () {
            Get.back();
          },
          title: 'streax_store'.tr,
        ),
        body: Obx(
          () => _subscriptionsController.isLoadingOneTimePurchase.value
              ? const CommonProgressBar()
              : ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  children: [
                    ..._subscriptionsController.oneTimePlans
                        .map((planData) => OneTimePlanSectionWidget(
                              plansData: planData,
                            )),
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              children: [
                            TextSpan(
                                text: "upgrade_premium_account".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        height: 1.6,
                                        fontSize: 14.5.fontMultiplier,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.colorTextPrimary)),
                            TextSpan(
                                text: '+',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        height: 1.6,
                                        fontSize: 15.5.fontMultiplier,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.kPrimaryColor)),
                            TextSpan(
                                text: 'account_starting'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        height: 1.6,
                                        fontSize: 14.5.fontMultiplier,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.colorTextPrimary)),
                            TextSpan(
                                text: '\$4.99',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        height: 1.6,
                                        fontSize: 15.5.fontMultiplier,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.colorTextPrimary)),
                          ]),
                        )),
                    CommonButton(
                        text: "browse_subscription_plan".tr,
                        onPressed: () {
                          Get.toNamed(AppRoutes.routeSubscriptionPlansScreen);
                        })
                  ],
                ),
        ),
      ),
    );
  }
}
