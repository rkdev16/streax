import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/views/pages/profile_setup/components/common_bg_profile_setup.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import '../../../controller/profile_setup/profile_setup_controller.dart';
import '../../widgets/common_input_feilds.dart';

class SetupAdditionalInfo extends StatelessWidget {
  SetupAdditionalInfo({Key? key}) : super(key: key);
  final _profileSetupController = Get.find<ProfileSetupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonBgProfileSetup(
        pageNo: 3,
        child: ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _profileSetupController.additionalInfoFormKey,
              child: CommonCardWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonInputField(
                      title: "work".tr,
                      suffixIcon: const SizedBox.shrink(),
                      controller: _profileSetupController.workAtController,
                      hint: "hint_work".tr,
                      counterText: true,
                      maxLength: 84,
                      minLines: 1,
                      maxLines: 5,

                    ),
                    CommonInputField(
                      title: "education".tr,
                      suffixIcon: const SizedBox.shrink(),
                      controller: _profileSetupController.schoolController,
                      hint: "hint_education".tr,
                      maxLength: 84,
                      counterText: true,
                      minLines: 1,
                      maxLines: 5,
                    ),
                    CommonInputField(
                      title: "lives_in".tr,
                      suffixIcon: const SizedBox.shrink(),
                      controller: _profileSetupController.livesInController,
                      hint: "hint_lives_in".tr,
                      maxLength: 72,
                      counterText: true,
                      minLines: 1,
                      maxLines: 5,
                    ),
                    CommonInputField(
                      title: "From".tr,
                      suffixIcon: const SizedBox.shrink(),
                      controller: _profileSetupController.fromController,
                      hint: "hint_from_address".tr,
                      maxLength: 72,
                      counterText: true,
                      minLines: 1,
                      maxLines: 5,
                    ),
                    CommonInputField(
                      title: "about_me".tr,
                      controller: _profileSetupController.aboutMeController,
                      hint: "hint_about_me".tr,
                      maxLines: 5,
                      minLines: 5,
                      maxLength: 500,
                    ),
                  ],
                ),
              ),
            ),
            CommonButton(
                text: 'done'.tr,
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 24),
                onPressed: () {
                  _profileSetupController.validateAdditionalInfoForm();
                })
          ],
        ),
      ),
    );
  }
}
