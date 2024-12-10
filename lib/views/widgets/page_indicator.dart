import 'package:flutter/cupertino.dart';

import '../../config/app_colors.dart';

class PageIndicator extends StatelessWidget {


 const  PageIndicator({super.key,
    required this.selectedIndex,
    required this.length});



  final  int length;
  final  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal ,
        itemCount: length,
        shrinkWrap: true,
        itemBuilder: (context,position){
          return AnimatedContainer(
            margin: const EdgeInsets.only(left: 8),
            width: position == selectedIndex? 30:15,
            height: 6,
            decoration: BoxDecoration(
                color:  position == selectedIndex ? AppColors.kPrimaryColor :
                AppColors.kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24)
            ), duration: const Duration(milliseconds: 300),
          );

        });
  }
}