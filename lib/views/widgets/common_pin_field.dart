

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';




const int defaultLength = 4;
class CommonPinField extends StatefulWidget {
   CommonPinField({
    super.key,
    this.pinLength,
    required this.textEditingController,
     required this.onComplete,
     this.onChanged,
     this.focusNode
    
  });



  final int? pinLength;
  final TextEditingController textEditingController;
  final Function(String pin) onComplete;
  final Function(String pin)? onChanged;
  final FocusNode? focusNode;

 final  defaultPinTheme = PinTheme(
    width: 62,
    height: 60,
    margin: const  EdgeInsets.symmetric(horizontal: 4),
    textStyle: Theme.of(Get.context!).textTheme.headlineLarge?.copyWith(
      fontSize: 28.fontMultiplier,
      color: AppColors.colorTextPrimary,
      fontWeight: FontWeight.w700,
    ),
    decoration: BoxDecoration(
      color: AppColors.colorF3,
      borderRadius: BorderRadius.circular(10),
    ),
  );




  @override
  State<CommonPinField> createState() => _CommonPinFieldState();
}





class _CommonPinFieldState extends State<CommonPinField> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Pinput(
      pinAnimationType: PinAnimationType.scale,
      length: widget.pinLength??defaultLength,
      defaultPinTheme: widget.defaultPinTheme,
      focusedPinTheme: widget.defaultPinTheme.copyDecorationWith(
        color:Colors.white,
        border:  const Border.fromBorderSide(BorderSide(color: AppColors.kPrimaryColor)),
        borderRadius: BorderRadius.circular(10),
      ),
      submittedPinTheme: widget.defaultPinTheme.copyDecorationWith(
        color: Colors.white,
        border:  const Border.fromBorderSide(BorderSide(color: AppColors.kPrimaryColor)),
        borderRadius: BorderRadius.circular(10),
      ),
      onCompleted: widget.onComplete,
      onChanged: widget.onChanged,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
    );
  }


}
