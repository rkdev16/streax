import 'package:flutter/cupertino.dart';

import '../consts/app_consts.dart';

class SizeConfig {

  SizeConfig._();

  static late double screenWidth;
  static late double screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static late double widthMultiplier;
  static late double heightMultiplier;

  static late Orientation orientation;
  static late bool isMobile;

  static  init(BoxConstraints constraints, Orientation orientation) {
    SizeConfig.orientation = orientation;
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;

    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;
    widthMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    isMobile = data.size.shortestSide < 550;
  }

  static double fontMultiplier = (SizeConfig.isMobile
      ? AppConsts.mobileFontFactor
      : AppConsts.tabFontFactor);
}