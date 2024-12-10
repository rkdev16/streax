import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/views/widgets/common_progress_bar.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback onPressed;
  RxBool? isEnable = true.obs;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final double? borderWidth;
  final RxBool? isLoading;
  final Color? borderColor;


  CommonButton({
    super.key,
    required this.text,
    this.textColor,
    this.backgroundColor,
    required this.onPressed,
    this.isEnable,
    this.borderRadius,
    this.elevation,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.textStyle,
    this.borderWidth,
    this.isLoading,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: (isEnable?.value ?? RxBool(true).value) ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 400),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 51,
          margin: margin ?? const EdgeInsets.symmetric(
                horizontal: 16,
              ),
          child: Obx(
            () => (isLoading?.value ?? false)
                ? Center(
                    child: SizedBox(
                    height: height ?? 51,
                    width: height ?? 51,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CommonProgressBar(),
                    ),
                  ))
                : ElevatedButton(
              onPressed:
              (isEnable?.value ?? RxBool(true).value) ? onPressed : null,
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(elevation),
                        padding: MaterialStateProperty.all(padding?? const EdgeInsets.all(8)),
                        backgroundColor: MaterialStateProperty.all(
                            backgroundColor ?? AppColors.kPrimaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(borderRadius ?? 8),
                            side: BorderSide(
                                color: borderColor ?? Colors.transparent,
                                width: borderWidth ?? 0)))),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Center(
                        child: Text(
                          text.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle ??
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: textColor ?? Colors.white,
                                fontWeight: FontWeight.w600
                                  ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
