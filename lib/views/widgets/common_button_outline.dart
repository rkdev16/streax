import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';

class CommonButtonOutline extends StatelessWidget {
  String text;
  Color? borderColor;
  Color? textColor;
  VoidCallback? onPressed;
  RxBool? isEnable = false.obs;
  double? borderRadius;
  double? elevation;
  EdgeInsets? margin;
  Color? backgroundColor;
  TextStyle? textStyle;
  double? height;
  double? width;

  CommonButtonOutline(
      {super.key,
        required this.text,
        this.textColor,
        this.borderColor,
        required this.onPressed,
        this.isEnable,
        this.borderRadius,
        this.elevation,
        this.margin,
        this.backgroundColor,
        this.textStyle,
        this.width,
        this.height,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?? double.infinity,
      height: height?? 51,
      margin: margin?? const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      decoration: const BoxDecoration(),
      child: Obx(
            () => ElevatedButton(
          onPressed: isEnable?.value??RxBool(true).value ? onPressed: null,
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(backgroundColor??Colors.white),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius??10),
                side: BorderSide(color: borderColor??AppColors.kPrimaryColor),

              )),
              elevation: MaterialStateProperty.all(elevation??2.0)
          ),
          child: Center(
            child: Text(
              text.tr,
              style: textStyle?? Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: textColor ?? AppColors.kPrimaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
