import 'package:flutter/material.dart';


class CommonCardWidget extends StatelessWidget {
  Color? backgroundColor;
  BorderRadius? borderRadius;
  EdgeInsets? margin;
  Widget? child;
  EdgeInsets? padding;

  double? width;
  double? height;
  VoidCallback? onTap;

  CommonCardWidget({
    super.key,
    this.child,
    this.backgroundColor,
    this.borderRadius,
    this.margin,
    this.padding,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(16.0),
        margin: margin ?? const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(20.0),
            color: backgroundColor ?? Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 10.0,
              ),
            ]),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
