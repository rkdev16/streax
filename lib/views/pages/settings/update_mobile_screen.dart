import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/controller/settings/update_mobile_controller.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/views/dialogs/common/country_code_picker_dialog.dart';
import 'package:streax/views/widgets/common_button.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import '../../../utils/validations.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_phone_input_field.dart';

class UpdateMobileScreen extends StatelessWidget {
  UpdateMobileScreen({super.key});
  final _updateMobileController = Get.find<UpdateMobileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CommonAppBar(
        backgroundColor: Colors.white,
        title: 'update_mobile_number'.tr,
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
              child: Text('phone_number'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 14.fontMultiplier,
                fontWeight: FontWeight.w600
              ),),
            ),
            
           
            
              CommonPhoneInputField(
                validator: Validations.checkPhoneValidations,
                inputType: TextInputType.number,
                controller: _updateMobileController.phoneController,
                hint: 'phone_number'.tr,
                countryCodePickerCallback: () => CountryCodePickerDialog.show(
                    context: context, onSelect: _updateMobileController.selectCountry),
                selectedCountry: _updateMobileController.selectedCountry),
               // CommonInputField(
               //  margin: const EdgeInsets.only(top: 10, bottom: 10),
               //  validator: Validations.checkEmailValidations,
               //  controller: widget.emailController,
               //  hint: "email_address".tr),
        
        
        
            Container(
              alignment: Alignment.centerRight,
              child: Obx(
                    ()=> Visibility(
                    visible: _updateMobileController.isUserExist.value,
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
