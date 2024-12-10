


import 'package:flutter/material.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/utils/extensions/extensions.dart';

class StepWidget extends StatelessWidget {
  const StepWidget({
    super.key,
    required this.stepNo,
    required this.title,
    required this.isSelected,
  });

final   int stepNo;
final   String  title;
final   bool  isSelected;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration:   BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected? AppColors.kPrimaryColor: AppColors.colorC2
          ),
          child: Text(
              stepNo.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontSize: 14.fontMultiplier
            )),
        ),
      Padding(
        padding: const EdgeInsets.only(top :8.0),
        child: Text(title,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: isSelected ? Colors.black: AppColors.colorC2,
          fontSize: 14.fontMultiplier
        ),),
      )
      ],);


  }
}
