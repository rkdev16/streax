


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streax/config/app_colors.dart';
import 'package:streax/consts/app_icons.dart';
import 'package:streax/model/place_predictions_res_model.dart';
import 'package:streax/utils/extensions/extensions.dart';


class SearchAddressCell extends StatelessWidget {



  Prediction prediction;
  VoidCallback? onClick;
   SearchAddressCell({
    super.key,
   required this.prediction,
     this.onClick
   });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          SvgPicture.asset(AppIcons.icMarkerFilled,width: 18,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(prediction.description??"",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 15.fontMultiplier,
                color: AppColors.colorTextPrimary
              ),),
            ),
          ),
          ],),
      ),
    );
  }
}
