import 'package:flutter/material.dart';
import 'package:streax/config/app_colors.dart';

class CommonProgressBar extends StatelessWidget {
  const CommonProgressBar({
    super.key,
    this.size,
    this.strokeWidth
  });

 final  double? size;
final   double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return  Center(child: SizedBox(
      height: size,
      width: size,
      child:  CircularProgressIndicator(
        backgroundColor: Colors.grey,
        color: AppColors.kPrimaryColor,
        strokeWidth: strokeWidth??4.0,

      ) ,
    ),);
  }








  // const CupertinoActivityIndicator(
  // color: AppColors.kPrimaryColor,
  // radius: 16,
  //
  // )




}
