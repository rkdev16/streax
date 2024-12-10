import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class CommonPasswordInputField extends StatelessWidget {
  final double? height;
  final Widget? suffixIcon;
  final String hint;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatter;
  RxBool isObscure = true.obs;
  final bool? isShowHelperText;
  final Widget? leading;
  final EdgeInsets? margin;
  final bool? isShowText;
  final String? title;

 final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
          BorderSide(color: AppColors.colorTextPrimary.withOpacity(0.0)));

 final errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red));

   CommonPasswordInputField(
      {super.key,
      required this.controller,
      required this.hint,
      this.onChanged,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.isShowHelperText,
      this.leading,
      this.margin,
      this.suffixIcon,
      this.isShowText,
      this.height,
      this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin ?? const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: title != null,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.colorTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.fontMultiplier,
                    ),
              ),
            ),
          ),
          Obx(
            () => TextFormField(
              textAlign: TextAlign.start,
              controller: controller,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14.fontMultiplier,
                  color: AppColors.colorTextPrimary),
              keyboardType: TextInputType.visiblePassword,
              cursorColor: AppColors.colorTextPrimary.withOpacity(0.2),
              obscureText: isObscure.value,
              obscuringCharacter: '*',
              decoration: InputDecoration(
                  hintText: hint.tr,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                          fontSize: 12.fontMultiplier,
                          color: AppColors.color95),
                  prefixIcon: leading,
                  suffixIcon: IconButton(
                      onPressed: () {
                        isObscure.value = !isObscure.value;
                      },
                      icon: Icon(
                        isObscure.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.colorTextPrimary.withOpacity(0.3),
                        size: 20,
                      )),
                  filled: true,
                  fillColor: AppColors.colorF3,
                  helperMaxLines: 2,
                  errorMaxLines: 3,
                  helperStyle: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                          fontSize: 12.fontMultiplier,
                          fontWeight: FontWeight.w500,
                          color: AppColors.color95),
                  errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 12.fontMultiplier,
                      fontWeight: FontWeight.w300,
                      color: Colors.red),
                  contentPadding: const EdgeInsets.all(12),
                  border: inputBorder,
                  errorBorder: inputBorder,
                  enabledBorder: inputBorder,
                  disabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  focusedErrorBorder: inputBorder),
              inputFormatters: inputFormatter,
              validator: validator,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
