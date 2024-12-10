import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';


class CommonPhoneInputField extends StatelessWidget {
  String hint;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  String? Function(String?)? validator;
  TextEditingController controller;
  TextInputType? inputType;
  EdgeInsets? margin;

  List<TextInputFormatter>? inputFormatter;
  VoidCallback countryCodePickerCallback;
  var selectedCountry = Rx<Country?>(null);
  Widget? leading;
  FocusNode? focusNode;
  bool? autoFocus;
  TextInputAction? textInputAction;
  Color? backgroundColor;
  Color? hintTextColor;
  Color? textColor;
  final int? errorMaxLines;

  //InputBorderType? inputBorderType;

  var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide:
          BorderSide(color: AppColors.colorTextPrimary.withOpacity(0.0)));

  // var errorInputBorder = OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(8.0),
  //     borderSide: const BorderSide(color: Colors.red));

  CommonPhoneInputField(
      {super.key,
      required this.controller,
      required this.hint,
      this.onChanged,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.margin,
      required this.countryCodePickerCallback,
      required this.selectedCountry,
      this.leading,
      this.focusNode,
      this.autoFocus,
      this.textInputAction,
      this.onFieldSubmitted,
      this.backgroundColor,
      this.hintTextColor,
      this.textColor,
      this.errorMaxLines
      //this.inputBorderType
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.colorF3,
                  borderRadius: BorderRadius.circular(6)),
              child: Obx(
                () => TextButton.icon(
                    onPressed: countryCodePickerCallback,
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            AppColors.colorTextPrimary),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 8))),
                    icon: Text(selectedCountry.value?.flagEmoji ?? ""),
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '+${selectedCountry.value?.phoneCode ?? ''}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  color:
                                      textColor ?? AppColors.colorTextPrimary,
                                ),
                          ),
                        ),
                        const Gap(4),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: AppColors.colorTextPrimary.withOpacity(0.5),
                          size: 18,
                        )
                      ],
                    )),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              autofocus: autoFocus ?? false,
              textInputAction: textInputAction,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 12.fontMultiplier,
                  color: textColor ?? AppColors.colorTextPrimary),
              keyboardType: inputType,
              cursorColor: AppColors.kPrimaryColor,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: hint.tr,
                hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.fontMultiplier,
                    color: hintTextColor ?? AppColors.colorTextPrimary),
                fillColor: backgroundColor ?? AppColors.colorF3,
                filled: true,
                border: inputBorder,
                errorBorder: inputBorder,
                enabledBorder: inputBorder,
                disabledBorder: inputBorder,
                focusedBorder: inputBorder,
                focusedErrorBorder: inputBorder,
                errorMaxLines: errorMaxLines ?? 1,
                errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.red),
                contentPadding: const EdgeInsets.all(12),
              ),
              inputFormatters: inputFormatter,
              validator: validator,
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
            ),
          ),
        ],
      ),
    );
  }
}
