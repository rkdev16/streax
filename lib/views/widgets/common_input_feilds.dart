import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class CommonInputField extends StatefulWidget {
  double? height;
  Widget? suffixIcon;
  String hint;
  String? title;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  TextEditingController controller;
  TextInputType? inputType;
  List<TextInputFormatter>? inputFormatter;
  bool? isShowHelperText;
  Widget? leading;
  EdgeInsets? margin;
  int? minLines;
  int? maxLines;
  bool? clearFieldEnable;
  EdgeInsets? contentPadding;
  Color? backgroundColor;
  TextCapitalization? textCapitalization;
  bool? readOnly;
  bool? enabled;
  bool counterText;
  int? maxLength;

  CommonInputField(
      {super.key,
      required this.controller,
      required this.hint,
      this.onChanged,
      this.title,
      this.counterText = false,
      this.validator,
      this.inputType,
      this.inputFormatter,
      this.isShowHelperText,
      this.leading,
      this.margin,
      this.suffixIcon,
      this.height,
      this.backgroundColor,
      this.minLines,
      this.maxLines,
      this.contentPadding,
      this.clearFieldEnable,
      this.textCapitalization,
      this.readOnly,
      this.enabled,
      this.maxLength});

  @override
  State<CommonInputField> createState() => _CommonInputFieldState();
}

class _CommonInputFieldState extends State<CommonInputField> {
  bool isFieldEmpty = true;

  var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.transparent));

  var errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.title ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.colorTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.fontMultiplier,
                    ),
              ),
            ),
          TextFormField(
            textAlign: TextAlign.start,
            controller: widget.controller,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 14.fontMultiplier, color: AppColors.colorTextPrimary),
            keyboardType: widget.inputType ?? TextInputType.text,
            cursorColor: AppColors.kPrimaryColor,
            maxLines: widget.maxLines ?? 1,
            minLines: widget.minLines ?? 1,
            maxLength: widget.maxLength,
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.sentences,
            readOnly: widget.readOnly ?? false,
            enabled: widget.enabled ?? true,
            decoration: InputDecoration(
                hintText: widget.hint.tr,
                hintStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 14.fontMultiplier, color: AppColors.colorC2),
                prefixIcon: widget.leading,
                suffixIcon: (widget.clearFieldEnable ?? false)
                    ? isFieldEmpty
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              widget.controller.clear();
                            },
                            icon: const Icon(Icons.close))
                    : widget.suffixIcon,
                filled: true,
                fillColor: widget.backgroundColor ?? AppColors.colorF3,
                //  helperText: isShowHelperText??true? 'message_password_helper'.tr : null,
                helperMaxLines: 2,
                errorMaxLines: 3,
                helperStyle: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                        fontSize: 14.fontMultiplier,
                        fontWeight: FontWeight.w500,
                        color: AppColors.color95),
                errorStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 12.fontMultiplier,
                    fontWeight: FontWeight.w300,
                    color: Colors.red),
                contentPadding:
                    widget.contentPadding ?? const EdgeInsets.all(12),
                border: inputBorder,
                errorBorder: inputBorder,
                enabledBorder: inputBorder,
                disabledBorder: inputBorder,
                counterText: widget.counterText ? '' : null,
                focusedBorder: inputBorder,
                focusedErrorBorder: inputBorder),
            inputFormatters: widget.inputFormatter,
            validator: widget.validator,
            onChanged: widget.onChanged ??
                (String value) {
                  setState(() {
                    isFieldEmpty = value.isEmpty;
                  });
                },
          ),
        ],
      ),
    );
  }
}
