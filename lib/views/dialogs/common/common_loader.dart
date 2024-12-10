

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streax/config/app_colors.dart';

class CommonLoader{

 static BuildContext? _dialogContext;

 CommonLoader.show({BuildContext? context}) {
   showDialog<void>(
       context: context ??Get.context!,
       barrierDismissible: false,
       useSafeArea: false,
       barrierColor: Colors.black.withOpacity(0.2),
       builder: (BuildContext buildContext) {
         _dialogContext = buildContext;
         return const Center(
             child: CupertinoActivityIndicator(
               color: AppColors.kPrimaryColor,
               radius: 16,
             ));
       });
 }

 CommonLoader.dismiss() {
   if (_dialogContext != null) {
     Navigator.of(_dialogContext!).pop();
     _dialogContext = null;
   }
 }



}