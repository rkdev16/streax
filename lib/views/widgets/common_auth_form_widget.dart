import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/enums.dart';
import 'package:streax/route/app_routes.dart';
import 'package:streax/utils/extensions/extensions.dart';
import 'package:streax/utils/validations.dart';
import 'package:streax/views/dialogs/common/country_code_picker_dialog.dart';
import 'package:streax/views/widgets/common_card_widget.dart';
import 'package:streax/views/widgets/common_input_feilds.dart';
import 'package:streax/views/widgets/common_password_input_feilds.dart';
import 'package:streax/views/widgets/common_phone_input_field.dart';

class CommonAuthFormWidget extends StatefulWidget {
   CommonAuthFormWidget({
    super.key,
    required this.authFormType,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.selectedCountry,
     required this.formKey,
     this.isUserExist,
     required this.onAuthTypeChange




  });

  final AuthFormType authFormType;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final Rx<Country?> selectedCountry;
  Rx<bool>? isUserExist ;
  final GlobalKey<FormState> formKey;
  final Function(AuthType authType) onAuthTypeChange;

  @override
  State<CommonAuthFormWidget> createState() => _CommonAuthFormWidgetState();
}

class _CommonAuthFormWidgetState extends State<CommonAuthFormWidget> {

  AuthType authType = AuthType.phone;


  @override
  void initState() {
    super.initState();
    widget.isUserExist = RxBool(false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: CommonCardWidget(
        padding: const  EdgeInsets.only(left: 16,right: 16,top: 16),
        child: AnimatedSwitcher(
          duration: const  Duration(milliseconds: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authType == AuthType.email ? "email_address".tr : 'phone_number'.tr,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.colorTextPrimary, fontSize: 14.fontMultiplier),
              ),
            if(authType == AuthType.phone)  CommonPhoneInputField(
              validator: Validations.checkPhoneValidations,
                  errorMaxLines: 2,

                  inputType: TextInputType.number,
                  controller: widget.phoneController,
                  hint: 'phone_number'.tr,
                  countryCodePickerCallback: () => CountryCodePickerDialog.show(
                      context: context, onSelect: widget.selectedCountry),
                  selectedCountry: widget.selectedCountry),
              if(authType == AuthType.email)    CommonInputField(
                  textCapitalization: TextCapitalization.none,
                  validator: Validations.checkEmailValidations,
                  controller: widget.emailController,
                  hint: "email_address".tr),



              Container(
                alignment: Alignment.centerRight,
                child: Obx(
                         ()=> Visibility(
                    visible: widget.isUserExist!.value,
                      child: Text('user_already_exists'.tr,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 12.fontMultiplier,
                        fontWeight: FontWeight.w600,

                        color: Colors.redAccent
                      ),)),
                ),
              ),


              Text(
               "password".tr,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.colorTextPrimary, fontSize: 14.fontMultiplier),
              ),

              CommonPasswordInputField(
                  margin: const EdgeInsets.only(top: 10.0),
                  validator: widget.authFormType == AuthFormType.signIn ?   Validations.checkEmptyFiledValidations : Validations.checkPasswordValidations,
                  controller: widget.passwordController,
                  hint: "message_enter_password".tr),








              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                     overlayColor: MaterialStateProperty.all(Colors.grey.shade50),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap
                    ),
                      onPressed: (){
                    setState(() {
                      authType = authType == AuthType.phone
                          ? AuthType.email
                          : AuthType.phone;

                    });
                    widget.onAuthTypeChange(authType);
                    widget.isUserExist!.value = false;
                    widget.emailController.clear();
                    widget.phoneController.clear();
                  }, child:  Text(
                      authType == AuthType.phone
                          ? widget.authFormType == AuthFormType.signIn
                          ? "sign_in_with_email".tr
                          : "sign_up_with_email".tr
                          : widget.authFormType == AuthFormType.signIn
                          ? "sign_in_with_phone".tr
                          : "sign_up_with_phone".tr,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontSize: 12.0.fontMultiplier,
                          color: AppColors.kPrimaryColor))),



               if(widget.authFormType  ==AuthFormType.signIn)
                 TextButton(
                   style: ButtonStyle(
                       padding: MaterialStateProperty.all(EdgeInsets.zero),
                       overlayColor: MaterialStateProperty.all(Colors.grey.shade50),
                       tapTargetSize: MaterialTapTargetSize.shrinkWrap
                   ),
                     onPressed: (){
                    Get.toNamed(AppRoutes.routeForgotPasswordScreen,arguments: {
                      'auth_type':authType
                    });
                  }, child:  Text(
                    "forgot_password?".tr,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.kPrimaryColor,
                      fontSize: 12.fontMultiplier,
                    ),
                  ))


                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
