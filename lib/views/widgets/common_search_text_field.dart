
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:streax/utils/extensions/extensions.dart';
import '../../config/app_colors.dart';

class CommonSearchTextFiled extends StatefulWidget {
  double? height;
  Widget? suffixIcon;
  String? labelText;
  String? hintText;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  TextEditingController controller;
  TextInputType? inputType;
  List<TextInputFormatter>? inputFormatter;
  bool? isShowHelperText;
  bool? isEnabled;
  Widget? prefix;
  EdgeInsets? margin;
  bool? isShowText;
  Color? backgroundColor;
  Widget? requiredIcon;
  VoidCallback? onTap;
  Color? hintTextColor;
  int? maxLines;
  int? minLines;
  int? maxLength;
  TextCapitalization? textCapitalization;




  CommonSearchTextFiled({
    super.key,
    required this.controller,
    this.onChanged,
    this.validator,
    this.inputType,
    this.inputFormatter,
    this.isShowHelperText,
    this.prefix,
    this.margin,
    this.suffixIcon,
    this.isShowText,
    this.height,
    this.backgroundColor,
    this.requiredIcon,
    this.hintText,
    this.labelText,
    this.onTap,
    this.hintTextColor,
    this.isEnabled,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.textCapitalization,


  });

  @override
  State<CommonSearchTextFiled> createState() => _CommonSearchTextFiledState();
}

class _CommonSearchTextFiledState extends State<CommonSearchTextFiled> {
  RxBool isObscure = true.obs;

  var errorInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:  const BorderSide(  color: Colors.redAccent));

  var inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
      BorderSide(color:  AppColors.colorTextPrimary.withOpacity(0.2)));

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
         height: widget.height ?? 50,
        margin: widget.margin ?? const EdgeInsets.only(
            left: 16.0, right: 16, bottom: 12.0,top: 8.0),
        child: TextFormField(
          controller: widget.controller,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.colorTextPrimary.withOpacity(0.7),
              fontSize: 12.fontMultiplier),
          textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
          maxLines: widget.maxLines ?? 1,
          minLines: widget.minLines ?? 1,
          maxLength: widget.maxLength,
          keyboardType: widget.inputType ?? TextInputType.visiblePassword,
          cursorColor: AppColors.kPrimaryColor,
          decoration: InputDecoration(
              fillColor: widget.backgroundColor,
              filled: true,
              enabled: widget.isEnabled ?? true,
              hintText: widget.hintText?.tr,
              hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 12.fontMultiplier,
                  color: AppColors.colorTextPrimary.withOpacity(0.3)),
              // label: RichText(
              //     text: TextSpan(
              //       text: labelText.tr,
              //       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              //           fontSize: 12.fontMultiplier,
              //           color: AppColors.colorTextPrimary.withOpacity(0.3),fontWeight: FontWeight.w400),
              //
              //     )),

              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.colorTextPrimary.withOpacity(0.3)),
              prefixIcon: widget.prefix,
              suffixIcon: widget.controller.text.isNotEmpty ? IconButton(onPressed: (){
                widget.controller.clear();
                setState(() {});
              },
                  icon: const  Icon(Icons.cancel,color: AppColors.colorTextSecondary,)): widget.suffixIcon,
              helperMaxLines: 2,
              errorMaxLines: 3,
              helperStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.colorTextPrimary.withOpacity(0.3)),
              errorStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 12.fontMultiplier,
                  fontWeight: FontWeight.w300,
                  color: AppColors.colorRed),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16,),
              border: inputBorder,
              errorBorder: inputBorder,
              enabledBorder: inputBorder,
              disabledBorder: inputBorder,
              focusedBorder: inputBorder,
              focusedErrorBorder: inputBorder),
          inputFormatters: widget.inputFormatter,
          validator: widget.validator,
          onChanged: (String value){
            debugPrint("onChanged = $value");
            if(widget.onChanged !=null){
              widget.onChanged!(value);
            }
            setState(() {
            });

          },
        ),
      ),
    );
  }
}
