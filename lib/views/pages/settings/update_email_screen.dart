


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/controller/settings/update_email_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/widgets/common_app_bar.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';

class UpdateEmailScreen extends StatelessWidget {
   UpdateEmailScreen({super.key});

  final _updateEmailController = Get.find<UpdateEmailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: CommonAppBar(
        backgroundColor: Colors.white,
        title: 'update_email'.tr,
        onBackTap: () {
          Get.back();
        },
      ),
      body: CommonCardWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('email_address'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14.fontMultiplier,
                  fontWeight: FontWeight.w600
              ),),
            ),
            CommonInputField(
             margin: const EdgeInsets.only(top: 10, bottom: 10),
             validator: Validations.checkEmailValidations,
             controller: _updateEmailController.emailController,
             hint: "email_address".tr),
            Container(
              alignment: Alignment.centerRight,
              child: Obx(
                    ()=> Visibility(
                    visible: _updateEmailController.isUserExist.value,
                    child: Text('user_exists'.tr,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 12.fontMultiplier,
                        fontWeight: FontWeight.w600,

                        color: Colors.redAccent
                    ),)),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CommonButton(
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        text: 'update'.tr,
        onPressed: () {},
      ),
    );
  }
}
